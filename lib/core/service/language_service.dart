import 'package:flutter/material.dart';

class LanguageService {
  Locale _locale = const Locale('tr');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
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
