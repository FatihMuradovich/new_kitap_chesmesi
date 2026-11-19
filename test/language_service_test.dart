import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Kayıt yoksa varsayılan Türkmence (tr → API tm)', () async {
    SharedPreferences.setMockInitialValues({});
    final service = LanguageService();
    await service.load();

    expect(service.locale, const Locale('tr'));
    expect(service.apiLanguageCode, 'tm');
  });

  test('Seçilen dil yeniden açılışta geri yüklenir', () async {
    SharedPreferences.setMockInitialValues({});
    await LanguageService().setLocale(const Locale('ru'));

    // Uygulamanın yeniden açılması: yeni servis örneği.
    final restarted = LanguageService();
    await restarted.load();

    expect(restarted.locale, const Locale('ru'));
    expect(restarted.apiLanguageCode, 'ru');
  });

  test('Desteklenmeyen kayıtlı dil yok sayılır', () async {
    SharedPreferences.setMockInitialValues({'app_language': 'de'});
    final service = LanguageService();
    await service.load();

    expect(service.locale, const Locale('tr'));
  });
}
