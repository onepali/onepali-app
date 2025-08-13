// Tests for auth_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/auth/auth_state.dart';

void main() {
  group('AuthProvider', () {
    test('should create AuthState instance', () {
      final authState = AuthState();
      expect(authState, isA<AuthState>());
    });
  });
}
