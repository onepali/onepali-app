class PzHomeMetricsModel {
  final int completedActivities;
  final double answerSuccessRate;
  final int dayStreak;
  final List<bool> weeklyStreak;
  final String lastActiveDate;
  final int averageDailyLearningTime;
  final List<String> mostPracticedTopics;
  final Map<String, int> topicCounts; // New field to track topic counts

  PzHomeMetricsModel({
    required this.completedActivities,
    required this.answerSuccessRate,
    required this.dayStreak,
    required this.weeklyStreak,
    required this.lastActiveDate,
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
        lastActiveDate: '',
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
      lastActiveDate: map['lastActiveDate'] ?? '',
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
      'lastActiveDate': lastActiveDate,
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
    String? lastActiveDate,
    int? averageDailyLearningTime,
    List<String>? mostPracticedTopics,
    Map<String, int>? topicCounts,
  }) {
    return PzHomeMetricsModel(
      completedActivities: completedActivities ?? this.completedActivities,
      answerSuccessRate: answerSuccessRate ?? this.answerSuccessRate,
      dayStreak: dayStreak ?? this.dayStreak,
      weeklyStreak: weeklyStreak ?? this.weeklyStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      averageDailyLearningTime:
          averageDailyLearningTime ?? this.averageDailyLearningTime,
      mostPracticedTopics: mostPracticedTopics ?? this.mostPracticedTopics,
      topicCounts: topicCounts ?? this.topicCounts,
    );
  }

  PzHomeMetricsModel markActiveOn(DateTime activeAt) {
    final currentMetrics = normalizedFor(activeAt);
    final activeDate = DateTime(activeAt.year, activeAt.month, activeAt.day);
    final activeDateKey = _dateKey(activeDate);
    final weeklyActivity = currentMetrics._normalizedWeeklyActivity();
    weeklyActivity[activeDate.weekday % 7] = true;

    return currentMetrics.copyWith(
      dayStreak: currentMetrics._nextDayStreak(activeDate),
      weeklyStreak: weeklyActivity,
      lastActiveDate: activeDateKey,
    );
  }

  PzHomeMetricsModel normalizedFor(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime.tryParse(lastActiveDate);
    if (lastDate == null) {
      return _normalizeFromWeeklyActivity(today);
    }

    final lastActiveDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
    final weeklyActivity = _sameWeek(lastActiveDay, today)
        ? _normalizedWeeklyActivity()
        : List<bool>.filled(7, false);

    if (_sameWeek(lastActiveDay, today)) {
      weeklyActivity[lastActiveDay.weekday % 7] = true;
    }

    final normalizedStreak = today.difference(lastActiveDay).inDays > 1
        ? 0
        : dayStreak;

    return copyWith(dayStreak: normalizedStreak, weeklyStreak: weeklyActivity);
  }

  int _nextDayStreak(DateTime activeDate) {
    final lastDate = DateTime.tryParse(lastActiveDate);
    if (lastDate == null) {
      return dayStreak > 0 ? dayStreak : 1;
    }

    final lastActiveDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
    final dayDifference = activeDate.difference(lastActiveDay).inDays;
    if (dayDifference == 0) {
      return dayStreak > 0 ? dayStreak : 1;
    }
    if (dayDifference == 1) {
      return dayStreak + 1;
    }
    return 1;
  }

  PzHomeMetricsModel _normalizeFromWeeklyActivity(DateTime today) {
    final weeklyActivity = _normalizedWeeklyActivity();
    final currentWeekday = today.weekday % 7;

    int? lastActiveWeekday;
    for (var index = currentWeekday; index >= 0; index--) {
      if (weeklyActivity[index]) {
        lastActiveWeekday = index;
        break;
      }
    }

    if (lastActiveWeekday == null) {
      return copyWith(dayStreak: 0, lastActiveDate: '');
    }

    final daysSinceLastActive = currentWeekday - lastActiveWeekday;
    if (daysSinceLastActive > 1) {
      return copyWith(dayStreak: 0, lastActiveDate: '');
    }

    var consecutiveDays = 0;
    for (var index = lastActiveWeekday; index >= 0; index--) {
      if (!weeklyActivity[index]) break;
      consecutiveDays++;
    }

    final inferredLastActiveDate = today.subtract(
      Duration(days: daysSinceLastActive),
    );
    return copyWith(
      dayStreak: consecutiveDays,
      lastActiveDate: _dateKey(inferredLastActiveDate),
    );
  }

  static String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  List<bool> _normalizedWeeklyActivity() {
    return List<bool>.generate(
      7,
      (index) => weeklyStreak.length > index && weeklyStreak[index],
    );
  }

  static bool _sameWeek(DateTime first, DateTime second) {
    return _dateKey(_startOfWeek(first)) == _dateKey(_startOfWeek(second));
  }

  static DateTime _startOfWeek(DateTime date) {
    final localDate = DateTime(date.year, date.month, date.day);
    return localDate.subtract(Duration(days: localDate.weekday % 7));
  }
}

class PzCompletedContentModel {
  final String id;
  final String contentId;
  final String contentName;
  final String contentType;
  final String createdAt;
  final String updatedAt;
  final int completedCount;
  final String parentId;
  final String childId;

  PzCompletedContentModel({
    required this.id,
    required this.contentId,
    required this.contentName,
    required this.contentType,
    required this.createdAt,
    required this.updatedAt,
    required this.completedCount,
    required this.parentId,
    required this.childId,
  });

  factory PzCompletedContentModel.fromJson(Map<String, dynamic> map) {
    return PzCompletedContentModel(
      id: map['id'] ?? '',
      contentId: map['content_id'] ?? '',
      contentName: map['content_name'] ?? '',
      contentType: map['content_type'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      completedCount: map['completed_count'] ?? 0,
      parentId: map['parent_id'] ?? '',
      childId: map['child_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentId': contentId,
      'contentName': contentName,
      'contentType': contentType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'completedCount': completedCount,
    };
  }
}
