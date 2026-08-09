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
      final endedAt = DateTime.now();
      final sessionDuration = endedAt.difference(_sessionStartTime!).inMinutes;

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

        final updatedMetrics = currentMetrics.recordLearningSession(
          sessionMinutes: sessionDuration,
          endedAt: endedAt,
        );

        logger.i(
          '📚 Total Learning Time: ${updatedMetrics.totalLearningTime} min',
        );
        logger.i(
          '📚 Average Daily Learning Time: '
          '${updatedMetrics.averageDailyLearningTime} min',
        );

        await docRef.update({
          'metrics.averageDailyLearningTime':
              updatedMetrics.averageDailyLearningTime,
          'metrics.totalLearningTime': updatedMetrics.totalLearningTime,
          'metrics.learningTimeByDate': updatedMetrics.learningTimeByDate,
        });

        logger.i(
          '✅ Learning session metrics updated successfully. '
          'Duration: ${sessionDuration}min, '
          'Average: ${updatedMetrics.averageDailyLearningTime}min',
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
