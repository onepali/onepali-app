// Tests for utility.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/utils/utility.dart';

void main() {
  group('Utility', () {
    test('isAccessible returns correct value', () {
      expect(Utility.isAccessible(null), false);
      expect(Utility.isAccessible([]), false);
      expect(Utility.isAccessible([1]), true);
      expect(Utility.isAccessible(1), true);
    });
  });
}
