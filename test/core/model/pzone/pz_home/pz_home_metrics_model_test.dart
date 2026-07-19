// Tests for pz_home_metrics_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/pzone/pz_home/pz_home_metrics_model.dart';

void main() {
  group('PzHomeMetricsModel', () {
    PzHomeMetricsModel metrics({
      int completedActivities = 0,
      double answerSuccessRate = 0.0,
      int dayStreak = 0,
      List<bool>? weeklyStreak,
      String lastActiveDate = '',
      int averageDailyLearningTime = 0,
      List<String>? mostPracticedTopics,
      Map<String, int>? topicCounts,
    }) {
      return PzHomeMetricsModel(
        completedActivities: completedActivities,
        answerSuccessRate: answerSuccessRate,
        dayStreak: dayStreak,
        weeklyStreak: weeklyStreak ?? List.filled(7, false),
        lastActiveDate: lastActiveDate,
        averageDailyLearningTime: averageDailyLearningTime,
        mostPracticedTopics: mostPracticedTopics ?? [],
        topicCounts: topicCounts ?? {},
      );
    }

    test('should create model with required properties', () {
      final model = metrics(
        completedActivities: 10,
        answerSuccessRate: 85.5,
        dayStreak: 5,
        weeklyStreak: [true, true, false, true, true, false, true],
        lastActiveDate: '2024-01-01',
        averageDailyLearningTime: 30,
        mostPracticedTopics: ['Math', 'Science', 'English'],
        topicCounts: {'Math': 5, 'Science': 3, 'English': 2},
      );

      expect(model.completedActivities, 10);
      expect(model.answerSuccessRate, 85.5);
      expect(model.dayStreak, 5);
      expect(model.weeklyStreak.length, 7);
      expect(model.weeklyStreak, [true, true, false, true, true, false, true]);
      expect(model.lastActiveDate, '2024-01-01');
      expect(model.averageDailyLearningTime, 30);
      expect(model.mostPracticedTopics, ['Math', 'Science', 'English']);
    });

    test('fromJson should create model from valid JSON', () {
      final json = {
        'completedActivities': 15,
        'answerSuccessRate': 92.3,
        'dayStreak': 7,
        'weeklyStreak': [true, true, true, false, true, true, false],
        'lastActiveDate': '2024-01-03',
        'averageDailyLearningTime': 45,
        'mostPracticedTopics': ['Reading', 'Writing'],
        'topicCounts': {'Reading': 4.0, 'Writing': 2},
      };

      final model = PzHomeMetricsModel.fromJson(json);
      expect(model.completedActivities, 15);
      expect(model.answerSuccessRate, 92.3);
      expect(model.dayStreak, 7);
      expect(model.weeklyStreak, [true, true, true, false, true, true, false]);
      expect(model.lastActiveDate, '2024-01-03');
      expect(model.averageDailyLearningTime, 45);
      expect(model.mostPracticedTopics, ['Reading', 'Writing']);
      expect(model.topicCounts, {'Reading': 4, 'Writing': 2});
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
      final model = metrics(
        completedActivities: 8,
        answerSuccessRate: 78.9,
        dayStreak: 3,
        weeklyStreak: [false, true, true, false, false, true, true],
        lastActiveDate: '2024-01-02',
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
      expect(json['lastActiveDate'], '2024-01-02');
      expect(json['averageDailyLearningTime'], 25);
      expect(json['mostPracticedTopics'], ['Art', 'Music']);
      expect(json['topicCounts'], {'Art': 4, 'Music': 3});
    });

    test('copyWith should create new instance with updated values', () {
      final original = metrics(
        completedActivities: 10,
        answerSuccessRate: 85.0,
        dayStreak: 5,
        lastActiveDate: '2024-01-01',
        averageDailyLearningTime: 30,
        mostPracticedTopics: ['Math'],
        topicCounts: {'Math': 10},
      );

      final updated = original.copyWith(
        completedActivities: 15,
        answerSuccessRate: 90.0,
        lastActiveDate: '2024-01-02',
        mostPracticedTopics: ['Math', 'Science'],
      );

      expect(updated.completedActivities, 15);
      expect(updated.answerSuccessRate, 90.0);
      expect(updated.dayStreak, 5); // Unchanged
      expect(updated.lastActiveDate, '2024-01-02');
      expect(updated.averageDailyLearningTime, 30); // Unchanged
      expect(updated.mostPracticedTopics, ['Math', 'Science']);
    });

    test('copyWith should preserve original when no parameters provided', () {
      final original = metrics(
        completedActivities: 10,
        answerSuccessRate: 85.0,
        dayStreak: 5,
        weeklyStreak: List.filled(7, true),
        lastActiveDate: '2024-01-01',
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
      final model = metrics(
        weeklyStreak: [true, false, true, false, true, false, true],
      );

      expect(model.weeklyStreak.length, 7);
      expect(model.weeklyStreak.where((day) => day).length, 4); // 4 true days
      expect(model.weeklyStreak.where((day) => !day).length, 3); // 3 false days
    });

    test('markActiveOn should mark the local weekday once per date', () {
      final marked = metrics().markActiveOn(DateTime(2024, 1, 1));

      expect(marked.dayStreak, 1);
      expect(marked.lastActiveDate, '2024-01-01');
      expect(marked.weeklyStreak, [
        false,
        true,
        false,
        false,
        false,
        false,
        false,
      ]);
    });

    test('markActiveOn should not increment streak twice on the same date', () {
      final marked = metrics(
        dayStreak: 4,
        lastActiveDate: '2024-01-01',
        weeklyStreak: [false, true, false, false, false, false, false],
      ).markActiveOn(DateTime(2024, 1, 1, 23, 59));

      expect(marked.dayStreak, 4);
      expect(marked.lastActiveDate, '2024-01-01');
      expect(marked.weeklyStreak[1], true);
    });

    test('markActiveOn should extend streak for the next local date', () {
      final marked = metrics(
        dayStreak: 4,
        lastActiveDate: '2024-01-01',
        weeklyStreak: [false, true, false, false, false, false, false],
      ).markActiveOn(DateTime(2024, 1, 2));

      expect(marked.dayStreak, 5);
      expect(marked.lastActiveDate, '2024-01-02');
      expect(marked.weeklyStreak[1], true);
      expect(marked.weeklyStreak[2], true);
    });

    test('normalizedFor should reset stale streak after a missed date', () {
      final normalized = metrics(
        dayStreak: 4,
        lastActiveDate: '2024-01-01',
        weeklyStreak: [false, true, false, false, false, false, false],
      ).normalizedFor(DateTime(2024, 1, 3));

      expect(normalized.dayStreak, 0);
      expect(normalized.weeklyStreak[1], true);
    });

    test('normalizedFor should clear weekly activity from a previous week', () {
      final normalized = metrics(
        dayStreak: 4,
        lastActiveDate: '2024-01-06',
        weeklyStreak: [false, true, true, true, true, true, true],
      ).normalizedFor(DateTime(2024, 1, 8));

      expect(normalized.dayStreak, 0);
      expect(normalized.weeklyStreak, List.filled(7, false));
    });

    test('normalizedFor should infer legacy consecutive weekly activity', () {
      final normalized = metrics(
        dayStreak: 3,
        weeklyStreak: [false, true, true, true, false, false, false],
      ).normalizedFor(DateTime(2024, 1, 3));

      expect(normalized.dayStreak, 3);
      expect(normalized.lastActiveDate, '2024-01-03');
    });

    test(
      'normalizedFor should correct legacy non-consecutive weekly activity',
      () {
        final normalized = metrics(
          dayStreak: 2,
          weeklyStreak: [false, true, false, true, false, false, false],
        ).normalizedFor(DateTime(2024, 1, 3));

        expect(normalized.dayStreak, 1);
        expect(normalized.lastActiveDate, '2024-01-03');
      },
    );
  });
}
