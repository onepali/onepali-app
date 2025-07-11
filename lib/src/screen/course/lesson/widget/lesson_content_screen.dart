import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';

class LessonContentScreen extends StatefulWidget {
  final Lesson lesson;
  final List<Lesson> lessons;
  final int initialIndex;
  final bool hasSound;
  const LessonContentScreen({
    super.key,
    required this.lesson,
    required this.lessons,
    this.initialIndex = 0,
    this.hasSound = true,
  });

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  bool _showGoodRemark = false;

  @override
  void initState() {
    super.initState();

    // Start learning session for metrics tracking (safe for initState)
    MetricsTrackingHelper.startLearningSessionSafe(context);

    Misc.onLayoutRendered(() async {
      final audioProvider = context.read<LessonAudioProvider>();

      // Safety check: ensure lesson has content before proceeding
      if (widget.lesson.lessonContent.isEmpty) {
        logger.w(
          'Lesson ${widget.lesson.id} has no content, cannot initialize audio',
        );
        return;
      }

      // Clamp initial index to valid range
      final maxIndex = widget.lesson.lessonContent.length - 1;
      final safeIndex = widget.initialIndex.clamp(0, maxIndex);

      logger.d(
        'LessonContentScreen: initializing with index $safeIndex (requested: ${widget.initialIndex}, max: $maxIndex)',
      );

      audioProvider.resetIndex(safeIndex, widget.lesson.lessonContent.length);

      final content = widget.lesson.lessonContent[safeIndex];
      if (content.audio.isNotEmpty) {
        await audioProvider.playContentAudio(
          widget.lesson.lessonContent,
          audioSourceType: AudioSourceType.network,
        );
      }
    });
  }

  @override
  void dispose() {
    MetricsTrackingHelper.endLearningSessionSafe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<LessonAudioProvider>();

    // Safety check: ensure lesson has content and currentIndex is valid
    if (widget.lesson.lessonContent.isEmpty) {
      logger.w(
        'Lesson ${widget.lesson.id} has no content, showing empty state',
      );
      return Scaffold(
        backgroundColor: AppColors.kWhite,
        body: const Center(child: Text('No content available for this lesson')),
      );
    }

    // Clamp current index to valid range
    final maxIndex = widget.lesson.lessonContent.length - 1;
    final safeCurrentIndex = audioProvider.currentIndex.clamp(0, maxIndex);

    // If audioProvider has wrong index, reset it
    if (audioProvider.currentIndex != safeCurrentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        audioProvider.resetIndex(
          safeCurrentIndex,
          widget.lesson.lessonContent.length,
        );
      });
    }

    final content = widget.lesson.lessonContent[safeCurrentIndex];
    final isFirst = safeCurrentIndex == 0;
    final isLast = safeCurrentIndex == widget.lesson.lessonContent.length - 1;
    // Update totalLessonsCompleted in Firebase when last lesson is completed
    if (isLast && _showGoodRemark) {
      Future.microtask(() async {
        if (!context.mounted) return;
        final lessonProvider = context.read<LessonProvider>();
        await lessonProvider.incrementTotalLessonsCompleted();
      });
    }
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: SvgHelper.fromSource(
                  path: Assets.wrong,
                  height: 40,
                  width: 40,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isFirst)
                    Container(
                      height: 17.h(context),
                      width: 17.h(context),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kBlack.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.leftArrow,
                          height: 48,
                          width: 48,
                          color: AppColors.kSecondaryColor,
                        ),
                        onPressed:
                            audioProvider.isPlaying
                                ? null
                                : () async {
                                  audioProvider.navigateToPreviousContent(
                                    widget.lesson.lessonContent,
                                    context,
                                    widget.lesson,
                                  );
                                  final safeIndex = audioProvider.currentIndex
                                      .clamp(
                                        0,
                                        widget.lesson.lessonContent.length - 1,
                                      );
                                  final prevContent =
                                      widget.lesson.lessonContent[safeIndex];
                                  if (prevContent.audio.isNotEmpty) {
                                    await audioProvider.playContentAudio(
                                      widget.lesson.lessonContent,
                                      audioSourceType: AudioSourceType.network,
                                    );
                                  }
                                },
                      ),
                    ),
                  Expanded(
                    child: LessonContentCard(
                      content: content,
                      isPlaying: audioProvider.isPlaying,
                      hasSound: widget.hasSound,
                      onPlay: () async {
                        // Always play from start when tapped
                        await audioProvider.playContentAudio(
                          widget.lesson.lessonContent,
                          audioSourceType: AudioSourceType.network,
                          forceReplay: true,
                        );
                        if (!context.mounted) return;
                        final recommendedLessonProvider =
                            context.read<RecommendedLessonProvider>();
                        final prefs = SharedPreferencesService();
                        final childId =
                            await prefs.getStringPref(
                              AppConstants.childIdKey,
                            ) ??
                            '';
                        if (childId.isNotEmpty) {
                          await recommendedLessonProvider
                              .saveOrUpdateLessonProgress(
                                childId: childId,
                                lessonId: widget.lesson.chapterId.toString(),
                                progress: safeCurrentIndex + 1,
                                title: content.nameNp,
                                image: content.image,
                              );
                        }
                        if (safeCurrentIndex ==
                            widget.lesson.lessonContent.length - 1) {
                          setState(() {
                            _showGoodRemark = true;
                          });
                        }
                      },
                      index: safeCurrentIndex,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      height: 17.h(context),
                      width: 17.h(context),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kBlack.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.rightArrow,
                          height: 48,
                          width: 48,
                          color: AppColors.kSecondaryColor,
                        ),
                        onPressed:
                            audioProvider.isPlaying
                                ? null
                                : () async {
                                  audioProvider.navigateToNextContent(
                                    widget.lesson.lessonContent,
                                    context,
                                    widget.lesson,
                                  );
                                  final safeIndex = audioProvider.currentIndex
                                      .clamp(
                                        0,
                                        widget.lesson.lessonContent.length - 1,
                                      );
                                  final nextContent =
                                      widget.lesson.lessonContent[safeIndex];
                                  if (nextContent.audio.isNotEmpty) {
                                    await audioProvider.playContentAudio(
                                      widget.lesson.lessonContent,
                                      audioSourceType: AudioSourceType.network,
                                    );
                                  }
                                },
                      ),
                    ),
                ],
              ),
            ),
            // Show good remark image at last index only after audio played
            if (_showGoodRemark && isLast)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                bottom: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: 1.0,
                  child: CustomImage(
                    Assets.goodRemark,
                    height: 150,
                    width: 150,
                    imageType: CustomImageType.local,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
