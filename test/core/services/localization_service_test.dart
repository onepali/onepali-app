// Tests for localization_service.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/services/localization_service.dart';

void main() {
  group('AppLocalizationsDelegate', () {
    test('should create AppLocalizationsDelegate instance', () {
      final delegate = AppLocalizationsDelegate();
      expect(delegate, isA<AppLocalizationsDelegate>());
    });
  });
}
