// import 'dart:math';

// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';
import 'tap_send_lesson_card.dart';
import 'tap_target_lesson_card.dart';
import 'drag_to_match_lesson_card.dart';

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

  // Store provider references for safe disposal
  LessonAudioProvider? _audioProvider;
  RecommendedLessonProvider? _recommendedLessonProvider;

  @override
  void initState() {
    super.initState();

    // Set initial content index based on whether coming from recommended lessons
    if (widget.isFromRecommended) {
      // For recommended lessons, if initialIndex is 0 (not started), show intro screen
      // Otherwise, use the provided initialIndex + 1 to account for intro screen
      if (widget.initialIndex == 0) {
        _currentContentIndex = 0; // Show intro screen for unstarted lessons
        logger.d(
          'Recommended lesson: not started, showing intro screen (index 0)',
        );
      } else {
        _currentContentIndex = widget.initialIndex + 1;
        logger.d(
          'Recommended lesson: setting initial index to $_currentContentIndex (content index: ${widget.initialIndex})',
        );
      }
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Store provider references for safe disposal
    _audioProvider = context.read<LessonAudioProvider>();
    _recommendedLessonProvider = context.read<RecommendedLessonProvider>();
  }

  @override
  void dispose() {
    // Save current progress before leaving
    _saveCurrentProgress();

    // Clean up audio when leaving the screen
    _audioProvider?.stopAudio();

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

      if (_currentContentIndex >= widget.lesson.lessonContent.length) {
        final lastContent = widget.lesson.lessonContent.last;
        if (lastContent.type != 'tap_send' &&
            lastContent.type != 'tap_target' &&
            lastContent.type != 'drag_to_match') {
          _completeRegularLesson();
        }
      }
    }
  }

  Future<void> _completeRegularLesson() async {
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

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
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
    final isTapTargetType = content.type == 'tap_target';
    final isDragToMatchType = content.type == 'drag_to_match';

    // Save progress when content is viewed (for any lesson with content)
    Misc.onLayoutRendered(() {
      _saveProgress(content, contentIndex);
    });

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Previous button - show on first content item to go back to intro, or on other items (except special types)
          if ((isFirst || !isFirst) &&
              !isTapSendType &&
              !isTapTargetType &&
              !isDragToMatchType)
            Container(
              height:
                  PlatformUtility.isTablet(context) &&
                          PlatformUtility.isLandscape(context)
                      ? AppConstants.kIconSize + AppConstants.kIconSize
                      : AppConstants.kIconSize,
              width:
                  PlatformUtility.isTablet(context) &&
                          PlatformUtility.isLandscape(context)
                      ? AppConstants.kIconSize + AppConstants.kIconSize
                      : AppConstants.kIconSize,
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
                  height:
                      PlatformUtility.isTablet(context) &&
                              PlatformUtility.isLandscape(context)
                          ? 80
                          : AppConstants.kIconSize,
                  width: AppConstants.kIconSize,
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
                        // For tap_send lessons, don't trigger the main lesson completion
                        // as TapSendLessonCard handles its own animation
                        // Just save progress and close after a delay
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

                        // Close lesson after TapSendLessonCard animation
                        Future.delayed(const Duration(seconds: 3), () {
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      index: contentIndex,
                    )
                    : isTapTargetType
                    ? TapTargetLessonCard(
                      content: content,
                      isPlaying: false,
                      isLastItem: isLast,
                      onCorrectAnswer: () {
                        _nextContent();
                      },
                      onLessonComplete: () async {
                        await _saveProgress(content, contentIndex);
                        // For tap_target lessons, handle completion
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

                        // Close lesson after TapTargetLessonCard animation
                        Future.delayed(const Duration(seconds: 3), () {
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      index: contentIndex,
                    )
                    : isDragToMatchType
                    ? DragToMatchLessonCard(
                      content: content,
                      isPlaying: false,
                      isLastItem: isLast,
                      onCorrectAnswer: () {
                        _nextContent();
                      },
                      onLessonComplete: () async {
                        await _saveProgress(content, contentIndex);
                        // For drag_to_match lessons, handle completion
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

                        // Close lesson after DragToMatchLessonCard animation
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        });
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
          if (!isLast && !isTapSendType && !isTapTargetType)
            Container(
              height:
                  PlatformUtility.isTablet(context) &&
                          PlatformUtility.isLandscape(context)
                      ? AppConstants.kIconSize + AppConstants.kIconSize
                      : AppConstants.kIconSize,
              width:
                  PlatformUtility.isTablet(context) &&
                          PlatformUtility.isLandscape(context)
                      ? AppConstants.kIconSize + AppConstants.kIconSize
                      : AppConstants.kIconSize,
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
                  height:
                      PlatformUtility.isTablet(context) &&
                              PlatformUtility.isLandscape(context)
                          ? 80
                          : AppConstants.kIconSize,
                  width:
                      PlatformUtility.isTablet(context) &&
                              PlatformUtility.isLandscape(context)
                          ? 80
                          : AppConstants.kIconSize,
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
      // Use stored provider reference instead of context.read
      final recommendedLessonProvider = _recommendedLessonProvider;
      if (recommendedLessonProvider == null) {
        logger.w(
          'RecommendedLessonProvider not available, skipping progress save',
        );
        return;
      }

      final childId = await ChildLocalStorage.getCurrentChildId();

      if (childId!.isNotEmpty) {
        // Handle image field that can be either String or List
        String imageUrl = "";
        if (content.image is String) {
          imageUrl = content.image as String;
        } else if (content.image is List &&
            (content.image as List).isNotEmpty) {
          imageUrl = (content.image as List).first.toString();
        }

        await recommendedLessonProvider.saveOrUpdateLessonProgress(
          childId: childId,
          lessonId: widget.lesson.chapterId.toString(),
          progress: contentIndex + 1,
          title: content.nameNp ?? "",
          image: imageUrl,
        );
        logger.d(
          'Progress saved: lessonId=${widget.lesson.chapterId}, progress=${contentIndex + 1}',
        );
      }
    } catch (e, s) {
      logger.e('Error saving progress: $e');
      logger.e('Stack trace: $s');
    }
  }

  void _playWordAudio() async {
    try {
      if (_currentContentIndex > 0 &&
          _currentContentIndex <= widget.lesson.lessonContent.length) {
        final currentContent =
            widget.lesson.lessonContent[_currentContentIndex - 1];
        if (currentContent.wordAudio?.isNotEmpty == true) {
          final audioProvider = context.read<LessonAudioProvider>();
          await audioProvider.playWordAudio(currentContent.wordAudio ?? '');
        }
      }
    } catch (e) {
      logger.e('Error playing word audio: $e');
    }
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
              if (widget.hasSound && contentList.length == idx)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: IconButton(
                      icon: SvgHelper.fromSource(
                        path: Assets.sound,
                        height: AppConstants.kIconSize,
                        width: AppConstants.kIconSize,
                      ),
                      onPressed: () {
                        _playWordAudio();
                      },
                    ),
                  ),
                ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: SvgHelper.fromSource(
                    path: Assets.wrong,
                    height:
                        PlatformUtility.isTablet(context) &&
                                PlatformUtility.isLandscape(context)
                            ? AppConstants.kIconSize + AppConstants.kIconSize
                            : AppConstants.kIconSize,
                    width:
                        PlatformUtility.isTablet(context) &&
                                PlatformUtility.isLandscape(context)
                            ? AppConstants.kIconSize + AppConstants.kIconSize
                            : AppConstants.kIconSize,
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
                                width:
                                    PlatformUtility.isTablet(context) &&
                                            PlatformUtility.isLandscape(context)
                                        ? 300
                                        : 180,
                                height:
                                    PlatformUtility.isTablet(context) &&
                                            PlatformUtility.isLandscape(context)
                                        ? 300
                                        : 180,
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
                                fontSize:
                                    PlatformUtility.isTablet(context) &&
                                            PlatformUtility.isLandscape(context)
                                        ? 64
                                        : 40,
                                fontFamily: AppConstants.kMuktaFont,
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
                                  fontSize:
                                      PlatformUtility.isTablet(context) &&
                                              PlatformUtility.isLandscape(
                                                context,
                                              )
                                          ? 32
                                          : 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 16,
                      right: 24,
                      child: IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.wrong,
                          height:
                              PlatformUtility.isTablet(context) &&
                                      PlatformUtility.isLandscape(context)
                                  ? AppConstants.kIconSize +
                                      AppConstants.kIconSize
                                  : AppConstants.kIconSize,
                          width:
                              PlatformUtility.isTablet(context) &&
                                      PlatformUtility.isLandscape(context)
                                  ? AppConstants.kIconSize +
                                      AppConstants.kIconSize
                                  : AppConstants.kIconSize,
                        ),
                        onPressed: () {
                          _saveCurrentProgress();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    // Start button
                    Positioned(
                      right: 16,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        height:
                            PlatformUtility.isTablet(context) &&
                                    PlatformUtility.isLandscape(context)
                                ? AppConstants.kIconSize +
                                    AppConstants.kIconSize
                                : AppConstants.kIconSize,
                        width:
                            PlatformUtility.isTablet(context) &&
                                    PlatformUtility.isLandscape(context)
                                ? AppConstants.kIconSize +
                                    AppConstants.kIconSize
                                : AppConstants.kIconSize,
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
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: IconButton(
                          icon: SvgHelper.fromSource(
                            path: Assets.rightArrow,
                            height:
                                PlatformUtility.isTablet(context) &&
                                        PlatformUtility.isLandscape(context)
                                    ? 80
                                    : AppConstants.kIconSize,
                            width:
                                PlatformUtility.isTablet(context) &&
                                        PlatformUtility.isLandscape(context)
                                    ? 80
                                    : AppConstants.kIconSize,
                            color: AppColors.kSecondaryColor,
                          ),
                          onPressed: _nextContent,
                        ),
                      ),
                    ),
                  ],
                )
              else if (idx > 0 && idx <= contentList.length)
                // Show lesson content
                _buildLessonContent(contentList[idx - 1], idx - 1),

              // Show good remark at the end (only for non-tap_send lessons)
              if (_showGoodRemark &&
                  idx > 0 &&
                  idx <= contentList.length &&
                  contentList[idx - 1].type != 'tap_send' &&
                  contentList[idx - 1].type != 'tap_target' &&
                  contentList[idx - 1].type != 'drag_to_match')
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kWhite.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kBlack.withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomImage(
                            Assets.goodRemark,
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.4,
                            imageType: CustomImageType.local,
                          ),
                          Gaps.verticalGapOf(16),
                          Text(
                            'Excellent Work!',
                            style: AppStyles.text24PxBold.copyWith(
                              color: AppColors.kButtonGreen,
                            ),
                          ),
                          Gaps.verticalGapOf(8),
                          Text(
                            'Lesson Completed Successfully',
                            style: AppStyles.text16PxMedium.copyWith(
                              color: AppColors.kSecondaryColor,
                            ),
                          ),
                        ],
                      ),
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
