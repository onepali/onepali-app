// Tests for fauth_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/auth/fauth_provider.dart';
import 'package:onepali/src/src.dart';

void main() {
  group('FAuthProvider', () {
    test('should create FAuthProvider instance', () {
      final provider = FAuthProvider(authState: AuthState());
      expect(provider, isA<FAuthProvider>());
    });
  });
}
