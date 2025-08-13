// Tests for validator.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/utils/validator.dart';

void main() {
  group('Validator', () {
    test('isValidEmail returns true for valid email', () {
      expect(Validator.email('test@example.com'), null);
    });
    test('isValidEmail returns false for invalid email', () {
      expect(Validator.email('invalid-email'), 'Enter a valid email address');
    });
  });
}
