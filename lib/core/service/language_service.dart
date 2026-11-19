import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uygulama dilini tutar ve cihazda saklar.
///
/// Not: Türkmence arayüz dili `tr` koduyla temsil edilir (app_tr.arb),
/// API'ye ise `tm` olarak gider.
class LanguageService {
  static const _prefsKey = 'app_language';
  static const _supported = {'tr', 'ru', 'en'};
  static const defaultLocale = Locale('tr');

  Locale _locale = defaultLocale;

  Locale get locale => _locale;

  /// Kaydedilmiş dili yükler. `runApp`'ten önce çağrılmalı ki ilk ekran
  /// ve ilk API istekleri doğru dille yapılsın.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefsKey);
      if (saved != null && _supported.contains(saved)) {
        _locale = Locale(saved);
      }
    } catch (e) {
      log('Kayıtlı dil okunamadı: $e', name: 'LanguageService');
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, newLocale.languageCode);
    } catch (e) {
      log('Dil kaydedilemedi: $e', name: 'LanguageService');
    }
  }

  /// Returns API-compatible language codes based on current locale.
  /// tr -> tm, ru -> ru, en -> en, otherwise returns the raw language code.
  String get apiLanguageCode {
    switch (_locale.languageCode) {
      case 'tr':
        return 'tm';
      case 'ru':
        return 'ru';
      case 'en':
        return 'en';
      default:
        return _locale.languageCode;
    }
  }
}
