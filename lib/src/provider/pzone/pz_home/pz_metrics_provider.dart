import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../src.dart';

enum ActivityType { lesson, story, song }

class PzMetricsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PzHomeMetricsModel? _metrics;
  DataFetchStatus _status = DataFetchStatus.initial;

  PzHomeMetricsModel? get metrics => _metrics;
  DataFetchStatus get status => _status;

  // Track session start time for learning duration calculation
  DateTime? _sessionStartTime;
  final Map<String, int> _sessionTopicDurations = {};
  final Map<String, int> _sessionCorrectAnswers = {};
  final Map<String, int> _sessionTotalAnswers = {};

  Future<void> fetchMetrics({
    required String parentUid,
    required String childUid,
  }) async {
    _status = DataFetchStatus.loading;
    notifyListeners();
    try {
      final doc =
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(parentUid)
              .collection(AppConstants.childrenCollection)
              .doc(childUid)
              .get();

      if (doc.exists && doc.data()?['metrics'] != null) {
        // Metrics exist, load them
        _metrics = PzHomeMetricsModel.fromJson(doc.data()?['metrics']);
      } else {
        // Metrics don't exist, create default metrics using updateMetrics
        final defaultMetrics = PzHomeMetricsModel.fromJson(null);
        await updateMetrics(
          parentUid: parentUid,
          childUid: childUid,
          newMetrics: defaultMetrics,
        );
        return;
      }

      _status = DataFetchStatus.success;
    } catch (e) {
      _metrics = null;
      _status = DataFetchStatus.error;
    }
    notifyListeners();
  }

  Future<void> updateMetrics({
    required String parentUid,
    required String childUid,
    required PzHomeMetricsModel newMetrics,
  }) async {
    _status = DataFetchStatus.loading;
    notifyListeners();
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid)
          .update({
            'metrics': {
              'completedActivities': newMetrics.completedActivities,
              'answerSuccessRate': newMetrics.answerSuccessRate,
              'dayStreak': newMetrics.dayStreak,
              'weeklyStreak': newMetrics.weeklyStreak,
              'averageDailyLearningTime': newMetrics.averageDailyLearningTime,
              'mostPracticedTopics': newMetrics.mostPracticedTopics,
            },
          });
      _metrics = newMetrics;
      _status = DataFetchStatus.success;
    } catch (e) {
      // If update fails (document or metrics field doesn't exist), create it with set
      try {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(parentUid)
            .collection(AppConstants.childrenCollection)
            .doc(childUid)
            .set({
              'metrics': {
                'completedActivities': newMetrics.completedActivities,
                'answerSuccessRate': newMetrics.answerSuccessRate,
                'dayStreak': newMetrics.dayStreak,
                'weeklyStreak': newMetrics.weeklyStreak,
                'averageDailyLearningTime': newMetrics.averageDailyLearningTime,
                'mostPracticedTopics': newMetrics.mostPracticedTopics,
              },
            }, SetOptions(merge: true));
        _metrics = newMetrics;
        _status = DataFetchStatus.success;
      } catch (setError) {
        _status = DataFetchStatus.error;
      }
    }
    notifyListeners();
  }

  // Start a learning session
  void startLearningSession() {
    _sessionStartTime = DateTime.now();
    _sessionTopicDurations.clear();
    _sessionCorrectAnswers.clear();
    _sessionTotalAnswers.clear();
  }

  // End learning session and update metrics
  Future<void> endLearningSession({
    required String parentUid,
    required String childUid,
  }) async {
    if (_sessionStartTime == null || _metrics == null) return;

    final sessionDuration =
        DateTime.now().difference(_sessionStartTime!).inMinutes;

    // Calculate new average daily learning time
    final currentTime = _metrics!.averageDailyLearningTime;
    final newAverageTime = ((currentTime * 6 + sessionDuration) / 7).round();

    // Update daily streak for today
    final today = DateTime.now();
    final weekday = today.weekday % 7; // 0 = Sunday, 6 = Saturday
    final newWeeklyStreak = List<bool>.from(_metrics!.weeklyStreak);
    newWeeklyStreak[weekday] = true;

    // Calculate day streak (consecutive days this week)
    final dayStreak = newWeeklyStreak.where((day) => day).length;

    final updatedMetrics = _metrics!.copyWith(
      averageDailyLearningTime: newAverageTime,
      dayStreak: dayStreak,
      weeklyStreak: newWeeklyStreak,
    );

    await updateMetrics(
      parentUid: parentUid,
      childUid: childUid,
      newMetrics: updatedMetrics,
    );

    _sessionStartTime = null;
  }

  // Track activity completion (lessons, stories, songs)
  Future<void> trackActivityCompletion({
    required String parentUid,
    required String childUid,
    required String topicName, // e.g., "Alphabets", "Animals", "Festival Songs"
    required ActivityType activityType, // lesson, story, song
  }) async {
    if (_metrics == null) return;

    // Increment completed activities
    final newCompletedActivities = _metrics!.completedActivities + 1;

    // Update most practiced topics
    final topicCounts = <String, int>{};
    for (final topic in _metrics!.mostPracticedTopics) {
      topicCounts[topic] = (topicCounts[topic] ?? 0) + 1;
    }
    topicCounts[topicName] = (topicCounts[topicName] ?? 0) + 1;

    // Sort topics by count and take top 5
    final sortedTopics =
        topicCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final mostPracticedTopics = sortedTopics.take(5).map((e) => e.key).toList();

    final updatedMetrics = _metrics!.copyWith(
      completedActivities: newCompletedActivities,
      mostPracticedTopics: mostPracticedTopics,
    );

    await updateMetrics(
      parentUid: parentUid,
      childUid: childUid,
      newMetrics: updatedMetrics,
    );

    logger.d(
      'Activity completed: $topicName ($activityType). Total activities: $newCompletedActivities',
    );
  }

  // Track answer for success rate calculation
  Future<void> trackAnswer({
    required String parentUid,
    required String childUid,
    required bool isCorrect,
    required String topicName,
  }) async {
    if (_metrics == null) return;

    // Update session tracking
    _sessionCorrectAnswers[topicName] =
        (_sessionCorrectAnswers[topicName] ?? 0) + (isCorrect ? 1 : 0);
    _sessionTotalAnswers[topicName] =
        (_sessionTotalAnswers[topicName] ?? 0) + 1;

    // Calculate new success rate (weighted average with previous rate)
    final currentRate = _metrics!.answerSuccessRate;
    final sessionTotalAnswers = _sessionTotalAnswers.values.fold(
      0,
      (total, answerCount) => total + answerCount,
    );
    final sessionCorrectAnswers = _sessionCorrectAnswers.values.fold(
      0,
      (total, answerCount) => total + answerCount,
    );

    // Use exponential moving average for smoother rate calculation
    final sessionSuccessRate =
        sessionTotalAnswers > 0
            ? sessionCorrectAnswers / sessionTotalAnswers
            : 0.0;
    final alpha = 0.1; // Smoothing factor
    final newSuccessRate =
        currentRate == 0.0
            ? sessionSuccessRate
            : (alpha * sessionSuccessRate + (1 - alpha) * currentRate);

    final updatedMetrics = _metrics!.copyWith(
      answerSuccessRate: newSuccessRate,
    );

    await updateMetrics(
      parentUid: parentUid,
      childUid: childUid,
      newMetrics: updatedMetrics,
    );

    logger.d(
      'Answer tracked: ${isCorrect ? 'Correct' : 'Incorrect'}. New success rate: ${(newSuccessRate * 100).toStringAsFixed(1)}%',
    );
  }

  // Reset weekly streak (call this at the start of each week)
  Future<void> resetWeeklyStreak({
    required String parentUid,
    required String childUid,
  }) async {
    if (_metrics == null) return;

    final updatedMetrics = _metrics!.copyWith(
      weeklyStreak: List.filled(7, false),
      dayStreak: 0,
    );

    await updateMetrics(
      parentUid: parentUid,
      childUid: childUid,
      newMetrics: updatedMetrics,
    );

    logger.d('Weekly streak reset');
  }

  // Get formatted success rate as percentage
  String getFormattedSuccessRate() {
    if (_metrics == null) return '0%';
    return '${(_metrics!.answerSuccessRate * 100).toStringAsFixed(1)}%';
  }

  // Get formatted average learning time
  String getFormattedAverageLearningTime() {
    if (_metrics == null) return '0 min';
    final minutes = _metrics!.averageDailyLearningTime;
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0
          ? '${hours}h ${remainingMinutes}m'
          : '${hours}h';
    }
  }

  // Check if we need to reset weekly streak
  Future<void> checkAndResetWeeklyStreak({
    required String parentUid,
    required String childUid,
  }) async {
    final SharedPreferencesService prefs = SharedPreferencesService();
    final lastResetWeek =
        await prefs.getStringPref('lastWeekReset_$childUid') ?? '';
    final currentWeek = _getCurrentWeekString();

    if (lastResetWeek != currentWeek) {
      await resetWeeklyStreak(parentUid: parentUid, childUid: childUid);
      await prefs.setStringPref('lastWeekReset_$childUid', currentWeek);
    }
  }

  String _getCurrentWeekString() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    return '${startOfWeek.year}-W${_getWeekNumber(startOfWeek)}';
  }

  int _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(startOfYear).inDays;
    return (days / 7).ceil();
  }
}
