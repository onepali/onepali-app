// Tests for language_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/system/language_provider.dart';

void main() {
  group('LanguageProvider', () {
    test('should create LanguageProvider instance', () {
      final provider = LanguageProvider();
      expect(provider, isA<LanguageProvider>());
    });
  });
}
