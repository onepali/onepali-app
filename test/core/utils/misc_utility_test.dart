// Tests for misc_utility.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/utils/misc_utility.dart';

void main() {
  group('Misc', () {
    test('delayed executes callback after delay', () async {
      bool called = false;
      await Misc.delayed(10, () {
        called = true;
      });
      expect(called, true);
    });
  });
}
