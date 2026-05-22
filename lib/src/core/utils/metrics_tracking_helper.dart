import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class MetricsTrackingHelper {
  // Start a learning session when child starts any activity
  static void startLearningSession(BuildContext context) async {
    try {
      // Check if context is mounted before proceeding
      if (!context.mounted) {
        logger.w('Context not mounted, skipping learning session start');
        return;
      }

      final userProvider = context.read<UserProvider>();
      // final authState = context.read<AuthState>();

      final parentUid = userProvider.userId;
      final childUid = await ChildLocalStorage.getCurrentChildId();
      logger.d(
        'Starting learning session with parentUid: $parentUid, childUid: $childUid',
      );
      if (parentUid != null && childUid != null) {
        // Use session manager for robust session tracking
        LearningSessionManager().startSession(
          parentUid: parentUid,
          childUid: childUid,
        );

        // Also start provider session for real-time tracking
        if (!context.mounted) return;
        context.read<PzMetricsProvider>().startLearningSession();
        logger.d('Learning session started for child: $childUid');
      } else {
        logger.w('Missing parentUid or childUid, cannot start session');
      }
    } catch (e) {
      logger.e('Error starting learning session: $e');
    }
  }

  // Safe version for initState - automatically delays execution
  static void startLearningSessionSafe(BuildContext context) {
    Misc.onLayoutRendered(() {
      startLearningSession(context);
    });
  }

  // End learning session when child exits activities (safe for dispose)
  static Future<void> endLearningSession(BuildContext context) async {
    try {
      // Use session manager (doesn't require context to be mounted)
      await LearningSessionManager().endSession();
      logger.d('Learning session ended via session manager');

      // ALSO call PzMetricsProvider to actually update the metrics
      if (context.mounted) {
        final userProvider = context.read<UserProvider>();
        final parentUid = userProvider.userId;
        final childUid = await ChildLocalStorage.getCurrentChildId();

        if (parentUid != null && childUid != null) {
          await context.read<PzMetricsProvider>().endLearningSession(
            parentUid: parentUid,
            childUid: childUid,
          );
          logger.d('Learning session metrics updated via PzMetricsProvider');
        }
      }
    } catch (e) {
      logger.e('Error ending learning session: $e');
    }
  }

  // Context-free version for dispose() methods - completely safe
  // This now properly updates metrics via LearningSessionManager
  static Future<void> endLearningSessionSafe() async {
    try {
      await LearningSessionManager().endSession();
      logger.d('✅ Learning session ended safely via session manager');
      logger.d('✅ Metrics updated directly to Firestore (context-free)');
    } catch (e) {
      logger.e('❌ Error ending learning session safely: $e');
    }
  }

  // Track lesson completion
  static Future<void> trackLessonCompletion({
    required BuildContext context,
    required String lessonId,
    required String topicName,
  }) async {
    try {
      logger.d(
        'trackLessonCompletion called for lessonId: $lessonId, topicName: $topicName',
      );

      if (!context.mounted) return;

      final userProvider = context.read<UserProvider>();
      final lessonProvider = context.read<LessonProvider>();
      final parentUid = userProvider.userId;
      final childUid = await ChildLocalStorage.getCurrentChildId();

      logger.d(
        'trackLessonCompletion - parentUid: $parentUid, childUid: $childUid',
      );

      if (parentUid != null && childUid != null) {
        // Increment completed lessons count to collect the reward.
        await lessonProvider.incrementCompletedLessonsCount(
          parentUid: parentUid,
          childUid: childUid,
          lessonId: lessonId,
        );
        // Track the lesson completion.
        await lessonProvider.trackContentCompletion(
          parentUid: parentUid,
          childUid: childUid,
          contentId: lessonId,
          contentName: topicName,
          activityType: ActivityType.lesson,
        );
      } else {
        logger.w('trackLessonCompletion - missing parentUid or childUid');
      }
    } catch (e) {
      logger.e('Error tracking lesson completion: $e');
    }
  }

  // Track story completion
  static Future<void> trackStoryCompletion({
    required BuildContext context,
    required String storyId,
    required String storyTitle,
    String? childUid,
  }) async {
    try {
      if (!context.mounted) return;

      final userProvider = context.read<UserProvider>();
      final lessonProvider = context.read<LessonProvider>();
      final parentUid = userProvider.userId;
      final resolvedChildUid =
          childUid ?? await ChildLocalStorage.getCurrentChildId();

      if (parentUid != null && resolvedChildUid != null) {
        await lessonProvider.trackContentCompletion(
          parentUid: parentUid,
          childUid: resolvedChildUid,
          contentId: storyId,
          contentName: storyTitle,
          activityType: ActivityType.story,
        );
      }
    } catch (e) {
      logger.e('Error tracking story completion: $e');
    }
  }

  // Track song completion
  static Future<void> trackSongCompletion({
    required BuildContext context,
    required String songId,
    required String songTitle,
    required String categoryName,
  }) async {
    try {
      final userProvider = context.read<UserProvider>();
      // final authState = context.read<AuthState>();

      final parentUid = userProvider.userId;
      final childUid = await ChildLocalStorage.getCurrentChildId();

      if (parentUid != null && childUid != null) {
        if (!context.mounted) return;
        await context.read<SongProvider>().trackSongCompletion(
          parentUid: parentUid,
          childUid: childUid,
          songId: songId,
          songTitle: songTitle,
          categoryName: categoryName,
          context: context,
        );
      }
    } catch (e) {
      logger.e('Error tracking song completion: $e');
    }
  }

  // Track lesson answer
  static Future<void> trackLessonAnswer({
    required BuildContext context,
    required bool isCorrect,
    required String topicName,
  }) async {
    try {
      final userProvider = context.read<UserProvider>();
      // final authState = context.read<AuthState>();

      final parentUid = userProvider.userId;
      final childUid = await ChildLocalStorage.getCurrentChildId();

      if (parentUid != null && childUid != null) {
        if (!context.mounted) return;
        await context.read<LessonProvider>().trackLessonAnswer(
          parentUid: parentUid,
          childUid: childUid,
          isCorrect: isCorrect,
          topicName: topicName,
          context: context,
        );
      }
    } catch (e) {
      logger.e('Error tracking lesson answer: $e');
    }
  }

  // Track story answer
  static Future<void> trackStoryAnswer({
    required BuildContext context,
    required bool isCorrect,
    required String storyTitle,
  }) async {
    try {
      final userProvider = context.read<UserProvider>();
      // final authState = context.read<AuthState>();

      final parentUid = userProvider.userId;
      final childUid = await ChildLocalStorage.getCurrentChildId();

      if (parentUid != null && childUid != null) {
        if (!context.mounted) return;
        await context.read<StoryProvider>().trackStoryAnswer(
          parentUid: parentUid,
          childUid: childUid,
          isCorrect: isCorrect,
          storyTitle: storyTitle,
          context: context,
        );
      }
    } catch (e) {
      logger.e('Error tracking story answer: $e');
    }
  }

  // Check if a learning session is currently active
  static bool isSessionActive() {
    return LearningSessionManager().isSessionActive;
  }

  // Get current session duration in minutes
  static int getCurrentSessionDuration() {
    return LearningSessionManager().getCurrentSessionDuration();
  }

  // Handle app lifecycle changes
  static void handleAppLifecycleChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // End session when app goes to background or is closed
        LearningSessionManager().endSession();
        logger.d('Learning session ended due to app lifecycle change: $state');
        break;
      default:
        break;
    }
  }
}
