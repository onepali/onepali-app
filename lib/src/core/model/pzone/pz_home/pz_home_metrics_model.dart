class PzHomeMetricsModel {
  final int completedActivities;
  final double answerSuccessRate;
  final int dayStreak;
  final List<bool> weeklyStreak;
  final String lastActiveDate;
  final int averageDailyLearningTime;
  final int totalLearningTime;
  final Map<String, int> learningTimeByDate;
  final List<String> mostPracticedTopics;
  final Map<String, int> topicCounts; // New field to track topic counts

  PzHomeMetricsModel({
    required this.completedActivities,
    required this.answerSuccessRate,
    required this.dayStreak,
    required this.weeklyStreak,
    required this.lastActiveDate,
    required this.averageDailyLearningTime,
    required this.totalLearningTime,
    required this.learningTimeByDate,
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
        totalLearningTime: 0,
        learningTimeByDate: {},
        mostPracticedTopics: [],
        topicCounts: {},
      );
    }

    final parsedTopicCounts = _parseIntMap(map['topicCounts']);
    final parsedLearningTimeByDate = _parseIntMap(map['learningTimeByDate']);
    final legacyAverageLearningTime =
        (map['averageDailyLearningTime'] as num?)?.toInt() ?? 0;
    final totalLearningTime =
        (map['totalLearningTime'] as num?)?.toInt() ??
        _sumIntMap(parsedLearningTimeByDate) ??
        legacyAverageLearningTime;
    final activeLearningDays = parsedLearningTimeByDate.values
        .where((minutes) => minutes > 0)
        .length;
    final averageDailyLearningTime = parsedLearningTimeByDate.isEmpty
        ? legacyAverageLearningTime
        : _averageLearningTime(totalLearningTime, activeLearningDays);

    return PzHomeMetricsModel(
      completedActivities: map['completedActivities'] ?? 0,
      answerSuccessRate: (map['answerSuccessRate'] ?? 0).toDouble(),
      dayStreak: map['dayStreak'] ?? 0,
      weeklyStreak:
          (map['weeklyStreak'] as List?)?.map((e) => e == true).toList() ??
          List.filled(7, false),
      lastActiveDate: map['lastActiveDate'] ?? '',
      averageDailyLearningTime: averageDailyLearningTime,
      totalLearningTime: totalLearningTime,
      learningTimeByDate: parsedLearningTimeByDate,
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
      'totalLearningTime': totalLearningTime,
      'learningTimeByDate': learningTimeByDate,
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
    int? totalLearningTime,
    Map<String, int>? learningTimeByDate,
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
      totalLearningTime: totalLearningTime ?? this.totalLearningTime,
      learningTimeByDate: learningTimeByDate ?? this.learningTimeByDate,
      mostPracticedTopics: mostPracticedTopics ?? this.mostPracticedTopics,
      topicCounts: topicCounts ?? this.topicCounts,
    );
  }

  PzHomeMetricsModel recordLearningSession({
    required int sessionMinutes,
    required DateTime endedAt,
  }) {
    if (sessionMinutes <= 0) return this;

    final dailyLearningTime = Map<String, int>.from(learningTimeByDate);
    if (dailyLearningTime.isEmpty && totalLearningTime > 0) {
      dailyLearningTime[_legacyLearningDateKey(endedAt)] = totalLearningTime;
    }

    final activeDate = DateTime(endedAt.year, endedAt.month, endedAt.day);
    final activeDateKey = _dateKey(activeDate);
    dailyLearningTime[activeDateKey] =
        (dailyLearningTime[activeDateKey] ?? 0) + sessionMinutes;

    final totalMinutes = dailyLearningTime.values.fold<int>(
      0,
      (sum, minutes) => sum + minutes,
    );
    final activeLearningDays = dailyLearningTime.values
        .where((minutes) => minutes > 0)
        .length;

    return copyWith(
      totalLearningTime: totalMinutes,
      learningTimeByDate: dailyLearningTime,
      averageDailyLearningTime: _averageLearningTime(
        totalMinutes,
        activeLearningDays,
      ),
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

  String _legacyLearningDateKey(DateTime endedAt) {
    final lastActiveDay = DateTime.tryParse(lastActiveDate);
    return _dateKey(lastActiveDay ?? endedAt);
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

  static String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static Map<String, int> _parseIntMap(Object? value) {
    if (value is! Map) return {};
    return value.map(
      (key, value) => MapEntry(key.toString(), (value as num).toInt()),
    );
  }

  static int? _sumIntMap(Map<String, int> values) {
    if (values.isEmpty) return null;
    return values.values.fold<int>(0, (sum, value) => sum + value);
  }

  static int _averageLearningTime(int totalMinutes, int activeLearningDays) {
    if (activeLearningDays <= 0) return 0;
    return (totalMinutes / activeLearningDays).round();
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
      completedCount: (map['completed_count'] as num?)?.toInt() ?? 0,
      parentId: map['parent_id'] ?? '',
      childId: map['child_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content_id': contentId,
      'content_name': contentName,
      'content_type': contentType,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'completed_count': completedCount,
      'parent_id': parentId,
      'child_id': childId,
    };
  }
}
