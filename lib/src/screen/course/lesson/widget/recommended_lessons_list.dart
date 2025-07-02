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
          return const Center(child: CircularProgressIndicator());
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
                .where((l) => recommendedLessonIds.contains(l.id))
                .toList();
        logger.d(
          'Filtered recommended lessons count: \\${recommendedLessonModels.length}--- l.ids: \\${recommendedLessonModels.map((l) => l.id).join(', ')}',
        );

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: recommendedLessonModels.length,
          separatorBuilder: (_, _) => Gaps.horizontalGapOf(16),
          itemBuilder: (context, i) {
            final lesson = recommendedLessonModels[i];
            final rec = recommendedLessons.firstWhere(
              (r) => r.lessonId == lesson.id,
            );
            logger.d(
              'Building LessonCard for lessonId: \${lesson.id}, title: \${lesson.lessonName}, progress: \${rec.progress}',
            );
            double? progressPercent;
            if (lesson.lessonContent.isNotEmpty) {
              progressPercent = rec.progress / lesson.lessonContent.length;
            }
            return SizedBox(
              width: AppCardResponsive.getCardWidth(context),
              // height: AppCardResponsive.getCardHeight(context),
              child: LessonCard(
                data: lesson,
                color: Colors.teal[200]!,
                isLocked: false,
                isCompleted: progressPercent != null && progressPercent >= 1.0,
                trailing:
                    progressPercent != null && progressPercent > 0
                        ? LinearProgressIndicator(
                          value: progressPercent,
                          backgroundColor: Colors.grey.shade300,
                          color: AppColors.kOrange,
                          minHeight: 2.5,
                          borderRadius: BorderRadius.circular(10),
                        )
                        : null,
                onTap: () {
                  Utility.navigateMaterialRoute(
                    context,
                    LessonContentScreen(
                      lesson: lesson,
                      lessons: [lesson],
                      initialIndex: rec.progress,
                      hasSound: true,
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
