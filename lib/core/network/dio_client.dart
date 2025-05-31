import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';

class DioClient {
  final FlutterSecureStorage secureStorage;
  final TalkerDioLogger talkerDioLogger;
  final Dio _dio;

  DioClient(this.secureStorage, this._dio, this.talkerDioLogger) {
    _dio.interceptors.addAll([
      talkerDioLogger,
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken(); // Retrieve token from storage
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await secureStorage.read(
              key: Keys.REFRESH_TOKEN,
            );

            if (refreshToken != null) {
              try {
                final response = await _dio.post(
                  'token/refresh/',
                  data: {'refresh': refreshToken},
                );

                final newAccessToken = response.data['access'];
                await secureStorage.write(
                  key: Keys.TOKEN,
                  value: newAccessToken,
                );

                // Retry the original request with new token
                final options = e.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                final cloneReq = await _dio.fetch(options);
                return handler.resolve(cloneReq);
              } catch (refreshError) {
                await secureStorage.delete(key: Keys.TOKEN);
                await secureStorage.delete(key: Keys.REFRESH_TOKEN);
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
}

abstract class Keys {
  static const String TOKEN = 'TOKEN';
  static const String REFRESH_TOKEN = 'RefreshTOKEN';
}
