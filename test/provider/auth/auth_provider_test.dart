// Tests for auth_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/auth/auth_provider.dart';
import 'package:onepali/src/provider/auth/auth_state.dart';

void main() {
  group('AuthProvider', () {
    test('should create AuthProvider instance', () {
      final provider = AuthProvider(authState: AuthState());
      expect(provider, isA<AuthProvider>());
    });
  });
}
