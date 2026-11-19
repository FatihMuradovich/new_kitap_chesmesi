import 'dart:io';

import 'package:app_version_update/app_version_update.dart';
import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum UpdateEnforcement {
  optional,
  mandatory,
}

class UpdateCheckResult {
  final bool isUpdateAvailable;
  final bool isMandatory;
  final String currentVersion;
  final String storeVersion;
  final String? storeUrl;
  final String? errorMessage;

  const UpdateCheckResult({
    required this.isUpdateAvailable,
    required this.isMandatory,
    required this.currentVersion,
    required this.storeVersion,
    this.storeUrl,
    this.errorMessage,
  });

  bool get hasError => errorMessage != null;
}

class UpdateService {
  final String playStoreId;
  /// Numeric App Store ID; null/empty → package uses bundle ID for lookup.
  final String? appleId;
  /// iTunes country code for iOS lookup (optional).
  final String? appStoreCountry;
  final UpdateEnforcement defaultEnforcement;
  bool _dialogShownInSession = false;

  UpdateService({
    required this.playStoreId,
    this.appleId,
    this.appStoreCountry,
    this.defaultEnforcement = UpdateEnforcement.optional,
  });

  bool get hasShownDialogInSession => _dialogShownInSession;

  void markDialogShownInSession() {
    _dialogShownInSession = true;
  }

  Future<UpdateCheckResult> checkForUpdate({
    UpdateEnforcement? enforcement,
  }) async {
    final effectiveEnforcement = enforcement ?? defaultEnforcement;
    final currentVersion = await _safeCurrentVersion();

    if (Platform.isAndroid) {
      try {
        final response = await AppVersionUpdate.checkForUpdates(
          playStoreId: playStoreId,
        );
        return _resultFromStoreResponse(
          response,
          currentVersion,
          effectiveEnforcement,
        );
      } catch (e) {
        return UpdateCheckResult(
          isUpdateAvailable: false,
          isMandatory: false,
          currentVersion: currentVersion,
          storeVersion: '',
          errorMessage: e.toString(),
        );
      }
    }

    if (Platform.isIOS) {
      try {
        final response = await AppVersionUpdate.checkForUpdates(
          appleId: (appleId != null && appleId!.trim().isNotEmpty)
              ? appleId!.trim()
              : null,
          country: (appStoreCountry != null && appStoreCountry!.trim().isNotEmpty)
              ? appStoreCountry!.trim()
              : null,
        );
        return _resultFromStoreResponse(
          response,
          currentVersion,
          effectiveEnforcement,
        );
      } catch (e) {
        return UpdateCheckResult(
          isUpdateAvailable: false,
          isMandatory: false,
          currentVersion: currentVersion,
          storeVersion: '',
          errorMessage: e.toString(),
        );
      }
    }

    return UpdateCheckResult(
      isUpdateAvailable: false,
      isMandatory: false,
      currentVersion: currentVersion,
      storeVersion: '',
    );
  }

  UpdateCheckResult _resultFromStoreResponse(
    AppVersionResult response,
    String currentVersion,
    UpdateEnforcement effectiveEnforcement,
  ) {
    final storeVersion = (response.storeVersion ?? '').trim();
    final storeUrl = (response.storeUrl ?? '').trim();

    final bool isStoreVersionNewer = storeVersion.isNotEmpty &&
        _isStoreVersionNewer(
          storeVersion: storeVersion,
          localVersion: currentVersion,
        );

    final bool isUpdateAvailable =
        isStoreVersionNewer || (response.canUpdate ?? false);

    return UpdateCheckResult(
      isUpdateAvailable: isUpdateAvailable,
      isMandatory: isUpdateAvailable &&
          effectiveEnforcement == UpdateEnforcement.mandatory,
      currentVersion: currentVersion,
      storeVersion: storeVersion,
      storeUrl: storeUrl.isEmpty ? null : storeUrl,
    );
  }

  /// Opens Play Store (Android) or App Store page (iOS).
  Future<bool> openStore(UpdateCheckResult result) async {
    if (Platform.isAndroid) {
      final fallbackUrl =
          'https://play.google.com/store/apps/details?id=$playStoreId';
      final targetUrl = result.storeUrl ?? fallbackUrl;
      final uri = Uri.parse(targetUrl);
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    if (Platform.isIOS) {
      String? targetUrl = result.storeUrl;
      if (targetUrl == null || targetUrl.isEmpty) {
        final id = appleId?.trim();
        if (id != null && id.isNotEmpty) {
          targetUrl = 'https://apps.apple.com/app/id$id';
        }
      }
      if (targetUrl == null || targetUrl.isEmpty) {
        return false;
      }
      return launchUrl(
        Uri.parse(targetUrl),
        mode: LaunchMode.externalApplication,
      );
    }

    return false;
  }

  /// Kept for backward compatibility; use [openStore].
  Future<bool> openPlayStore(UpdateCheckResult result) => openStore(result);

  bool _isStoreVersionNewer({
    required String storeVersion,
    required String localVersion,
  }) {
    final storeParts = _normalizeVersionParts(storeVersion);
    final localParts = _normalizeVersionParts(localVersion);
    final maxLength = storeParts.length > localParts.length
        ? storeParts.length
        : localParts.length;

    for (int i = 0; i < maxLength; i++) {
      final storePart = i < storeParts.length ? storeParts[i] : 0;
      final localPart = i < localParts.length ? localParts[i] : 0;

      if (storePart > localPart) {
        return true;
      }
      if (storePart < localPart) {
        return false;
      }
    }

    return false;
  }

  List<int> _normalizeVersionParts(String version) {
    return version
        .trim()
        .split(RegExp(r'[^\d]+'))
        .where((part) => part.isNotEmpty)
        .map(int.parse)
        .toList();
  }

  Future<String> _safeCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version.trim();
      if (version.isEmpty) {
        return '0.0.0';
      }
      return version;
    } on MissingPluginException {
      // Plugin can be unavailable in some startup/hot-reload situations.
      return '0.0.0';
    } catch (_) {
      return '0.0.0';
    }
  }
}
