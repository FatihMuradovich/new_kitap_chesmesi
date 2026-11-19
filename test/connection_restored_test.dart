import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// [online] false iken bağlantı hatası verir.
class _ToggleAdapter implements HttpClientAdapter {
  bool online = true;

  @override
  Future<ResponseBody> fetch(
      RequestOptions options, Stream<Uint8List>? _, Future<void>? __) async {
    if (!online) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    return ResponseBody.fromString('{}', 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() {
    if (!di.isRegistered<LanguageService>()) {
      di.registerLazySingleton(() => LanguageService());
    }
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('Bağlantı hatasından sonraki ilk başarılı yanıtta bir kez bildirilir',
      () async {
    final adapter = _ToggleAdapter();
    final client = DioClient(
      const FlutterSecureStorage(),
      Dio()..httpClientAdapter = adapter,
      TalkerDioLogger(),
      enableLogging: false,
    );
    var restored = 0;
    client.onConnectionRestored.listen((_) => restored++);

    await client.dio.get('book'); // zaten çevrimiçi: bildirim yok
    adapter.online = false;
    await expectLater(client.dio.get('book'), throwsA(isA<DioException>()));
    await expectLater(client.dio.get('cart'), throwsA(isA<DioException>()));
    adapter.online = true;
    await client.dio.get('book');
    await client.dio.get('cart');
    await Future<void>.delayed(Duration.zero);

    expect(restored, 1);
  });
}
