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
        averageDailyLearningTime: 30,
        mostPracticedTopics: ['Math', 'Science', 'English'],
      );

      expect(model.completedActivities, 10);
      expect(model.answerSuccessRate, 85.5);
      expect(model.dayStreak, 5);
      expect(model.weeklyStreak.length, 7);
      expect(model.weeklyStreak, [true, true, false, true, true, false, true]);
      expect(model.averageDailyLearningTime, 30);
      expect(model.mostPracticedTopics, ['Math', 'Science', 'English']);
    });

    test('fromJson should create model from valid JSON', () {
      final json = {
        'completedActivities': 15,
        'answerSuccessRate': 92.3,
        'dayStreak': 7,
        'weeklyStreak': [true, true, true, false, true, true, false],
        'averageDailyLearningTime': 45,
        'mostPracticedTopics': ['Reading', 'Writing'],
      };

      final model = PzHomeMetricsModel.fromJson(json);
      expect(model.completedActivities, 15);
      expect(model.answerSuccessRate, 92.3);
      expect(model.dayStreak, 7);
      expect(model.weeklyStreak, [true, true, true, false, true, true, false]);
      expect(model.averageDailyLearningTime, 45);
      expect(model.mostPracticedTopics, ['Reading', 'Writing']);
    });

    test('fromJson should handle null map with default values', () {
      final model = PzHomeMetricsModel.fromJson(null);

      expect(model.completedActivities, 0);
      expect(model.answerSuccessRate, 0.0);
      expect(model.dayStreak, 0);
      expect(model.weeklyStreak, List.filled(7, false));
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
      expect(model.averageDailyLearningTime, 0);
      expect(model.mostPracticedTopics, []);
    });

    test('toJson should convert model to JSON correctly', () {
      final model = PzHomeMetricsModel(
        completedActivities: 8,
        answerSuccessRate: 78.9,
        dayStreak: 3,
        weeklyStreak: [false, true, true, false, false, true, true],
        averageDailyLearningTime: 25,
        mostPracticedTopics: ['Art', 'Music'],
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
      expect(json['averageDailyLearningTime'], 25);
      expect(json['mostPracticedTopics'], ['Art', 'Music']);
    });

    test('copyWith should create new instance with updated values', () {
      final original = PzHomeMetricsModel(
        completedActivities: 10,
        answerSuccessRate: 85.0,
        dayStreak: 5,
        weeklyStreak: List.filled(7, false),
        averageDailyLearningTime: 30,
        mostPracticedTopics: ['Math'],
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
        averageDailyLearningTime: 30,
        mostPracticedTopics: ['Math'],
      );

      final copy = original.copyWith();

      expect(copy.completedActivities, original.completedActivities);
      expect(copy.answerSuccessRate, original.answerSuccessRate);
      expect(copy.dayStreak, original.dayStreak);
      expect(copy.weeklyStreak, original.weeklyStreak);
      expect(copy.averageDailyLearningTime, original.averageDailyLearningTime);
      expect(copy.mostPracticedTopics, original.mostPracticedTopics);
    });

    test('should handle weekly streak validation', () {
      final model = PzHomeMetricsModel(
        completedActivities: 0,
        answerSuccessRate: 0.0,
        dayStreak: 0,
        weeklyStreak: [true, false, true, false, true, false, true],
        averageDailyLearningTime: 0,
        mostPracticedTopics: [],
      );

      expect(model.weeklyStreak.length, 7);
      expect(model.weeklyStreak.where((day) => day).length, 4); // 4 true days
      expect(model.weeklyStreak.where((day) => !day).length, 3); // 3 false days
    });
  });
}
