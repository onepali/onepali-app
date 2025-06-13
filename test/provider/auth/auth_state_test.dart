// Tests for auth_state.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/auth/auth_state.dart';

void main() {
  group('AuthState', () {
    test('should create AuthState instance', () {
      final state = AuthState();
      expect(state, isA<AuthState>());
    });
  });
}
