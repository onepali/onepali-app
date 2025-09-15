class PzHomeMetricsModel {
  final int completedActivities;
  final double answerSuccessRate;
  final int dayStreak;
  final List<bool> weeklyStreak;
  final int averageDailyLearningTime;
  final List<String> mostPracticedTopics;
  final Map<String, int> topicCounts; // New field to track topic counts

  PzHomeMetricsModel({
    required this.completedActivities,
    required this.answerSuccessRate,
    required this.dayStreak,
    required this.weeklyStreak,
    required this.averageDailyLearningTime,
    required this.mostPracticedTopics,
    required this.topicCounts,
  });

  factory PzHomeMetricsModel.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return PzHomeMetricsModel(
        completedActivities: 0,
        answerSuccessRate: 0.0,
        dayStreak: 0,
        weeklyStreak: List.filled(7, false),
        averageDailyLearningTime: 0,
        mostPracticedTopics: [],
        topicCounts: {},
      );
    }

    // Parse topic counts from Firebase
    Map<String, int> parsedTopicCounts = {};
    if (map['topicCounts'] != null) {
      final topicCountsMap = map['topicCounts'] as Map<String, dynamic>;
      parsedTopicCounts = topicCountsMap.map(
        (key, value) => MapEntry(key, value as int),
      );
    }

    return PzHomeMetricsModel(
      completedActivities: map['completedActivities'] ?? 0,
      answerSuccessRate: (map['answerSuccessRate'] ?? 0).toDouble(),
      dayStreak: map['dayStreak'] ?? 0,
      weeklyStreak:
          (map['weeklyStreak'] as List?)?.map((e) => e == true).toList() ??
          List.filled(7, false),
      averageDailyLearningTime: map['averageDailyLearningTime'] ?? 0,
      mostPracticedTopics:
          (map['mostPracticedTopics'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      topicCounts: parsedTopicCounts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedActivities': completedActivities,
      'answerSuccessRate': answerSuccessRate,
      'dayStreak': dayStreak,
      'weeklyStreak': weeklyStreak,
      'averageDailyLearningTime': averageDailyLearningTime,
      'mostPracticedTopics': mostPracticedTopics,
      'topicCounts': topicCounts,
    };
  }

  PzHomeMetricsModel copyWith({
    int? completedActivities,
    double? answerSuccessRate,
    int? dayStreak,
    List<bool>? weeklyStreak,
    int? averageDailyLearningTime,
    List<String>? mostPracticedTopics,
    Map<String, int>? topicCounts,
  }) {
    return PzHomeMetricsModel(
      completedActivities: completedActivities ?? this.completedActivities,
      answerSuccessRate: answerSuccessRate ?? this.answerSuccessRate,
      dayStreak: dayStreak ?? this.dayStreak,
      weeklyStreak: weeklyStreak ?? this.weeklyStreak,
      averageDailyLearningTime:
          averageDailyLearningTime ?? this.averageDailyLearningTime,
      mostPracticedTopics: mostPracticedTopics ?? this.mostPracticedTopics,
      topicCounts: topicCounts ?? this.topicCounts,
    );
  }
}
