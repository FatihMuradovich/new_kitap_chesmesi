import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/common/utils/network_error.dart';

class DioClient {
  /// Refresh isteğinin kendisi 401 döndüğünde interceptor'ın tekrar refresh denemesini
  /// ve süresi dolmuş access token'ın Authorization'a eklenmesini engeller.
  static const String kSkipTokenRefresh = 'skipTokenRefresh';
  static const String _kRetried = 'retriedAfterRefresh';

  final FlutterSecureStorage secureStorage;
  final TalkerDioLogger talkerDioLogger;
  final Dio _dio;
  final LanguageService _languageService = di<LanguageService>();

  /// [enableLogging] varsayılan olarak yalnızca debug'da açıktır: ağ logları
  /// Authorization başlığı, telefon numarası ve şifre içerebilir.
  DioClient(
    this.secureStorage,
    this._dio,
    this.talkerDioLogger, {
    bool enableLogging = kDebugMode,
  }) {
    _dio.interceptors.addAll([
      if (enableLogging) talkerDioLogger,
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final skipRefreshFlow = options.extra[kSkipTokenRefresh] == true;
          // Refresh endpoint'ine süresi dolmuş Bearer göndermeyi atla
          if (!skipRefreshFlow) {
            final token = await getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } else {
            options.headers.remove('Authorization');
          }

          // Locale header - use API-compatible language code
          options.headers['Accept-Language'] = _languageService.apiLanguageCode;

          // Ensure language code prefix exists if not already present and not an auth endpoint
          final langSegment = _languageService.apiLanguageCode;
          final path = options.path.startsWith('/')
              ? options.path.substring(1)
              : options.path;
          final isAuthEndpoint = path.startsWith('auth/');
          final alreadyPrefixed = path.startsWith('tm/') ||
              path.startsWith('ru/') ||
              path.startsWith('en/');

          // Skip prefixing for auth endpoints since they should be called manually with language prefix
          // or for paths that already have language prefix
          if (!isAuthEndpoint && !alreadyPrefixed) {
            options.path = '$langSegment/$path';
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          _markOnline();
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (isConnectionError(e)) {
            _offline = true;
          } else if (e.response != null) {
            // Sunucu yanıt verdi (4xx/5xx): bağlantı var.
            _markOnline();
          }
          final options = e.requestOptions;
          final shouldTryRefresh = e.response?.statusCode == 401 &&
              options.extra[kSkipTokenRefresh] != true &&
              options.extra[_kRetried] != true;
          if (!shouldTryRefresh) return handler.next(e);

          final newToken = await _validTokenAfter401(options);
          if (newToken == null) return handler.next(e);

          // Yalnızca bir kez tekrar dene; tekrar da 401 alırsa döngüye girme.
          options.extra[_kRetried] = true;
          options.headers['Authorization'] = 'Bearer $newToken';
          try {
            return handler.resolve(await _dio.fetch(options));
          } on DioException catch (retryError) {
            return handler.next(retryError);
          }
        },
      ),
    ]);
  }

  final _connectionRestored = StreamController<void>.broadcast();
  bool _offline = false;

  /// Bağlantı hatası görüldükten sonra sunucudan ilk yanıt geldiğinde bir kez
  /// tetiklenir. Hata durumunda kalmış diğer ekranlar bununla kendiliğinden
  /// yenilenir; kullanıcı her sekmede ayrı ayrı "tekrar dene"ye basmaz.
  Stream<void> get onConnectionRestored => _connectionRestored.stream;

  void _markOnline() {
    if (!_offline) return;
    _offline = false;
    _connectionRestored.add(null);
  }

  final _sessionExpired = StreamController<void>.broadcast();

  /// Sunucu refresh token'ı reddettiğinde (oturum gerçekten bittiğinde)
  /// bir kez tetiklenir. Ağ hatalarında tetiklenmez.
  Stream<void> get onSessionExpired => _sessionExpired.stream;

  /// Devam eden yenileme. Aynı anda 401 alan tüm istekler bunu bekler;
  /// sunucu her yenilemede yeni refresh token verdiği için ikinci bir
  /// paralel yenileme eski token'la reddedilip oturumu düşürürdü.
  Future<String?>? _refreshInFlight;

  /// 401 alan istek için kullanılacak geçerli access token'ı döner,
  /// alınamazsa null.
  Future<String?> _validTokenAfter401(RequestOptions failed) async {
    // İstek gönderildikten sonra başka bir istek token'ı zaten yenilemiş
    // olabilir; o zaman yeniden yenilemeye gerek yok.
    final sentHeader = failed.headers['Authorization'];
    final current = await getToken();
    if (current != null && sentHeader != 'Bearer $current') return current;

    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final refresh = _refreshAccessToken();
    _refreshInFlight = refresh;
    try {
      return await refresh;
    } finally {
      _refreshInFlight = null;
    }
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await secureStorage.read(key: Keys.REFRESH_TOKEN);
    if (refreshToken == null) return null;

    try {
      final langCode = _languageService.apiLanguageCode;
      final response = await _dio.post(
        '$langCode/auth/refresh-token',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {kSkipTokenRefresh: true}),
      );

      final String newAccessToken = response.data['data']['accessToken'];
      final String newRefreshToken = response.data['data']['refreshToken'];
      await addToken(newAccessToken, newRefreshToken);
      return newAccessToken;
    } on DioException catch (err) {
      final status = err.response?.statusCode;
      final isAuthRejected = status == 401 || status == 403 || status == 400;
      // Ağ hatasında token silme — kullanıcı "çıkış yapmış" gibi olmasın.
      if (isAuthRejected) {
        await clearTokens();
        _sessionExpired.add(null);
      }
      return null;
    } catch (_) {
      // Beklenmeyen yanıt biçimi: oturumu silmeden hatayı ilet.
      return null;
    }
  }

  Dio get dio => _dio;

  Future<String?> getToken() async => await secureStorage.read(key: Keys.TOKEN);

  Future<void> addToken(String token, String refreshToken) async {
    await secureStorage.write(key: Keys.TOKEN, value: token);
    await secureStorage.write(key: Keys.REFRESH_TOKEN, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await secureStorage.delete(key: Keys.TOKEN);
    await secureStorage.delete(key: Keys.REFRESH_TOKEN);
  }

  Future<void> clearAllStorage() async {
    await secureStorage.deleteAll();
  }
}

abstract class Keys {
  static const String TOKEN = 'accessToken';
  static const String REFRESH_TOKEN = 'refreshToken';
}
