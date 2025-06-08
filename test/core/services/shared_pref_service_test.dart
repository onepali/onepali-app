// Tests for shared_pref_service.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/services/shared_pref_service.dart';

void main() {
  group('SharedPreferencesService', () {
    test('should create SharedPreferencesService instance', () async {
      final service = await SharedPreferencesService.init();
      expect(service, isA<SharedPreferencesService>());
    });
  });
}
