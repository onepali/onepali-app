// Tests for response_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/system/response_model.dart';

void main() {
  group('ApiResponse', () {
    test('fromJson and toJson should work correctly', () {
      final json = {'status': true, 'message': 'Success', 'data': {}};
      final model = ApiResponse.fromJson(json);
      expect(model.status, true);
      expect(model.message, 'Success');
      expect(model.data, isA<Object>());
      expect(model.toJson()['status'], true);
    });
  });
}
