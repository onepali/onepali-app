import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';
import 'tap_send_lesson_card.dart';

class LessonContentScreen extends StatefulWidget {
  final Lesson lesson;
  final List<Lesson> lessons;
  final int initialIndex;
  final bool hasSound;
  final String nameNp;
  final String nameEn;
  final bool isFromRecommended;
  const LessonContentScreen({
    super.key,
    required this.lesson,
    required this.lessons,
    this.initialIndex = 0,
    this.hasSound = true,
    required this.nameNp,
    required this.nameEn,
    this.isFromRecommended = false,
  });

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  bool _showGoodRemark = false;
  int _currentContentIndex = 0; // Start with intro screen

  @override
  void initState() {
    super.initState();

    // Set initial content index based on whether coming from recommended lessons
    if (widget.isFromRecommended) {
      // For recommended lessons, use the provided initialIndex + 1 to account for intro screen
      _currentContentIndex = widget.initialIndex + 1;
      logger.d(
        'Recommended lesson: setting initial index to $_currentContentIndex (content index: ${widget.initialIndex})',
      );
    } else {
      // For regular lessons, start with intro screen (index 0)
      _currentContentIndex = 0;
      logger.d('Regular lesson: starting with intro screen (index 0)');
    }

    // Start learning session for metrics tracking (safe for initState)
    MetricsTrackingHelper.startLearningSessionSafe(context);

    Misc.onLayoutRendered(() async {
      context.read<UserProvider>().fetchOwnProfile();
      final audioProvider = context.read<LessonAudioProvider>();

      // Safety check: ensure lesson has content before proceeding
      if (widget.lesson.lessonContent.isEmpty) {
        logger.w(
          'Lesson ${widget.lesson.id} has no content, cannot initialize audio',
        );
        return;
      }

      // Reset audio state first to ensure clean start
      audioProvider.resetAudioState();
      // Don't set the audioProvider index here, we'll handle it per content
    });
  }

  @override
  void dispose() {
    // Save current progress before leaving
    _saveCurrentProgress();

    // Clean up audio when leaving the screen
    final audioProvider = context.read<LessonAudioProvider>();
    audioProvider.stopAudio();

    MetricsTrackingHelper.endLearningSessionSafe();
    super.dispose();
  }

  void _saveCurrentProgress() {
    logger.d('_saveCurrentProgress called');
    logger.d('widget.isFromRecommended: ${widget.isFromRecommended}');
    logger.d('_currentContentIndex: $_currentContentIndex');
    logger.d(
      'lesson.lessonContent.length: ${widget.lesson.lessonContent.length}',
    );

    // Save progress when user exits the lesson
    // Remove the isFromRecommended restriction - save progress for any lesson with content
    if (_currentContentIndex > 0 &&
        _currentContentIndex <= widget.lesson.lessonContent.length &&
        widget.lesson.lessonContent.isNotEmpty) {
      final contentIndex = _currentContentIndex - 1; // Convert to 0-based index
      final content = widget.lesson.lessonContent[contentIndex];
      logger.d(
        'Saving current progress: contentIndex=$contentIndex, lessonId=${widget.lesson.chapterId}',
      );
      _saveProgress(content, contentIndex);
    } else {
      logger.d('Progress not saved - conditions not met:');
      logger.d('  currentIndex > 0: ${_currentContentIndex > 0}');
      logger.d(
        '  currentIndex <= length: ${_currentContentIndex <= widget.lesson.lessonContent.length}',
      );
      logger.d(
        '  has lesson content: ${widget.lesson.lessonContent.isNotEmpty}',
      );
    }
  }

  void _nextContent() {
    if (_currentContentIndex < widget.lesson.lessonContent.length) {
      setState(() {
        _currentContentIndex++;
      });

      // Save progress after advancing (for any lesson with content)
      if (_currentContentIndex > 1 && widget.lesson.lessonContent.isNotEmpty) {
        final contentIndex =
            _currentContentIndex - 2; // Previous content index (0-based)
        if (contentIndex >= 0 &&
            contentIndex < widget.lesson.lessonContent.length) {
          final content = widget.lesson.lessonContent[contentIndex];
          logger.d(
            'Auto-saving progress after advancing to next content: contentIndex=$contentIndex',
          );
          _saveProgress(content, contentIndex);
        }
      }
    }
  }

  void _previousContent() {
    if (_currentContentIndex > 0) {
      setState(() {
        _currentContentIndex--;
      });
    }
  }

  Widget _buildLessonContent(LessonContent content, int contentIndex) {
    final isFirst = contentIndex == 0;
    final isLast = contentIndex == widget.lesson.lessonContent.length - 1;
    final isTapSendType = content.type == 'tap_send';

    // Save progress when content is viewed (for any lesson with content)
    Misc.onLayoutRendered(() {
      _saveProgress(content, contentIndex);
    });

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Previous button
          if (!isFirst && !isTapSendType)
            Container(
              height: 48,
              width: 48,
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
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: IconButton(
                icon: SvgHelper.fromSource(
                  path: Assets.leftArrow,
                  height: 30,
                  width: 30,
                  color: AppColors.kSecondaryColor,
                ),
                onPressed: _previousContent,
              ),
            ),

          // Main content
          Expanded(
            child:
                isTapSendType
                    ? TapSendLessonCard(
                      content: content,
                      isPlaying: false,
                      isLastItem: isLast,
                      onCorrectAnswer: () {
                        _nextContent();
                      },
                      onLessonComplete: () async {
                        await _saveProgress(content, contentIndex);
                        await _completeLessonAndShowReward();
                      },
                      index: contentIndex,
                    )
                    : LessonContentCard(
                      content: content,
                      isPlaying: false,
                      hasSound: widget.hasSound,
                      index: contentIndex,
                    ),
          ),

          // Next button
          if (!isLast && !isTapSendType)
            Container(
              height: 48,
              width: 48,
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
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: IconButton(
                icon: SvgHelper.fromSource(
                  path: Assets.rightArrow,
                  height: 30,
                  width: 30,
                  color: AppColors.kSecondaryColor,
                ),
                onPressed: _nextContent,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _saveProgress(LessonContent content, int contentIndex) async {
    try {
      final recommendedLessonProvider =
          context.read<RecommendedLessonProvider>();
      final childId = await ChildLocalStorage.getCurrentChildId();

      if (childId!.isNotEmpty) {
        await recommendedLessonProvider.saveOrUpdateLessonProgress(
          childId: childId,
          lessonId: widget.lesson.chapterId.toString(),
          progress: contentIndex + 1,
          title: content.nameNp,
          image: content.image,
        );
        logger.d(
          'Progress saved: lessonId=${widget.lesson.chapterId}, progress=${contentIndex + 1}',
        );
      }
    } catch (e) {
      logger.e('Error saving progress: $e');
    }
  }

  Future<void> _completeLessonAndShowReward() async {
    // Mark lesson as completed
    setState(() {
      _showGoodRemark = true;
    });

    try {
      final lessonProvider = context.read<LessonProvider>();
      await lessonProvider.incrementTotalLessonsCompleted(
        context,
        widget.lesson.id,
        widget.lesson.lessonName,
      );
    } catch (e) {
      logger.e('Error completing lesson: $e');
    }

    // Auto-hide after delay and close lesson
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Safety check: ensure lesson has content
    if (widget.lesson.lessonContent.isEmpty) {
      logger.w(
        'Lesson ${widget.lesson.id} has no content, showing empty state',
      );
      return Scaffold(
        backgroundColor: AppColors.kWhite,
        body: const Center(child: Text('No content available for this lesson')),
      );
    }

    final contentList = widget.lesson.lessonContent;
    final idx = _currentContentIndex;

    logger.d(
      'LessonContentScreen: total: ${contentList.length}, current: $idx, remaining: ${contentList.length - idx}',
    );

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, value) {
        if (didPop) {
          logger.d('PopScope: onPopInvoked called');
          _saveCurrentProgress();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.kWhite,
        body: SafeArea(
          child: Stack(
            children: [
              // Close button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: SvgHelper.fromSource(
                    path: Assets.wrong,
                    height: 48,
                    width: 48,
                  ),
                  onPressed: () {
                    _saveCurrentProgress();
                    Navigator.of(context).pop();
                  },
                ),
              ),

              // Main content
              if (idx == 0)
                // Show lesson intro (similar to story intro)
                Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.lessonBgColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Lesson thumbnail
                            if (widget.lesson.thumbnail.isNotEmpty)
                              CustomImage(
                                widget.lesson.thumbnail,
                                width: 180,
                                height: 180,
                                circular: false,
                                cover: false,
                                boxFit: BoxFit.contain,
                                imageType: CustomImageType.network,
                              ),
                            Gaps.verticalGapOf(10),
                            // Lesson title
                            Text(
                              widget.nameNp,
                              style: AppStyles.text24PxBold.copyWith(
                                // color: AppColors.kSecondaryColor,
                                fontSize: 30,
                                fontFamily: 'Mukta',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Gaps.verticalGapOf(16),
                            // Lesson description
                            if (widget.nameEn.isNotEmpty)
                              Text(
                                widget.nameEn,
                                style: AppStyles.text16PxMedium.copyWith(
                                  color: AppColors.kBlack,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.wrong,
                          height: 48,
                          width: 48,
                        ),
                        onPressed: () {
                          _saveCurrentProgress();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    // Start button
                    Positioned(
                      right: 25,
                      top: 0,
                      bottom: 0,
                      child: customInkwell(
                        onTap: _nextContent,
                        child: Container(
                          height: 48,
                          width: 48,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            // vertical: 2,
                          ),
                          child: SvgHelper.fromSource(
                            path: Assets.rightArrow,
                            // height: 30,
                            // width: 30,
                            color: AppColors.kSecondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else if (idx > 0 && idx <= contentList.length)
                // Show lesson content
                _buildLessonContent(contentList[idx - 1], idx - 1),

              // Show good remark at the end
              if (_showGoodRemark)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CustomImage(
                      Assets.goodRemark,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
