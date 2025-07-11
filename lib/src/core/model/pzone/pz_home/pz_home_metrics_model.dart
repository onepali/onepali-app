class PzHomeMetricsModel {
  final int completedActivities;
  final double answerSuccessRate;
  final int dayStreak;
  final List<bool> weeklyStreak;
  final int averageDailyLearningTime;
  final List<String> mostPracticedTopics;

  PzHomeMetricsModel({
    required this.completedActivities,
    required this.answerSuccessRate,
    required this.dayStreak,
    required this.weeklyStreak,
    required this.averageDailyLearningTime,
    required this.mostPracticedTopics,
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
    };
  }

  PzHomeMetricsModel copyWith({
    int? completedActivities,
    double? answerSuccessRate,
    int? dayStreak,
    List<bool>? weeklyStreak,
    int? averageDailyLearningTime,
    List<String>? mostPracticedTopics,
  }) {
    return PzHomeMetricsModel(
      completedActivities: completedActivities ?? this.completedActivities,
      answerSuccessRate: answerSuccessRate ?? this.answerSuccessRate,
      dayStreak: dayStreak ?? this.dayStreak,
      weeklyStreak: weeklyStreak ?? this.weeklyStreak,
      averageDailyLearningTime:
          averageDailyLearningTime ?? this.averageDailyLearningTime,
      mostPracticedTopics: mostPracticedTopics ?? this.mostPracticedTopics,
    );
  }
}
