// Tests for user_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/user/user_provider.dart';

void main() {
  group('UserProvider', () {
    test('should create UserProvider instance', () {
      final provider = UserProvider();
      expect(provider, isA<UserProvider>());
    });
  });
}
