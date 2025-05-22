import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale(AppConstants.defaultLanguageCode);

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'ne'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = Locale(AppConstants.defaultLanguageCode);
    notifyListeners();
  }
}
