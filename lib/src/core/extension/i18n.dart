import 'package:flutter/material.dart';

import '../../src.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
  String tr(String key) => l10n?.translate(key) ?? key;
}
