import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/config/api_config.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

void main() {
  setUpAll(() {
    if (!di.isRegistered<LanguageService>()) {
      di.registerLazySingleton(() => LanguageService());
    }
  });

  test('Dio zaman aşımları tanımlı (zayıf internette sonsuz yükleme yok)', () {
    final options = ApiConfig.dioOptions();

    expect(options.baseUrl, ApiConfig.apiBaseUrl);
    expect(options.connectTimeout, isNotNull);
    expect(options.receiveTimeout, isNotNull);
  });

  test('Loglama kapalıyken ağ istekleri loglanmaz (release)', () {
    final client = DioClient(
      const FlutterSecureStorage(),
      Dio(),
      TalkerDioLogger(),
      enableLogging: false,
    );

    expect(client.dio.interceptors.whereType<TalkerDioLogger>(), isEmpty);
  });

  test('Loglama açıkken ağ istekleri loglanır (debug)', () {
    final client = DioClient(
      const FlutterSecureStorage(),
      Dio(),
      TalkerDioLogger(),
      enableLogging: true,
    );

    expect(client.dio.interceptors.whereType<TalkerDioLogger>(), hasLength(1));
  });
}
