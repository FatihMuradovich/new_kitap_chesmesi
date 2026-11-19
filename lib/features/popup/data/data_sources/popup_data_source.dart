import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/popup/data/models/popup_model.dart';

class PopupDataSource {
  final DioClient dioClient;
  static const String _popupEndpoint = '/en/popup/latest';

  PopupDataSource({required this.dioClient});

  Future<PopupModel?> getLatestPopup() async {
    try {
      log('🔍 Fetching latest popup...', name: 'PopupDataSource');
      final response = await dioClient.dio.get(
        _popupEndpoint,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log('📡 Response status: ${response.statusCode}', name: 'PopupDataSource');
      log('📦 Response data: ${response.data}', name: 'PopupDataSource');

      if (response.statusCode == 401) {
        log(
          '⚠️ $_popupEndpoint 401 — JWT olmadan bu rota kapalı; misafir kullanıcılar '
          'popup göremez. Sunucuda bu GET için @Public() veya ayrı misafir endpoint '
          'açın.',
          name: 'PopupDataSource',
        );
        return null;
      }

      if (response.statusCode != 200) {
        log('⚠️ Unexpected status: ${response.statusCode}', name: 'PopupDataSource');
        return null;
      }

      final payload = _extractPopupPayload(response.data);
      if (payload == null) {
        log('⚠️ No popup payload in response', name: 'PopupDataSource');
        return null;
      }

      final popup = PopupModel.fromJson(payload);
      log('✅ Popup loaded: ${popup.title}', name: 'PopupDataSource');
      return popup;
    } catch (e) {
      log('❌ Error fetching popup: $e', name: 'PopupDataSource');
      return null;
    }
  }

  /// `data` tek nesne, liste veya kökte düz alanlar olabilir.
  Map<String, dynamic>? _extractPopupPayload(dynamic raw) {
    if (raw is! Map) return null;
    final root = Map<String, dynamic>.from(raw);
    final data = root['data'];

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is List && data.isNotEmpty && data.first is Map) {
      return Map<String, dynamic>.from(data.first as Map);
    }
    if (root.containsKey('path') && root.containsKey('id')) {
      return root;
    }
    return null;
  }
}
