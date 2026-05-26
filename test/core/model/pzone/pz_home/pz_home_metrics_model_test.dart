// Tests for pz_home_metrics_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/pzone/pz_home/pz_home_metrics_model.dart';

void main() {
  group('PzHomeMetricsModel', () {
    test('should create model with required properties', () {
      final model = PzHomeMetricsModel(
        completedActivities: 10,
        answerSuccessRate: 85.5,
        dayStreak: 5,
        weeklyStreak: [true, true, false, true, true, false, true],
        lastActiveDate: '2026-07-03',
        averageDailyLearningTime: 30,
        mostPracticedTopics: ['Math', 'Science', 'English'],
        topicCounts: {'Math': 5, 'Science': 3, 'English': 2},
      );

      expect(model.completedActivities, 10);
      expect(model.answerSuccessRate, 85.5);
      expect(model.dayStreak, 5);
      expect(model.weeklyStreak.length, 7);
      expect(model.weeklyStreak, [true, true, false, true, true, false, true]);
      expect(model.lastActiveDate, '2026-07-03');
      expect(model.averageDailyLearningTime, 30);
      expect(model.mostPracticedTopics, ['Math', 'Science', 'English']);
    });

    test('fromJson should create model from valid JSON', () {
      final json = {
        'completedActivities': 15,
        'answerSuccessRate': 92.3,
        'dayStreak': 7,
        'weeklyStreak': [true, true, true, false, true, true, false],
        'lastActiveDate': '2026-07-03',
        'averageDailyLearningTime': 45,
        'mostPracticedTopics': ['Reading', 'Writing'],
      };

      final model = PzHomeMetricsModel.fromJson(json);
      expect(model.completedActivities, 15);
      expect(model.answerSuccessRate, 92.3);
      expect(model.dayStreak, 7);
      expect(model.weeklyStreak, [true, true, true, false, true, true, false]);
      expect(model.lastActiveDate, '2026-07-03');
      expect(model.averageDailyLearningTime, 45);
      expect(model.mostPracticedTopics, ['Reading', 'Writing']);
    });

    test('fromJson should handle null map with default values', () {
      final model = PzHomeMetricsModel.fromJson(null);

      expect(model.completedActivities, 0);
      expect(model.answerSuccessRate, 0.0);
      expect(model.dayStreak, 0);
      expect(model.weeklyStreak, List.filled(7, false));
      expect(model.lastActiveDate, '');
      expect(model.averageDailyLearningTime, 0);
      expect(model.mostPracticedTopics, []);
    });

    test('fromJson should handle missing fields with defaults', () {
      final json = {
        'completedActivities': 5,
        // Missing other fields
      };

      final model = PzHomeMetricsModel.fromJson(json);
      expect(model.completedActivities, 5);
      expect(model.answerSuccessRate, 0.0);
      expect(model.dayStreak, 0);
      expect(model.weeklyStreak, List.filled(7, false));
      expect(model.lastActiveDate, '');
      expect(model.averageDailyLearningTime, 0);
      expect(model.mostPracticedTopics, []);
    });

    test('toJson should convert model to JSON correctly', () {
      final model = PzHomeMetricsModel(
        completedActivities: 8,
        answerSuccessRate: 78.9,
        dayStreak: 3,
        weeklyStreak: [false, true, true, false, false, true, true],
        lastActiveDate: '2026-07-03',
        averageDailyLearningTime: 25,
        mostPracticedTopics: ['Art', 'Music'],
        topicCounts: {'Art': 4, 'Music': 3},
      );

      final json = model.toJson();
      expect(json['completedActivities'], 8);
      expect(json['answerSuccessRate'], 78.9);
      expect(json['dayStreak'], 3);
      expect(json['weeklyStreak'], [
        false,
        true,
        true,
        false,
        false,
        true,
        true,
      ]);
      expect(json['lastActiveDate'], '2026-07-03');
      expect(json['averageDailyLearningTime'], 25);
      expect(json['mostPracticedTopics'], ['Art', 'Music']);
    });

    test('copyWith should create new instance with updated values', () {
      final original = PzHomeMetricsModel(
        completedActivities: 10,
        answerSuccessRate: 85.0,
        dayStreak: 5,
        weeklyStreak: List.filled(7, false),
        lastActiveDate: '2026-07-03',
        averageDailyLearningTime: 30,
        mostPracticedTopics: ['Math'],
        topicCounts: {'Math': 10},
      );

      final updated = original.copyWith(
        completedActivities: 15,
        answerSuccessRate: 90.0,
        mostPracticedTopics: ['Math', 'Science'],
      );

      expect(updated.completedActivities, 15);
      expect(updated.answerSuccessRate, 90.0);
      expect(updated.dayStreak, 5); // Unchanged
      expect(updated.averageDailyLearningTime, 30); // Unchanged
      expect(updated.mostPracticedTopics, ['Math', 'Science']);
    });

    test('copyWith should preserve original when no parameters provided', () {
      final original = PzHomeMetricsModel(
        completedActivities: 10,
        answerSuccessRate: 85.0,
        dayStreak: 5,
        weeklyStreak: List.filled(7, true),
        lastActiveDate: '2026-07-03',
        averageDailyLearningTime: 30,
        mostPracticedTopics: ['Math'],
        topicCounts: {'Math': 10},
      );

      final copy = original.copyWith();

      expect(copy.completedActivities, original.completedActivities);
      expect(copy.answerSuccessRate, original.answerSuccessRate);
      expect(copy.dayStreak, original.dayStreak);
      expect(copy.weeklyStreak, original.weeklyStreak);
      expect(copy.lastActiveDate, original.lastActiveDate);
      expect(copy.averageDailyLearningTime, original.averageDailyLearningTime);
      expect(copy.mostPracticedTopics, original.mostPracticedTopics);
    });

    test('should handle weekly streak validation', () {
      final model = PzHomeMetricsModel(
        completedActivities: 0,
        answerSuccessRate: 0.0,
        dayStreak: 0,
        weeklyStreak: [true, false, true, false, true, false, true],
        lastActiveDate: '',
        averageDailyLearningTime: 0,
        mostPracticedTopics: [],
        topicCounts: {},
      );

      expect(model.weeklyStreak.length, 7);
      expect(model.weeklyStreak.where((day) => day).length, 4); // 4 true days
      expect(model.weeklyStreak.where((day) => !day).length, 3); // 3 false days
    });

    test('markActiveOn increments streak once per local date', () {
      final model = PzHomeMetricsModel.fromJson({
        'dayStreak': 2,
        'weeklyStreak': [false, false, false, false, true, false, false],
        'lastActiveDate': '2026-07-02',
      });

      final firstCompletion = model.markActiveOn(DateTime(2026, 7, 3, 9));
      final secondCompletion = firstCompletion.markActiveOn(
        DateTime(2026, 7, 3, 17),
      );

      expect(firstCompletion.dayStreak, 3);
      expect(secondCompletion.dayStreak, 3);
      expect(secondCompletion.lastActiveDate, '2026-07-03');
      expect(secondCompletion.weeklyStreak[5], isTrue);
    });

    test('normalizedFor resets stale streak after a missed day', () {
      final model = PzHomeMetricsModel.fromJson({
        'dayStreak': 4,
        'weeklyStreak': [false, false, true, false, false, false, false],
        'lastActiveDate': '2026-07-01',
      });

      final normalized = model.normalizedFor(DateTime(2026, 7, 3));

      expect(normalized.dayStreak, 0);
      expect(normalized.lastActiveDate, '2026-07-01');
    });

    test('markActiveOn restarts streak after a missed day', () {
      final model = PzHomeMetricsModel.fromJson({
        'dayStreak': 4,
        'weeklyStreak': [false, false, true, false, false, false, false],
        'lastActiveDate': '2026-07-01',
      });

      final updated = model.markActiveOn(DateTime(2026, 7, 3));

      expect(updated.dayStreak, 1);
      expect(updated.lastActiveDate, '2026-07-03');
      expect(updated.weeklyStreak[5], isTrue);
    });

    test('markActiveOn maps the date weekday into the weekly row', () {
      final model = PzHomeMetricsModel.fromJson(null);

      final updated = model.markActiveOn(DateTime(2026, 7, 5));

      expect(updated.lastActiveDate, '2026-07-05');
      expect(updated.weeklyStreak, [
        true,
        false,
        false,
        false,
        false,
        false,
        false,
      ]);
    });

    test(
      'markActiveOn clears previous week while preserving streak continuity',
      () {
        final model = PzHomeMetricsModel.fromJson({
          'dayStreak': 5,
          'weeklyStreak': [false, false, false, false, false, false, true],
          'lastActiveDate': '2026-07-04',
        });

        final updated = model.markActiveOn(DateTime(2026, 7, 5));

        expect(updated.dayStreak, 6);
        expect(updated.lastActiveDate, '2026-07-05');
        expect(updated.weeklyStreak, [
          true,
          false,
          false,
          false,
          false,
          false,
          false,
        ]);
      },
    );
  });
}
