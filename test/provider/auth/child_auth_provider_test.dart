// Tests for child_auth_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/auth/child_auth_provider.dart';

void main() {
  group('ChildAuthProvider', () {
    test('should create ChildAuthProvider instance', () {
      final provider = ChildAuthProvider();
      expect(provider, isA<ChildAuthProvider>());
    });
  });
}
