// Tests for cuser_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/child/cuser_provider.dart';

void main() {
  group('CUserProvider', () {
    test('should create CUserProvider instance', () {
      final provider = ChildUserProvider();
      expect(provider, isA<ChildUserProvider>());
    });
  });
}
