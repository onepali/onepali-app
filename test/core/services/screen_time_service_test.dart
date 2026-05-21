import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/child/screen_time_model.dart';

void main() {
  group('ScreenTimeModel', () {
    test(
      'should correctly accumulate session time without resetting',
      () async {
        // Test that validates the bug fix for session time accumulation
        final screenTime = ScreenTimeModel(
          totalAllowed: 60.0, // 60 minutes allowed
          totalUsed: 10.0, // 10 minutes already used
          lastUpdated: DateTime.now(),
        );

        // Simulate starting with some existing used time
        expect(screenTime.totalUsed, equals(10.0));
        expect(screenTime.remainingTime, equals(50.0));

        // Simulate adding 5 minutes of session time
        final updatedScreenTime = screenTime.copyWith(
          totalUsed: screenTime.totalUsed + 5.0,
          lastUpdated: DateTime.now(),
        );

        expect(updatedScreenTime.totalUsed, equals(15.0));
        expect(updatedScreenTime.remainingTime, equals(45.0));

        // Simulate adding another 10 minutes
        final finalScreenTime = updatedScreenTime.copyWith(
          totalUsed: updatedScreenTime.totalUsed + 10.0,
          lastUpdated: DateTime.now(),
        );

        expect(finalScreenTime.totalUsed, equals(25.0));
        expect(finalScreenTime.remainingTime, equals(35.0));
        expect(finalScreenTime.isLimitExceeded, isFalse);
      },
    );

    test('should detect when limit is exceeded', () {
      final screenTime = ScreenTimeModel(
        totalAllowed: 30.0, // 30 minutes allowed
        totalUsed: 25.0, // 25 minutes already used
        lastUpdated: DateTime.now(),
      );

      expect(screenTime.isLimitExceeded, isFalse);
      expect(screenTime.remainingTime, equals(5.0));

      // Add 10 more minutes to exceed limit
      final exceededScreenTime = screenTime.copyWith(
        totalUsed: screenTime.totalUsed + 10.0,
      );

      expect(exceededScreenTime.totalUsed, equals(35.0));
      expect(exceededScreenTime.isLimitExceeded, isTrue);
      expect(exceededScreenTime.remainingTime, equals(0.0));
    });

    test('should reset screen time for new day', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final screenTime = ScreenTimeModel(
        totalAllowed: 60.0,
        totalUsed: 45.0,
        lastUpdated: yesterday,
      );

      expect(screenTime.shouldReset(), isTrue);

      final resetScreenTime = screenTime.resetForNewDay();
      expect(resetScreenTime.totalUsed, equals(0.0));
      expect(resetScreenTime.totalAllowed, equals(60.0));
      expect(resetScreenTime.lastUpdated.day, equals(DateTime.now().day));
    });

    test('should not reset screen time for same day', () {
      final today = DateTime.now();
      final screenTime = ScreenTimeModel(
        totalAllowed: 60.0,
        totalUsed: 30.0,
        lastUpdated: today,
      );

      expect(screenTime.shouldReset(), isFalse);
    });

    test('should handle session duration calculation correctly', () {
      final now = DateTime.now();
      final sessionStart = now.subtract(const Duration(minutes: 15));

      final sessionDuration = now.difference(sessionStart);
      final sessionMinutes = sessionDuration.inMinutes.toDouble();

      expect(sessionMinutes, equals(15.0));

      // Simulate accumulating this session time
      final screenTime = ScreenTimeModel(
        totalAllowed: 60.0,
        totalUsed: 20.0,
        lastUpdated: DateTime.now(),
      );

      final updatedScreenTime = screenTime.copyWith(
        totalUsed: screenTime.totalUsed + sessionMinutes,
      );

      expect(updatedScreenTime.totalUsed, equals(35.0));
      expect(updatedScreenTime.remainingTime, equals(25.0));
    });

    test('should clamp negative values to zero', () {
      final screenTime = ScreenTimeModel(
        totalAllowed: 30.0,
        totalUsed: 0.0,
        lastUpdated: DateTime.now(),
      );

      // Try to subtract time (should clamp to 0)
      final clampedScreenTime = screenTime.copyWith(
        totalUsed: (screenTime.totalUsed - 10.0)
            .clamp(0.0, double.infinity)
            .toDouble(),
      );

      expect(clampedScreenTime.totalUsed, equals(0.0));
    });

    test('should handle JSON serialization correctly', () {
      final screenTime = ScreenTimeModel(
        totalAllowed: 60.0,
        totalUsed: 25.5,
        lastUpdated: DateTime.parse('2024-01-15T10:30:00Z'),
      );

      final json = screenTime.toJson();
      expect(json['totalAllowed'], equals(60.0));
      expect(json['totalUsed'], equals(25.5));
      expect(json['lastUpdated'], equals('2024-01-15T10:30:00.000Z'));

      final fromJson = ScreenTimeModel.fromJson(json);
      expect(fromJson.totalAllowed, equals(60.0));
      expect(fromJson.totalUsed, equals(25.5));
      expect(
        fromJson.lastUpdated,
        equals(DateTime.parse('2024-01-15T10:30:00Z')),
      );
    });

    test('should correctly calculate time properties', () {
      final screenTime = ScreenTimeModel(
        totalAllowed: 120.0, // 2 hours
        totalUsed: 75.0, // 1 hour 15 minutes
        lastUpdated: DateTime.now(),
      );

      expect(screenTime.remainingTime, equals(45.0)); // 45 minutes remaining
      expect(screenTime.isLimitExceeded, isFalse);
    });
  });
}
