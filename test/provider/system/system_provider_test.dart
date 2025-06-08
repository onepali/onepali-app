// Tests for system_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/system/system_provider.dart';

void main() {
  group('SystemProvider', () {
    test('should create SystemProvider instance', () {
      final provider = SystemProvider();
      expect(provider, isA<SystemProvider>());
    });
  });
}
