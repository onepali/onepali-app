// Tests for splash_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/system/splash_provider.dart';

void main() {
  group('SplashProvider', () {
    test('should create SplashProvider instance', () {
      final provider = SplashProvider();
      expect(provider, isA<SplashProvider>());
    });
  });
}
