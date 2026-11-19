import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Sahte sunucu: geçerli access token `fresh`'tir. Refresh token yalnızca
/// bir kez kullanılabilir (sunucu her yenilemede yenisini verir).
class _FakeServer implements HttpClientAdapter {
  _FakeServer({required this.acceptRefresh});

  final bool acceptRefresh;
  int refreshCalls = 0;
  final Set<String> _usedRefreshTokens = {};

  @override
  Future<ResponseBody> fetch(
      RequestOptions options, Stream<Uint8List>? _, Future<void>? __) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));

    if (options.path.endsWith('auth/refresh-token')) {
      refreshCalls++;
      final body = options.data as Map;
      final token = body['refreshToken'] as String;
      if (!acceptRefresh || !_usedRefreshTokens.add(token)) {
        return _json(401, {'success': false});
      }
      return _json(200, {
        'data': {'accessToken': 'fresh', 'refreshToken': 'refresh-2'}
      });
    }

    if (options.headers['Authorization'] == 'Bearer fresh') {
      return _json(200, {'ok': true});
    }
    return _json(401, {'success': false});
  }

  ResponseBody _json(int status, Object body) => ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  void close({bool force = false}) {}
}

void main() {
  late FlutterSecureStorage storage;

  setUpAll(() {
    if (!di.isRegistered<LanguageService>()) {
      di.registerLazySingleton(() => LanguageService());
    }
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      Keys.TOKEN: 'expired',
      Keys.REFRESH_TOKEN: 'refresh-1',
    });
    storage = const FlutterSecureStorage();
  });

  DioClient buildClient(_FakeServer server) {
    final dio = Dio(BaseOptions(baseUrl: 'https://test/api/'))
      ..httpClientAdapter = server;
    return DioClient(
      storage,
      dio,
      TalkerDioLogger(talker: Talker(settings: TalkerSettings(enabled: false))),
    );
  }

  test('Aynı anda 401 alan istekler tek bir yenilemeyi paylaşır', () async {
    final server = _FakeServer(acceptRefresh: true);
    final client = buildClient(server);
    var expiredEvents = 0;
    client.onSessionExpired.listen((_) => expiredEvents++);

    final responses = await Future.wait([
      client.dio.get('book'),
      client.dio.get('banner'),
      client.dio.get('category'),
    ]);

    expect(responses.map((r) => r.statusCode), everyElement(200));
    expect(server.refreshCalls, 1);
    expect(await storage.read(key: Keys.TOKEN), 'fresh');
    expect(await storage.read(key: Keys.REFRESH_TOKEN), 'refresh-2');
    expect(expiredEvents, 0);
  });

  test('Yenileme reddedilirse token silinir ve oturum bitti bir kez bildirilir',
      () async {
    final server = _FakeServer(acceptRefresh: false);
    final client = buildClient(server);
    var expiredEvents = 0;
    client.onSessionExpired.listen((_) => expiredEvents++);

    final results = await Future.wait([
      client.dio
          .get('book')
          .then<Object?>((_) => null, onError: (Object e) => e),
      client.dio
          .get('banner')
          .then<Object?>((_) => null, onError: (Object e) => e),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(results, everyElement(isA<DioException>()));
    expect(server.refreshCalls, 1);
    expect(await storage.read(key: Keys.TOKEN), isNull);
    expect(await storage.read(key: Keys.REFRESH_TOKEN), isNull);
    expect(expiredEvents, 1);
  });
}
