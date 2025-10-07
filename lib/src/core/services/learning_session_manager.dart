import 'package:cloud_firestore/cloud_firestore.dart';
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

      logger.i('� LearningSessionManager.endSession() called');
      logger.i('� Session duration: ${sessionDuration}min');

      // Update metrics directly with Firestore
      // This is needed when context is not available (e.g., in dispose methods)
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
        final newAverageTime = currentTime + sessionDuration;

        // Update daily streak for today
        final today = DateTime.now();
        final weekday = today.weekday % 7; // 0 = Sunday, 6 = Saturday
        final newWeeklyStreak = List<bool>.from(currentMetrics.weeklyStreak);
        newWeeklyStreak[weekday] = true;

        // Calculate day streak (consecutive days this week)
        final dayStreak = newWeeklyStreak.where((day) => day).length;

        logger.i('📚 Previous Average Learning Time: $currentTime min');
        logger.i('📚 New Average Learning Time: $newAverageTime min');
        logger.i('📚 Day Streak: $dayStreak/7');

        // Update metrics in Firestore
        await docRef.update({
          'metrics.averageDailyLearningTime': newAverageTime,
          'metrics.dayStreak': dayStreak,
          'metrics.weeklyStreak': newWeeklyStreak,
        });

        logger.i(
          '✅ Learning session metrics updated successfully. Duration: ${sessionDuration}min, New average: ${newAverageTime}min',
        );
      } else {
        logger.w('⚠️ No metrics found for child: $_currentChildUid');
      }

      logger.i('✅ Session tracking completed and metrics updated in Firestore');
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
