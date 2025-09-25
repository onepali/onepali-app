import '../core.dart';

class LearningSessionManager {
  static final LearningSessionManager _instance =
      LearningSessionManager._internal();
  factory LearningSessionManager() => _instance;
  LearningSessionManager._internal();

  DateTime? _sessionStartTime;
  String? _currentParentUid;
  String? _currentChildUid;
  bool _sessionActive = false;

  // Start session with user IDs
  void startSession({required String parentUid, required String childUid}) {
    _sessionStartTime = DateTime.now();
    _currentParentUid = parentUid;
    _currentChildUid = childUid;
    _sessionActive = true;
    logger.d('Learning session started for child: $childUid');
  }

  // End session without requiring context
  Future<void> endSession() async {
    if (!_sessionActive ||
        _sessionStartTime == null ||
        _currentParentUid == null ||
        _currentChildUid == null) {
      return;
    }

    try {
      final sessionDuration = DateTime.now()
          .difference(_sessionStartTime!)
          .inMinutes;

      logger.w('🚨 LearningSessionManager.endSession() called');
      logger.w(
        '🚨 This method used to update metrics directly, but now deferred to PzMetricsProvider',
      );
      logger.w('🚨 Session duration: ${sessionDuration}min');

      // DISABLED: Direct Firestore updates to prevent conflicts with PzMetricsProvider
      // The PzMetricsProvider.endLearningSession() should handle all metric updates

      /*
      // Update metrics directly with Firestore
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore
          .collection(AppConstants.usersCollection)
          .doc(_currentParentUid!)
          .collection(AppConstants.childrenCollection)
          .doc(_currentChildUid!);

      // Get current metrics
      final doc = await docRef.get();

      if (doc.exists && doc.data()?['metrics'] != null) {
        final currentMetrics = PzHomeMetricsModel.fromJson(
          doc.data()?['metrics'],
        );

        // Calculate new average daily learning time
        final currentTime = currentMetrics.averageDailyLearningTime;
        final newAverageTime =
            ((currentTime * 6 + sessionDuration) / 7).round();

        // Update daily streak for today
        final today = DateTime.now();
        final weekday = today.weekday % 7; // 0 = Sunday, 6 = Saturday
        final newWeeklyStreak = List<bool>.from(currentMetrics.weeklyStreak);
        newWeeklyStreak[weekday] = true;

        // Calculate day streak (consecutive days this week)
        final dayStreak = newWeeklyStreak.where((day) => day).length;

        // Update metrics
        await docRef.update({
          'metrics.averageDailyLearningTime': newAverageTime,
          'metrics.dayStreak': dayStreak,
          'metrics.weeklyStreak': newWeeklyStreak,
        });

        logger.d(
          'Learning session ended. Duration: ${sessionDuration}min, New average: ${newAverageTime}min',
        );
      }
      */

      logger.i(
        'Session tracking completed (metrics update handled by PzMetricsProvider)',
      );
    } catch (e) {
      logger.e('Error ending learning session: $e');
    } finally {
      _sessionActive = false;
      _sessionStartTime = null;
      _currentParentUid = null;
      _currentChildUid = null;
    }
  }

  // Check if session is active
  bool get isSessionActive => _sessionActive;

  // Get current session duration in minutes
  int getCurrentSessionDuration() {
    if (_sessionStartTime == null) return 0;
    return DateTime.now().difference(_sessionStartTime!).inMinutes;
  }
}
