import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class MetricsTrackingHelper {
  static Future<PzMetricsScope?> _resolveMetricsScope(
    BuildContext context, {
    String? childUid,
  }) async {
    if (GuestUtil.isGuestUser()) {
      return null;
    }

    final parentUid = context.read<UserProvider>().userId;
    final resolvedChildUid =
        childUid ?? await ChildLocalStorage.getCurrentChildId();

    if (parentUid == null || resolvedChildUid == null) {
      return null;
    }

    return PzMetricsScope(parentUid: parentUid, childUid: resolvedChildUid);
  }

  // Start a learning session when child starts any activity
  static void startLearningSession(BuildContext context) async {
    try {
      if (!context.mounted) {
        logger.w('Context not mounted, skipping learning session start');
        return;
      }

      final scope = await _resolveMetricsScope(context);
      logger.d(
        'Starting learning session with parentUid: ${scope?.parentUid}, childUid: ${scope?.childUid}',
      );
      if (scope != null) {
        LearningSessionManager().startSession(
          parentUid: scope.parentUid,
          childUid: scope.childUid,
        );

        if (!context.mounted) return;
        context.read<PzMetricsProvider>().startLearningSession();
        logger.d('Learning session started for child: ${scope.childUid}');
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

      if (context.mounted) {
        final scope = await _resolveMetricsScope(context);
        if (scope != null) {
          if (!context.mounted) return;
          await context.read<PzMetricsProvider>().fetchMetrics(
            parentUid: scope.parentUid,
            childUid: scope.childUid,
          );
          logger.d('Learning session metrics refreshed');
        }
      }
    } catch (e) {
      logger.e('Error ending learning session: $e');
    }
  }

  // Context-free version for dispose() methods.
  // Session time is updated via LearningSessionManager.
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

      final scope = await _resolveMetricsScope(context);
      logger.d(
        'trackLessonCompletion - parentUid: ${scope?.parentUid}, childUid: ${scope?.childUid}',
      );

      if (scope != null) {
        if (!context.mounted) {
          logger.w('trackLessonCompletion - context not mounted, aborting');
          return;
        }
        logger.d(
          'trackLessonCompletion - calling LessonProvider.trackLessonCompletion',
        );
        await context.read<LessonProvider>().trackLessonCompletion(
          parentUid: scope.parentUid,
          childUid: scope.childUid,
          lessonId: lessonId,
          topicName: topicName,
          context: context,
        );
        logger.d(
          'trackLessonCompletion - LessonProvider.trackLessonCompletion completed',
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
      final scope = await _resolveMetricsScope(context, childUid: childUid);

      if (scope != null) {
        if (!context.mounted) return;
        await context.read<StoryProvider>().trackStoryCompletion(
          parentUid: scope.parentUid,
          childUid: scope.childUid,
          storyId: storyId,
          storyTitle: storyTitle,
          context: context,
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
      final scope = await _resolveMetricsScope(context);

      if (scope != null) {
        if (!context.mounted) return;
        await context.read<SongProvider>().trackSongCompletion(
          parentUid: scope.parentUid,
          childUid: scope.childUid,
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

  static Future<Set<String>> fetchCompletedContentIds({
    required BuildContext context,
    required ActivityType activityType,
    String? childUid,
  }) async {
    try {
      final scope = await _resolveMetricsScope(context, childUid: childUid);
      if (scope == null) return <String>{};
      if (!context.mounted) return <String>{};

      return context.read<PzMetricsProvider>().fetchCompletedContentIds(
        parentUid: scope.parentUid,
        childUid: scope.childUid,
        activityType: activityType,
      );
    } catch (e) {
      logger.e('Error fetching completed content ids: $e');
      return <String>{};
    }
  }

  // Track lesson answer
  static Future<void> trackAnswerAttempt({
    required BuildContext context,
    required bool isCorrect,
  }) async {
    try {
      final scope = await _resolveMetricsScope(context);

      if (scope != null) {
        if (!context.mounted) return;
        await context.read<PzMetricsProvider>().trackAnswerAttempt(
          isCorrect: isCorrect,
          parentUid: scope.parentUid,
          childUid: scope.childUid,
        );
      }
    } catch (e) {
      logger.e('Error tracking answer attempt: $e');
    }
  }

  // Track lesson answer
  static Future<void> trackLessonAnswer({
    required BuildContext context,
    required bool isCorrect,
    required String topicName,
  }) async {
    try {
      final scope = await _resolveMetricsScope(context);

      if (scope != null) {
        if (!context.mounted) return;
        await context.read<LessonProvider>().trackLessonAnswer(
          parentUid: scope.parentUid,
          childUid: scope.childUid,
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
      final scope = await _resolveMetricsScope(context);

      if (scope != null) {
        if (!context.mounted) return;
        await context.read<StoryProvider>().trackStoryAnswer(
          parentUid: scope.parentUid,
          childUid: scope.childUid,
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
