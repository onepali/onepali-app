// Tests for gauth_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/src.dart';

void main() {
  group('GoogleAuthProvider', () {
    test('should create GoogleAuthProvider instance', () {
      final provider = GoogleAuthProvider(authState: AuthState());
      expect(provider, isA<GoogleAuthProvider>());
    });
  });
}
