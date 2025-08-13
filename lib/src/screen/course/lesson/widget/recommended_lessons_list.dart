import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class RecommendedLessonsList extends StatelessWidget {
  const RecommendedLessonsList({super.key});

  @override
  Widget build(BuildContext context) {
    logger.d('Building RecommendedLessonsList widget');
    return Consumer2<RecommendedLessonProvider, LessonProvider>(
      builder: (context, recommendedProvider, lessonProvider, _) {
        final status = recommendedProvider.status;
        logger.d('RecommendedLessonsList status: $status');
        if (status == DataFetchStatus.loading) {
          return CustomLoader();
        }
        if (status == DataFetchStatus.error || lessonProvider.courses.isEmpty) {
          logger.e('Error fetching recommended lessons');
          return const SizedBox();
        }
        logger.d(
          'lessonProvider.courses count: \\${lessonProvider.courses.length}',
        );
        for (var i = 0; i < lessonProvider.courses.length; i++) {
          final course = lessonProvider.courses[i];
          logger.d('Course \\$i chapters: \\${course.courses.length}');
          for (var j = 0; j < course.courses.length; j++) {
            final chapter = course.courses[j];
            logger.d('  Chapter \\$j lessons: \\${chapter.lessons.length}');
          }
        }
        // Map RecommendedLessonModel to Lesson for display
        // Fix: lessonProvider.courses is a List<CourseModel>, each has .courses (List<Course>), each Course has .chapters (List<Course>), each chapter has .lessons (List<Lesson>)
        final allLessons =
            lessonProvider.courses
                .expand((courseModel) => courseModel.courses)
                .expand((course) => course.chapters)
                .expand((chapter) => chapter.lessons)
                .toList();
        logger.d('Total lessons available: \\${allLessons.length}');
        final recommendedLessons = recommendedProvider.recommendedLessons;
        logger.d(
          'Number of recommended lessons: \\${recommendedLessons.length}',
        );
        final recommendedLessonIds =
            recommendedLessons.map((r) => r.lessonId).toSet();
        logger.d(
          'Recommended lesson IDs: \\${recommendedLessonIds.join(', ')}',
        );
        final List<Lesson> recommendedLessonModels =
            allLessons
                .where(
                  (l) => recommendedLessonIds.contains(l.chapterId.toString()),
                )
                .toList();
        logger.d(
          'Filtered recommended lessons count: \\${recommendedLessonModels.length}--- l.chapterIds: \\${recommendedLessonModels.map((l) => l.chapterId).join(', ')}',
        );

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: recommendedLessonModels.length,
          separatorBuilder: (_, _) => Gaps.horizontalGapOf(16),
          itemBuilder: (context, i) {
            final lesson = recommendedLessonModels[i];
            final rec = recommendedLessons.firstWhere(
              (r) => r.lessonId == lesson.chapterId.toString(),
            );
            logger.d(
              'Building LessonCard for lessonId: \${lesson.chapterId}, title: \${lesson.lessonName}, progress: \${rec.progress}',
            );
            double? progressPercent;
            if (lesson.lessonContent.isNotEmpty) {
              // Clamp progress to content length to handle completed lessons properly
              final clampedProgress = rec.progress.clamp(
                0,
                lesson.lessonContent.length,
              );
              progressPercent = clampedProgress / lesson.lessonContent.length;
            }
            return SizedBox(
              width: AppCardResponsive.getCardWidth(context),
              // height: AppCardResponsive.getCardHeight(context),
              child: LessonCard(
                data: lesson,
                color: AppColors.lessonBgColor,
                isLocked: false,
                isCompleted: progressPercent != null && progressPercent >= 1.0,
                trailing:
                    progressPercent != null && progressPercent > 0
                        ? LinearProgressIndicator(
                          value: progressPercent,
                          backgroundColor: Colors.grey.shade300,
                          color: AppColors.kRed,
                          minHeight: 2.5,
                          borderRadius: BorderRadius.circular(10),
                        )
                        : null,
                onTap: () {
                  // Safety check for empty lesson content
                  if (lesson.lessonContent.isEmpty) {
                    logger.w(
                      'Lesson ${lesson.chapterId} has no content, cannot navigate',
                    );
                    return;
                  }

                  // Ensure initial index is within valid range
                  final maxIndex = lesson.lessonContent.length - 1;
                  int safeInitialIndex;

                  // If lesson is completed (progress >= content length), start from beginning
                  // Otherwise, use the progress as starting point but clamp to valid range
                  // Note: progress 0 means not started, progress 1 means first content item completed
                  if (rec.progress >= lesson.lessonContent.length) {
                    safeInitialIndex =
                        0; // Start from beginning for completed lessons
                    logger.d(
                      'Lesson ${lesson.chapterId} is completed, starting from beginning',
                    );
                  } else if (rec.progress == 0) {
                    safeInitialIndex = 0; // Start from beginning if not started
                  } else {
                    // Progress represents completed items, so current item is at progress index
                    safeInitialIndex = rec.progress.clamp(0, maxIndex);
                  }

                  logger.d(
                    'Navigating to lesson: ${lesson.chapterId}, content length: ${lesson.lessonContent.length}, progress: ${rec.progress}, safe index: $safeInitialIndex',
                  );

                  Utility.navigateMaterialRoute(
                    context,
                    LessonContentScreen(
                      lesson: lesson,
                      lessons: [lesson],
                      initialIndex: safeInitialIndex,
                      hasSound: true,
                      isFromRecommended: true,
                      nameNp: lessonProvider.courses
                          .expand((courseModel) => courseModel.courses)
                          .expand((course) => course.chapters)
                          .where((chapter) => chapter.lessons.contains(lesson))
                          .map((chapter) => chapter.nameNp)
                          .join(', '),
                      nameEn: lessonProvider.courses
                          .expand((courseModel) => courseModel.courses)
                          .expand((course) => course.chapters)
                          .where((chapter) => chapter.lessons.contains(lesson))
                          .map((chapter) => chapter.nameEn)
                          .join(', '),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
