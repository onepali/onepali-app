// Tests for user_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/user/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'uid': '123',
        'fullName': 'Test User',
        'email': 'test@example.com',
        'yearOfBirth': 2000,
        'heardAbout': 'Internet',
        'learningReason': 'Fun',
        'authProvider': 'email',
        'createdAt': '2024-01-01T00:00:00.000',
      };
      final user = UserModel.fromJson(json);
      expect(user.uid, '123');
      expect(user.fullName, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.yearOfBirth, 2000);
      expect(user.heardAbout, 'Internet');
      expect(user.learningReason, 'Fun');
      expect(user.authProvider, 'email');
      expect(user.createdAt, '2024-01-01T00:00:00.000');
      final toJson = user.toJson();
      expect(toJson['uid'], '123');
      expect(toJson['fullName'], 'Test User');
      expect(toJson['email'], 'test@example.com');
      expect(toJson['yearOfBirth'], 2000);
      expect(toJson['heardAbout'], 'Internet');
      expect(toJson['learningReason'], 'Fun');
      expect(toJson['authProvider'], 'email');
      expect(toJson['createdAt'], '2024-01-01T00:00:00.000');
    });
  });
}
