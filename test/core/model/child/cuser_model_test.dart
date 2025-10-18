// Tests for cuser_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/src.dart';

void main() {
  group('ChildUserModel', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'avatar_url': 'avatar.png',
        'created_at': '2024-01-01T00:00:00.000',
        'dob': '2018-05-10',
        'full_name': 'Child',
        'parent_email': 'parent@example.com',
        'parent_uid': 'parent123',
        'role': 'child',
        'has_screen_time': true,
        'uid': 'child1',
        'screenTimeTracking': {
          'totalAllowed': 120.0,
          'totalUsed': 0.0,
          'lastUpdated': '2024-01-01T00:00:00.000',
        },
      };
      final model = ChildUserModel.fromJson(json);
      expect(model.uid, 'child1');
      expect(model.fullName, 'Child');
      expect(model.avatarUrl, 'avatar.png');
      expect(model.parentEmail, 'parent@example.com');
      expect(model.parentUid, 'parent123');
      expect(model.role, 'child');
      expect(model.screenTimeTracking?.totalAllowed, 120.0);
      expect(model.hasScreenTime, true);
      expect(model.dob, '2018-05-10');
      expect(model.createdAt, '2024-01-01T00:00:00.000');
      final toJson = model.toJson();
      expect(toJson['uid'], 'child1');
      expect(toJson['full_name'], 'Child');
      expect(toJson['avatar_url'], 'avatar.png');
      expect(toJson['parent_email'], 'parent@example.com');
      expect(toJson['parent_uid'], 'parent123');
      expect(toJson['role'], 'child');
      expect(toJson['screenTimeTracking']['totalAllowed'], 120.0);
      expect(toJson['has_screen_time'], true);
      expect(toJson['dob'], '2018-05-10');
      expect(toJson['created_at'], '2024-01-01T00:00:00.000');
    });
  });
}
