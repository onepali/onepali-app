import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../src.dart';

enum ActivityType { lesson, story, song }

class PzMetricsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<PzCompletedContentModel> _completedContents = [];
  List<PzCompletedContentModel> get completedContents => _completedContents;

  PzHomeMetricsModel? _metrics;
  DataFetchStatus _status = DataFetchStatus.initial;

  PzHomeMetricsModel? get metrics => _metrics;
  DataFetchStatus get status => _status;

  // Track session start time for learning duration calculation
  DateTime? _sessionStartTime;
  final Map<String, int> _sessionTopicDurations = {};
  final Map<String, int> _sessionCorrectAnswers = {};
  final Map<String, int> _sessionTotalAnswers = {};

  Future<void> fetchCompletedContents({
    required String parentUid,
    required String childUid,
  }) async {
    _status = DataFetchStatus.loading;
    notifyListeners();
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid)
          .collection(AppConstants.completedContentCollection)
          .get();
      _completedContents = doc.docs
          .map((doc) => PzCompletedContentModel.fromJson(doc.data()))
          .toList();
      _status = DataFetchStatus.success;
    } catch (e) {
      _completedContents = [];
      _status = DataFetchStatus.error;
    }
    notifyListeners();
  }

  Future<void> fetchMetrics({
    required String parentUid,
    required String childUid,
  }) async {
    _status = DataFetchStatus.loading;
    await fetchCompletedContents(parentUid: parentUid, childUid: childUid);
    notifyListeners();
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid)
          .get();

      if (doc.exists && doc.data()?['metrics'] != null) {
        // Metrics exist, load them
        logger.i('📊 Loading existing metrics from Firestore');
        _metrics = PzHomeMetricsModel.fromJson(doc.data()?['metrics']);
        logger.i(
          '📊 Loaded metrics: weeklyStreak=${_metrics!.weeklyStreak}, dayStreak=${_metrics!.dayStreak}',
        );
      } else {
        // CRITICAL: Only create default metrics if document truly doesn't exist
        if (!doc.exists) {
          logger.w('⚠️  Child document does not exist. Creating new metrics.');
          final defaultMetrics = PzHomeMetricsModel.fromJson(null);
          await updateMetrics(
            parentUid: parentUid,
            childUid: childUid,
            newMetrics: defaultMetrics,
          );
        } else {
          logger.e(
            '🚨 CRITICAL: Document exists but metrics field is null/missing!',
          );
          logger.e('🚨 Document data: ${doc.data()}');
          // Load what we can and preserve existing data
          final existingData = doc.data() ?? {};
          logger.w('⚠️  Creating minimal metrics without overwriting document');
          _metrics = PzHomeMetricsModel.fromJson(existingData['metrics']);
        }
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

    // 🛡️ SAFETY CHECK: Prevent overwriting valid data with empty data
    if (_metrics != null) {
      final currentActiveDays = _metrics!.weeklyStreak
          .where((day) => day)
          .length;
      final newActiveDays = newMetrics.weeklyStreak.where((day) => day).length;

      // If current data has progress but new data is empty, this is suspicious
      if (currentActiveDays > 0 &&
          newActiveDays == 0 &&
          newMetrics.dayStreak == 0) {
        logger.e(
          '🚨 PREVENTED DATA LOSS: Attempted to overwrite active streak with empty data!',
        );
        logger.e(
          '🚨 Current active days: $currentActiveDays, New active days: $newActiveDays',
        );
        logger.e(
          '🚨 Current day streak: ${_metrics!.dayStreak}, New day streak: ${newMetrics.dayStreak}',
        );
        _status = DataFetchStatus.error;
        notifyListeners();
        return;
      }
    }

    // Log the update for debugging
    final activeDays = newMetrics.weeklyStreak.where((day) => day).length;
    logger.i(
      '💾 Updating metrics: activeDays=$activeDays, dayStreak=${newMetrics.dayStreak}',
    );

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
      logger.i('✅ Metrics updated successfully in Firestore');
    } catch (e) {
      logger.w('⚠️  Update failed, trying set with merge: $e');
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
        logger.i('✅ Metrics created successfully in Firestore');
      } catch (setError) {
        logger.e('❌ Failed to save metrics: $setError');
        _status = DataFetchStatus.error;
      }
    }
    notifyListeners();
  }

  // Future<void> updateActiveDayStreak({
  //   required String childUid,
  // }) async {
  //   final parentUid = FirebaseAuth.instance.currentUser?.uid;
  //   if (parentUid == null) return;
  //   // find the current day (if sunday )
  //   final today = DateTime.now();
  //   final weekday = today.weekday % 7; // 0 = Sunday, 6 = Saturday
  //   if (weekday == 0) {
  //     // Sunday
  //     await _firestore
  //         .collection(AppConstants.usersCollection)
  //         .doc(parentUid)
  //         .collection(AppConstants.childrenCollection)
  //   await _firestore
  //       .collection(AppConstants.usersCollection)
  //       .doc(parentUid)
  //       .collection(AppConstants.childrenCollection)
  //       .doc(childUid);
  // }

  Future<void> trackAnswer1({required bool isCorrect}) async {
    try {
      // Update right_answers_count or wrong_answers_count inside children doc based on isCorrect
      final parentId = FirebaseAuth.instance.currentUser?.uid;
      final childId = await ChildLocalStorage.getCurrentChildId();
      if (parentId == null || childId == null) return;
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentId)
          .collection(AppConstants.childrenCollection)
          .doc(childId)
          .update({
            'right_answers_count': isCorrect
                ? FieldValue.increment(1)
                : FieldValue.increment(0),
            'wrong_answers_count': isCorrect
                ? FieldValue.increment(0)
                : FieldValue.increment(1),
          });
    } catch (e) {
      logger.e('Error updating success: $e');
    }
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

    final sessionDuration = DateTime.now()
        .difference(_sessionStartTime!)
        .inMinutes;

    // Calculate new average daily learning time
    // Simply add the new session duration to the existing total
    final currentTime = _metrics!.averageDailyLearningTime;
    final newAverageTime = currentTime + sessionDuration;

    // Update daily streak for today
    final today = DateTime.now();
    final weekday = today.weekday % 7; // 0 = Sunday, 6 = Saturday
    final weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final currentDayName = weekdays[weekday];

    final previousWeeklyStreak = List<bool>.from(_metrics!.weeklyStreak);
    final newWeeklyStreak = List<bool>.from(_metrics!.weeklyStreak);
    final wasAlreadyActive = newWeeklyStreak[weekday];
    newWeeklyStreak[weekday] = true;

    // Calculate day streak (consecutive days this week)
    final dayStreak = newWeeklyStreak.where((day) => day).length;

    // Log the learning session completion
    logger.i('📚 Learning Session Completed:');
    logger.i('📚 Session Duration: $sessionDuration minutes');
    logger.i('📚 Today: $currentDayName (index: $weekday)');
    logger.i('📚 Was already active today: ${wasAlreadyActive ? 'Yes' : 'No'}');
    logger.i('📚 Previous Average Learning Time: $currentTime min');
    logger.i('📚 New Average Learning Time: $newAverageTime min');

    final previousStreakStatus = previousWeeklyStreak
        .map((active) => active ? '✅' : '❌')
        .join(' ');
    final newStreakStatus = newWeeklyStreak
        .map((active) => active ? '✅' : '❌')
        .join(' ');
    logger.i('📚 Previous Weekly Streak: $previousStreakStatus');
    logger.i('📚 Updated Weekly Streak:  $newStreakStatus');
    logger.i('📚 New Day Streak Count: $dayStreak/7');

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
    if (_metrics == null) {
      await fetchMetrics(parentUid: parentUid, childUid: childUid);
      if (_metrics == null) {
        logger.e('🚨 Failed to fetch metrics: metrics is null');
        return;
      }
    }

    // Increment completed activities
    final newCompletedActivities = _metrics!.completedActivities + 1;

    // Update most practiced topics - add the new topic to the list
    final updatedTopicsList = List<String>.from(_metrics!.mostPracticedTopics);
    updatedTopicsList.add(topicName);

    // Count occurrences of each topic
    final topicCounts = <String, int>{};
    for (final topic in updatedTopicsList) {
      topicCounts[topic] = (topicCounts[topic] ?? 0) + 1;
    }

    // Sort topics by count (descending) and take top 5
    final sortedTopics = topicCounts.entries.toList()
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
      'Activity completed: $topicName ($activityType). Total activities: $newCompletedActivities. Most practiced: $mostPracticedTopics',
    );

    // 🎯 IMPORTANT: Also mark today as an active learning day
    // This ensures that completing activities also updates the weekly streak
    logger.i(
      '🎯 Activity completion: Ensuring today is marked as active learning day',
    );

    // 🛡️ CRITICAL FIX: Refresh metrics from Firestore to get latest data
    // This prevents data loss from concurrent updates or stale local data
    logger.w(
      '🔄 Refreshing metrics from Firestore before updating weekly streak',
    );
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid)
          .get();

      if (doc.exists && doc.data()?['metrics'] != null) {
        final freshMetrics = PzHomeMetricsModel.fromJson(
          doc.data()?['metrics'],
        );
        logger.i('🔄 Fresh metrics loaded from Firestore');
        logger.i(
          '🔄 Fresh weekly streak: ${freshMetrics.weeklyStreak.map((active) => active ? '✅' : '❌').join(' ')}',
        );

        // Use fresh metrics for weekly streak calculation
        final today = DateTime.now();
        final weekday = today.weekday % 7; // 0 = Sunday, 6 = Saturday
        final currentWeeklyStreak = List<bool>.from(freshMetrics.weeklyStreak);
        final wasAlreadyActive = currentWeeklyStreak[weekday];

        if (!wasAlreadyActive) {
          logger.i(
            '🎯 Today was not marked as active, updating weekly streak now',
          );
          // Mark today as active
          currentWeeklyStreak[weekday] = true;
          final newDayStreak = currentWeeklyStreak.where((day) => day).length;

          // Combine the activity updates with the fresh weekly streak
          final finalUpdatedMetrics = updatedMetrics.copyWith(
            weeklyStreak: currentWeeklyStreak,
            dayStreak: newDayStreak,
          );

          await updateMetrics(
            parentUid: parentUid,
            childUid: childUid,
            newMetrics: finalUpdatedMetrics,
          );

          final weekdays = [
            'Sunday',
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
          ];
          final currentDayName = weekdays[weekday];
          logger.i(
            '🎯 ✅ Weekly streak updated: Today ($currentDayName) marked as active',
          );
          logger.i('🎯 ✅ New day streak: $newDayStreak/7');
          logger.i(
            '🎯 ✅ Final weekly streak: ${currentWeeklyStreak.map((active) => active ? '✅' : '❌').join(' ')}',
          );
        } else {
          logger.i(
            '🎯 Today was already marked as active, no streak update needed',
          );
        }
      } else {
        logger.e(
          '🚨 Failed to refresh metrics - document or metrics field missing',
        );
      }
    } catch (e) {
      logger.e('🚨 Error refreshing metrics from Firestore: $e');
      // Fallback to original logic if refresh fails
      logger.w('🔄 Falling back to local metrics data');

      // Check if today is already marked as active
      final today = DateTime.now();
      final weekday = today.weekday % 7; // 0 = Sunday, 6 = Saturday
      final currentWeeklyStreak = List<bool>.from(_metrics!.weeklyStreak);
      final wasAlreadyActive = currentWeeklyStreak[weekday];

      if (!wasAlreadyActive) {
        logger.i(
          '🎯 Today was not marked as active, updating weekly streak now',
        );
        // Mark today as active
        currentWeeklyStreak[weekday] = true;
        final newDayStreak = currentWeeklyStreak.where((day) => day).length;

        // Update metrics again with the daily streak
        final finalUpdatedMetrics = updatedMetrics.copyWith(
          weeklyStreak: currentWeeklyStreak,
          dayStreak: newDayStreak,
        );

        await updateMetrics(
          parentUid: parentUid,
          childUid: childUid,
          newMetrics: finalUpdatedMetrics,
        );

        final weekdays = [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ];
        final currentDayName = weekdays[weekday];
        logger.i(
          '🎯 ✅ Weekly streak updated: Today ($currentDayName) marked as active',
        );
        logger.i('🎯 ✅ New day streak: $newDayStreak/7');
      } else {
        logger.i(
          '🎯 Today was already marked as active, no streak update needed',
        );
      }
    }
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
    final sessionSuccessRate = sessionTotalAnswers > 0
        ? sessionCorrectAnswers / sessionTotalAnswers
        : 0.0;
    final alpha = 0.1; // Smoothing factor
    final newSuccessRate = currentRate == 0.0
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
    if (_metrics == null) {
      logger.w('⚠️  Cannot reset weekly streak: metrics is null');
      return;
    }

    // Log current state before reset
    final currentStreakStatus = _metrics!.weeklyStreak
        .map((active) => active ? '✅' : '❌')
        .join(' ');
    final currentActiveDays = _metrics!.weeklyStreak.where((day) => day).length;

    logger.w('🔄 RESETTING WEEKLY STREAK:');
    logger.w('🔄 Previous State: $currentStreakStatus');
    logger.w('🔄 Previous Active Days: $currentActiveDays/7');
    logger.w('🔄 Previous Day Streak: ${_metrics!.dayStreak}');

    final updatedMetrics = _metrics!.copyWith(
      weeklyStreak: List.filled(7, false),
      dayStreak: 0,
    );

    await updateMetrics(
      parentUid: parentUid,
      childUid: childUid,
      newMetrics: updatedMetrics,
    );

    logger.i('✅ Weekly streak reset completed');
    logger.i('✅ New State: ❌ ❌ ❌ ❌ ❌ ❌ ❌ (All days cleared)');
    logger.i('✅ New Day Streak: 0');
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

    // Get current date and week info for logging
    final now = DateTime.now();
    final currentWeekday = now.weekday % 7; // 0 = Sunday, 6 = Saturday
    final weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final currentDayName = weekdays[currentWeekday];

    // Calculate days until next Sunday (week reset day)
    final daysUntilReset = currentWeekday == 0 ? 7 : 7 - currentWeekday;

    // Calculate start and end of current week
    final startOfWeek = now.subtract(Duration(days: currentWeekday));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    logger.i('📅 Weekly Streak Check for Child: $childUid');
    logger.i(
      '📅 Current Date: ${now.toString().split(' ')[0]} ($currentDayName)',
    );
    logger.i('📅 Current Week: $currentWeek');
    logger.i(
      '📅 Last Reset Week: ${lastResetWeek.isEmpty ? 'Never' : lastResetWeek}',
    );
    logger.i(
      '📅 Current Week Range: ${startOfWeek.toString().split(' ')[0]} to ${endOfWeek.toString().split(' ')[0]}',
    );
    logger.i('📅 Days until next reset (Sunday): $daysUntilReset days');

    if (_metrics != null) {
      final activeDays = _metrics!.weeklyStreak.where((day) => day).length;
      final streakStatus = _metrics!.weeklyStreak
          .map((active) => active ? '✅' : '❌')
          .join(' ');
      logger.i('📅 Current Weekly Streak: $streakStatus');
      logger.i('📅 Active Learning Days: $activeDays/7');
      logger.i('📅 Day Streak Count: ${_metrics!.dayStreak}');
    }

    if (lastResetWeek != currentWeek) {
      logger.w('🔄 NEW WEEK DETECTED! Resetting weekly streak...');
      logger.w('🔄 Previous Week: $lastResetWeek → Current Week: $currentWeek');
      await resetWeeklyStreak(parentUid: parentUid, childUid: childUid);
      await prefs.setStringPref('lastWeekReset_$childUid', currentWeek);
      logger.i('✅ Weekly streak reset completed and saved to preferences');
    } else {
      logger.i('✅ Same week detected. No reset needed.');
    }
  }

  String _getCurrentWeekString() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final weekNumber = _getWeekNumber(startOfWeek);
    final weekString = '${startOfWeek.year}-W$weekNumber';

    logger.d('🗓️  Week Calculation Details:');
    logger.d('🗓️  Current Date: ${now.toString()}');
    logger.d('🗓️  Current Weekday: ${now.weekday} (1=Monday, 7=Sunday)');
    logger.d(
      '🗓️  Adjusted Weekday: ${now.weekday % 7} (0=Sunday, 6=Saturday)',
    );
    logger.d('🗓️  Days to subtract: ${now.weekday % 7}');
    logger.d('🗓️  Start of Week: ${startOfWeek.toString()}');
    logger.d('🗓️  Week Number: $weekNumber');
    logger.d('🗓️  Generated Week String: $weekString');

    return weekString;
  }

  int _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(startOfYear).inDays;
    return (days / 7).ceil();
  }

  // Debug method to check what's actually in Firestore
  Future<void> debugFirestoreData(String parentUid, String childUid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid)
          .get();

      logger.i('🔍 FIRESTORE DEBUG:');
      logger.i('🔍 Document exists: ${doc.exists}');
      if (doc.exists) {
        final data = doc.data();
        logger.i('🔍 Document data keys: ${data?.keys.toList()}');
        logger.i('🔍 Has metrics field: ${data?.containsKey('metrics')}');
        if (data?.containsKey('metrics') == true) {
          logger.i('🔍 Metrics data: ${data!['metrics']}');
        }
      }
    } catch (e) {
      logger.e('🔍 Error checking Firestore: $e');
    }
  }

  // Debug method to log current week state (for testing purposes)
  void logCurrentWeekState(String childUid) {
    final now = DateTime.now();
    final currentWeekday = now.weekday % 7;
    final weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final currentDayName = weekdays[currentWeekday];
    final currentWeek = _getCurrentWeekString();
    final daysUntilReset = currentWeekday == 0 ? 7 : 7 - currentWeekday;

    logger.i('🔍 CURRENT WEEK STATE DEBUG:');
    logger.i('🔍 Child ID: $childUid');
    logger.i('🔍 Today: ${now.toString().split(' ')[0]} ($currentDayName)');
    logger.i('🔍 Current Week: $currentWeek');
    logger.i('🔍 Days until next reset: $daysUntilReset');

    if (_metrics != null) {
      final activeDays = _metrics!.weeklyStreak.where((day) => day).length;
      final streakStatus = _metrics!.weeklyStreak
          .map((active) => active ? '✅' : '❌')
          .join(' ');
      logger.i('🔍 Weekly Streak: $streakStatus');
      logger.i('🔍 Active Days: $activeDays/7');
      logger.i('🔍 Day Streak: ${_metrics!.dayStreak}');
    } else {
      logger.w('🔍 No metrics available');
    }
  }
}
