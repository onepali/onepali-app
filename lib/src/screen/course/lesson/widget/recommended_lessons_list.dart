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
        // Map RecommendedLessonModel to Lesson for display
        final allLessons =
            lessonProvider.courses
                .expand((courseModel) => courseModel.courses)
                .expand((course) => course.chapters)
                .expand((chapter) => chapter.lessons)
                .toList();
        final recommendedLessons = recommendedProvider.recommendedLessons;
        final recommendedLessonIds =
            recommendedLessons.map((r) => r.lessonId).toSet();
        final List<Lesson> recommendedLessonModels =
            allLessons
                .where(
                  (l) => recommendedLessonIds.contains(l.chapterId.toString()),
                )
                .toList();
        return StatusHandler(
          status: recommendedProvider.status,
          hasData: recommendedLessonModels.isNotEmpty,
          errorTitle: 'No recommended lessons',
          errorMessage: 'Please check back later for new lessons.',
          checkConnectivity: false,
          onRetry: () {
            recommendedProvider.fetchRecommendedLessons();
          },
          successBuilder: () {
            // Use the same height calculation as regular cards
            final cardHeight = AppCardResponsive.getDashboardCardHeight(context);
            
            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
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
                    'Building LessonCard for lessonId: ${lesson.chapterId}, title: ${lesson.lessonName}, progress: ${rec.progress}',
                  );
                  double? progressPercent;
                  if (lesson.lessonContent.isNotEmpty) {
                    // Clamp progress to content length to handle completed lessons properly
                    final clampedProgress = rec.progress.clamp(
                      0,
                      lesson.lessonContent.length,
                    );
                    progressPercent =
                        clampedProgress / lesson.lessonContent.length;
                  }
                  return SizedBox(
                    width: AppCardResponsive.getCardWidth(context),
                    height: cardHeight,
                    child: LessonCard(
                    data: lesson,
                    color: AppColors.lessonBgColor,
                    isLocked: false,
                    isCompleted:
                        progressPercent != null && progressPercent >= 1.0,
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
                        safeInitialIndex =
                            0; // Start from beginning if not started
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
                              .where(
                                (chapter) => chapter.lessons.contains(lesson),
                              )
                              .map((chapter) => chapter.nameNp)
                              .join(', '),
                          nameEn: lessonProvider.courses
                              .expand((courseModel) => courseModel.courses)
                              .expand((course) => course.chapters)
                              .where(
                                (chapter) => chapter.lessons.contains(lesson),
                              )
                              .map((chapter) => chapter.nameEn)
                              .join(', '),
                        ),
                      );
                    },
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


class LessonCard1 extends StatelessWidget {
  final Lesson data;
  final Color? color;
  final bool isLocked;
  final bool isCompleted;
  final Widget? trailing;
  final VoidCallback? onTap;

  const LessonCard1({
    super.key,
    required this.data,
    this.color,
    this.isLocked = false,
    this.isCompleted = false,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.lessonBgColor;
    
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cardColor,
              cardColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles in background
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            
            // Main content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and status
                  Row(
                    children: [
                      // Lesson icon container
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          isLocked 
                              ? Icons.lock_rounded
                              : isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.play_circle_filled_rounded,
                          color: isLocked
                              ? Colors.grey.shade400
                              : isCompleted
                                  ? Colors.green.shade600
                                  : AppColors.kRed,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      // Status badge
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: Colors.green.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (isLocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            'Locked',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Lesson title
                  Text(
                    data.lessonName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey.shade600 : Colors.white,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Content count or subtitle
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.layers_rounded,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${data.lessonContent.length} items',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Progress indicator or call to action
                  if (trailing != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        trailing!,
                        const SizedBox(height: 4),
                      ],
                    )
                  else if (!isLocked && !isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Start Learning',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: cardColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: cardColor,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            // Locked overlay
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}