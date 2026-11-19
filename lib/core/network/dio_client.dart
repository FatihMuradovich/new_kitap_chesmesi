import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:new_kitap_chesmesi/app/di.dart';

class DioClient {
  /// Refresh isteğinin kendisi 401 döndüğünde interceptor'ın tekrar refresh denemesini
  /// ve süresi dolmuş access token'ın Authorization'a eklenmesini engeller.
  static const String kSkipTokenRefresh = 'skipTokenRefresh';

  final FlutterSecureStorage secureStorage;
  final TalkerDioLogger talkerDioLogger;
  final Dio _dio;
  final LanguageService _languageService = di<LanguageService>();

  DioClient(
    this.secureStorage,
    this._dio,
    this.talkerDioLogger,
  ) {
    _dio.interceptors.addAll([
      talkerDioLogger,
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final skipRefreshFlow =
              options.extra[kSkipTokenRefresh] == true;
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
          options.headers['Accept-Language'] =
              _languageService.apiLanguageCode;

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
        onResponse: (response, handler) => handler.next(response),
        onError: (DioException e, handler) async {
          // Refresh çağrısı 401 verdiyse sonsuz döngüye girme; hatayı olduğu gibi ilet
          if (e.requestOptions.extra[kSkipTokenRefresh] == true) {
            return handler.next(e);
          }

          if (e.response?.statusCode == 401) {
            final refreshToken = await secureStorage.read(
              key: Keys.REFRESH_TOKEN,
            );
            if (refreshToken != null) {
              try {
                // Refresh token endpoint uses {lang}/auth/refresh-token
                final langCode = _languageService.apiLanguageCode;
                final response = await _dio.post(
                  '$langCode/auth/refresh-token',
                  data: {'refreshToken': refreshToken},
                  options: Options(
                    extra: {kSkipTokenRefresh: true},
                    headers: {
                      'Accept-Language': _languageService.apiLanguageCode,
                    },
                  ),
                );

                final newAccessToken = response.data['data']['accessToken'];
                final newRefreshToken = response.data['data']['refreshToken'];

                await secureStorage.write(
                  key: Keys.TOKEN,
                  value: newAccessToken,
                );
                await secureStorage.write(
                  key: Keys.REFRESH_TOKEN,
                  value: newRefreshToken,
                );

                // Retry original request
                final options = e.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                options.headers['Accept-Language'] =
                    _languageService.apiLanguageCode;

                // Ensure language prefix exists for retried request (skip auth endpoints)
                final retryPath = options.path.startsWith('/')
                    ? options.path.substring(1)
                    : options.path;
                final isAuthRetry = retryPath.startsWith('auth/');
                final alreadyPrefixed = retryPath.startsWith('tm/') ||
                    retryPath.startsWith('ru/') ||
                    retryPath.startsWith('en/');
                if (!isAuthRetry && !alreadyPrefixed) {
                  options.path =
                      '${_languageService.apiLanguageCode}/$retryPath';
                }

                final cloneReq = await _dio.fetch(options);
                return handler.resolve(cloneReq);
              } catch (refreshError) {
                // Ağ hatasında token silme — kullanıcı "çıkış yapmış" gibi olmasın
                if (refreshError is DioException) {
                  final status = refreshError.response?.statusCode;
                  final isAuthRejected =
                      status == 401 || status == 403 || status == 400;
                  if (isAuthRejected) {
                    await secureStorage.delete(key: Keys.TOKEN);
                    await secureStorage.delete(key: Keys.REFRESH_TOKEN);
                  }
                }
              }
            }
          }
          return handler.next(e);
        },
      ),
    ]);
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
