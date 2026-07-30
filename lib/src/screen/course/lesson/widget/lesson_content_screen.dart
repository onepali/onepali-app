import 'dart:async';

import 'dart:math' as math;

// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
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

  // Reorder tap-target questions so cat comes before rabbit
  // Other content types remain in their original positions
  List<LessonContent> get _reorderedContent {
    final original = widget.lesson.lessonContent;
    final reordered = <LessonContent>[];
    final catTapTargets = <LessonContent>[];
    final rabbitTapTargets = <LessonContent>[];
    final otherTapTargets = <LessonContent>[];

    // Process each content item
    for (final content in original) {
      if (content.type == 'tap_target') {
        // Only reorder tap_target type content
        if (content.correctAnswerId?.toLowerCase() == 'cat') {
          catTapTargets.add(content);
        } else if (content.correctAnswerId?.toLowerCase() == 'rabbit') {
          rabbitTapTargets.add(content);
        } else {
          otherTapTargets.add(content);
        }
      } else {
        // For non-tap_target content, maintain original order
        // We'll insert them back at their original positions
        reordered.add(content);
      }
    }

    // For tap-target questions: cat first, then rabbit, then other tap-targets
    // Insert them in the order they appear in the original list
    final tapTargetOrdered = <LessonContent>[];
    tapTargetOrdered.addAll(catTapTargets);
    tapTargetOrdered.addAll(rabbitTapTargets);
    tapTargetOrdered.addAll(otherTapTargets);

    // Now rebuild the list maintaining original positions for non-tap_target items
    final result = <LessonContent>[];
    int tapTargetIndex = 0;

    for (final content in original) {
      if (content.type == 'tap_target') {
        // Use reordered tap-target
        if (tapTargetIndex < tapTargetOrdered.length) {
          result.add(tapTargetOrdered[tapTargetIndex]);
          tapTargetIndex++;
        }
      } else {
        // Keep original position for non-tap_target
        result.add(content);
      }
    }

    logger.d(
      'Tap-target questions reordered: ${catTapTargets.length} cat, ${rabbitTapTargets.length} rabbit, ${otherTapTargets.length} other tap-targets',
    );
    return result;
  }

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
      _audioProvider = audioProvider;
      await _stopLessonAudio();
      audioProvider.resetAudioState();
      // Don't set the audioProvider index here, we'll handle it per content
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Store provider references for safe disposal
    // Note: Not used in this screen
    _audioProvider = context.read<LessonAudioProvider>();
    _recommendedLessonProvider = context.read<RecommendedLessonProvider>();
  }

  @override
  void dispose() {
    // Save current progress before leaving
    _saveCurrentProgress();

    // Clean up audio when leaving the screen
    unawaited(_stopLessonAudio());

    MetricsTrackingHelper.endLearningSessionSafe();
    super.dispose();
  }

  Future<void> _stopLessonAudio() async {
    await Future.wait([
      _audioProvider?.stopAudio() ?? Future<void>.value(),
      CustomAudioWidget.stopAll(),
    ], eagerError: false);
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

  Future<void> _nextContent() async {
    if (_currentContentIndex < widget.lesson.lessonContent.length) {
      await _stopLessonAudio();
      if (!mounted) return;
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
    await _stopLessonAudio();
    if (!mounted) return;
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

      // Track lesson completion for parent metrics (completedActivities & mostPracticedTopics)
      await MetricsTrackingHelper.trackLessonCompletion(
        context: context,
        lessonId: widget.lesson.id.toString(),
        topicName: widget.lesson.lessonName,
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

  Future<void> _previousContent() async {
    if (_currentContentIndex > 0) {
      await _stopLessonAudio();
      if (!mounted) return;
      setState(() {
        _currentContentIndex--;
      });
    }
  }

  /// Checks if current content has a background image
  bool _hasBackgroundImage(int idx, List<LessonContent> contentList) {
    if (idx > 0 && idx <= contentList.length) {
      final currentContent = contentList[idx - 1];
      final backgroundImage = currentContent.mbImage;
      return backgroundImage?.isNotEmpty ?? false;
    }
    return false;
  }

  /// Gets the background image path if available
  String? _getBackgroundImage(int idx, List<LessonContent> contentList) {
    if (idx > 0 && idx <= contentList.length) {
      return contentList[idx - 1].mbImage;
    }
    return null;
  }

  /// Builds the full-screen background image widget
  Widget _buildFullScreenBackground(String imagePath) {
    // Use cover to fill screen completely (may crop edges but no empty space)
    // Cover prevents horizontal stripes that appear with contain
    return Positioned.fill(
      child: SvgHelper.fromSource(
        path: imagePath,
        type: SvgSourceType.network,
        fit: BoxFit
            .cover, // Cover fills screen completely, may crop but no empty space
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  /// Builds action buttons (sound, close) for the lesson screen
  List<Widget> _buildActionButtons(
    BuildContext context,
    int idx,
    int contentListLength,
  ) {
    // Check if current content is tap-target or drag-to-match
    final currentContent = idx > 0 && idx <= widget.lesson.lessonContent.length
        ? widget.lesson.lessonContent[idx - 1]
        : null;
    final isAnimalLesson =
        currentContent?.type == 'tap_target' ||
        currentContent?.type == 'drag_to_match';
    final isDragToMatch = currentContent?.type == 'drag_to_match';

    return [
      // Show audio icon for all items in tap-target and drag-to-match, or for last item in other types
      if (widget.hasSound && (isAnimalLesson || contentListLength == idx))
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: CircularButtonWidget(
              type: CircularButtonType.sound,
              onPressed: isDragToMatch ? null : _playWordAudio,
            ),
          ),
        ),
      TopRightPositionedCloseButton(
        onTap: () async {
          await _stopLessonAudio();
          if (!mounted) return;
          _saveCurrentProgress();
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  /// Builds overlay widgets (good remark, etc.)
  List<Widget> _buildOverlayWidgets(
    BuildContext context,
    int idx,
    List<LessonContent> contentList,
  ) {
    if (_showGoodRemark &&
        idx > 0 &&
        idx <= contentList.length &&
        contentList[idx - 1].type != 'tap_send' &&
        contentList[idx - 1].type != 'tap_target' &&
        contentList[idx - 1].type != 'drag_to_match') {
      return [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          top: MediaQuery.of(context).size.height * 0.1,
          left: 0,
          right: 0,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
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
        ),
      ];
    }
    return [];
  }

  /// Builds the lesson intro screen
  Widget _buildLessonIntro(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final rightArrowWidth = availableWidth * 0.10;

        return Stack(
          children: [
            // Content (no background here - it's handled at the parent level)
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, innerConstraints) {
                  // Use percentages of full screen height for all content
                  final screenHeight = MediaQuery.of(context).size.height;
                  final availableHeight = innerConstraints.maxHeight;
                  final availableWidth = innerConstraints.maxWidth;

                  // Calculate fixed sizes as percentages of screen height - total must not exceed 100%
                  // Top padding: 5% of screen height
                  final topPadding = screenHeight * 0.05;

                  // Thumbnail: 50% of screen height
                  final thumbnailSize = screenHeight * 0.5;

                  // Gap 1: 2% of screen height
                  final gap1 = screenHeight * 0.02;

                  // Title font size: 8% of screen height (text will take ~10% with line height)
                  final titleFontSize = screenHeight * 0.08;
                  final titleHeight =
                      screenHeight * 0.10; // Reserve space for title

                  // Gap 2: 1.5% of screen height (tablet only)
                  final gap2 =
                      PlatformUtility.isTablet(context) &&
                          PlatformUtility.isLandscape(context)
                      ? screenHeight * 0.015
                      : 0.0;

                  // Description font size: 4% of screen height (text will take ~5% with line height)
                  final descFontSize = screenHeight * 0.04;
                  final descHeight = widget.nameEn.isNotEmpty
                      ? screenHeight * 0.05
                      : 0.0;

                  // Calculate total used space
                  final totalUsed =
                      topPadding +
                      thumbnailSize +
                      gap1 +
                      titleHeight +
                      gap2 +
                      descHeight;

                  // Ensure we don't exceed available height - adjust thumbnail if needed
                  final adjustedThumbnailSize = totalUsed > availableHeight
                      ? thumbnailSize - (totalUsed - availableHeight)
                      : thumbnailSize;

                  return SizedBox(
                    height: availableHeight,
                    width: availableWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: topPadding),
                        // Lesson thumbnail - fixed size
                        if (widget.lesson.thumbnail.isNotEmpty)
                          SizedBox(
                            width: adjustedThumbnailSize,
                            height: adjustedThumbnailSize,
                            child: CustomImage(
                              widget.lesson.thumbnail,
                              width: adjustedThumbnailSize,
                              height: adjustedThumbnailSize,
                              circular: false,
                              cover: false,
                              boxFit: BoxFit.contain,
                              imageType: CustomImageType.network,
                            ),
                          ),
                        SizedBox(height: gap1),
                        // Lesson title - fixed height
                        SizedBox(
                          height: titleHeight,
                          child: Center(
                            child: Text(
                              widget.nameNp,
                              style: AppStyles.text24PxBold.copyWith(
                                fontSize: titleFontSize,
                                fontFamily: AppConstants.kMuktaFont,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        if (PlatformUtility.isTablet(context) &&
                            PlatformUtility.isLandscape(context))
                          SizedBox(height: gap2),
                        // Lesson description - fixed height
                        if (widget.nameEn.isNotEmpty)
                          SizedBox(
                            height: descHeight,
                            child: Center(
                              child: Text(
                                widget.nameEn,
                                style: AppStyles.text16PxMedium.copyWith(
                                  color: AppColors.kBlack,
                                  fontSize: descFontSize,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Right arrow positioned to match following screens (10% from right edge)
            // Close button is handled by _buildActionButtons
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: rightArrowWidth,
                child: Center(
                  child: CircularButtonWidget(
                    type: CircularButtonType.rightArrow,
                    onPressed: () => unawaited(_nextContent()),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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

    // For individual animal screens, apply fixed percentage-based layout
    final isRegularContent =
        !isTapSendType && !isTapTargetType && !isDragToMatchType;
    if (isRegularContent && contentIndex >= 0) {
      // Use LayoutBuilder to get available width (accounts for SafeArea)
      return LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final padding =
              availableWidth *
              (0.05 /
                  3); // ~1.67% padding between sections to total exactly 100%
          final minArrowSlotWidth = Dimensions.iconSizeLarge;
          final arrowSlotWidth = availableWidth * 0.10 < minArrowSlotWidth
              ? minArrowSlotWidth
              : availableWidth * 0.10;
          final contentEdgeGap = padding < 24 ? 24.0 : padding;
          final contentAreaWidth = math.max(
            0.0,
            availableWidth -
                (arrowSlotWidth * 2) -
                (contentEdgeGap * 2) -
                padding,
          );
          final availableHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : MediaQuery.sizeOf(context).height;
          final preferredAnimationBoxWidth = contentAreaWidth * (0.40 / 0.75);
          final maxAnimationBoxWidthForHeight = availableHeight / 0.65625;
          final animationBoxWidth = math.min(
            preferredAnimationBoxWidth,
            maxAnimationBoxWidthForHeight,
          );
          final textAudioWidth = math.max(
            0.0,
            contentAreaWidth - animationBoxWidth,
          );

          return SizedBox(
            width: availableWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left arrow: fixed 10% width, centered like right arrow
                SizedBox(
                  width: arrowSlotWidth,
                  child: Center(
                    child: CircularButtonWidget(
                      type: CircularButtonType.leftArrow,
                      onPressed: () => unawaited(_previousContent()),
                    ),
                  ),
                ),
                SizedBox(width: contentEdgeGap),

                // Animation box: fixed 40% width, with constraints to prevent overflow
                SizedBox(
                  width: animationBoxWidth,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: animationBoxWidth),
                    child: LessonContentCard(
                      content: content,
                      isPlaying: false,
                      hasSound: widget.hasSound,
                      index: contentIndex,
                      showOnlyAnimation: true,
                      parentWidth: animationBoxWidth,
                    ),
                  ),
                ),
                SizedBox(width: contentEdgeGap),

                // Text and audio area: fixed 35% width
                SizedBox(
                  width: textAudioWidth,
                  child: LayoutBuilder(
                    builder: (context, textConstraints) {
                      // Use textConstraints.maxWidth (35% of available width) for relative sizing
                      final textAreaWidth = textConstraints.maxWidth;
                      // Maximum font sizes relative to text area width (will scale down if needed)
                      final maxNepaliFontSize =
                          textAreaWidth * 0.25; // ~25% of text area width (max)
                      final maxEnglishFontSize =
                          textAreaWidth * 0.10; // ~10% of text area width (max)
                      final horizontalPadding =
                          textAreaWidth * 0.02; // 2% horizontal padding
                      final verticalSpacing =
                          textAreaWidth * 0.03; // 3% vertical spacing

                      // Check if audio is currently playing
                      final audioProvider = context
                          .watch<LessonAudioProvider>();
                      final isPlaying = audioProvider.isPlaying;

                      // Ensure text fits within available width with proper constraints
                      final availableTextWidth =
                          textAreaWidth - (horizontalPadding * 2);

                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Nepali text (nameNp) - auto-scales to fit largest text
                              SizedBox(
                                width: availableTextWidth,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                  child: Text(
                                    (content.nameNp?.isNotEmpty == true)
                                        ? content.nameNp!
                                        : 'चरा',
                                    style: AppStyles.text32PxBold.copyWith(
                                      color: AppColors.kDrawerBgColor,
                                      fontSize: maxNepaliFontSize,
                                      fontFamily: AppConstants.kMuktaFont,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // English text (nameEn) - auto-scales to fit largest text
                              SizedBox(height: verticalSpacing),
                              SizedBox(
                                width: availableTextWidth,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                  child: Text(
                                    (content.nameEn?.isNotEmpty == true)
                                        ? content.nameEn!
                                        : 'Bird',
                                    style: AppStyles.text20PxMedium.copyWith(
                                      fontSize: maxEnglishFontSize,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // Audio button
                              if (widget.hasSound &&
                                  content.wordAudio?.isNotEmpty == true) ...[
                                SizedBox(height: verticalSpacing),
                                SizedBox.square(
                                  dimension:
                                      Dimensions.kIconSize(context) * 1.4,
                                  child: Center(
                                    child: CustomAvatarGlow(
                                      glowColor: AppColors.kSecondaryColor,
                                      glowShape: BoxShape.circle,
                                      visible: isPlaying,
                                      glowRadiusFactor: 0.2,
                                      child: CircularButtonWidget(
                                        type: CircularButtonType.sound,
                                        onPressed: () async {
                                          try {
                                            final audioProvider = context
                                                .read<LessonAudioProvider>();
                                            await audioProvider.playWordAudio(
                                              content.wordAudio ?? '',
                                            );
                                          } catch (e) {
                                            logger.e(
                                              'Error playing word audio: $e',
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: padding),

                // Right arrow: fixed 10% width (or empty space if last item)
                if (!isLast)
                  SizedBox(
                    width: arrowSlotWidth,
                    child: Center(
                      child: CircularButtonWidget(
                        type: CircularButtonType.rightArrow,
                        onPressed: () => unawaited(_nextContent()),
                      ),
                    ),
                  )
                else
                  SizedBox(width: arrowSlotWidth),
              ],
            ),
          );
        },
      );
    }

    // For quiz (tap_send), drag_to_match, tap_target, and regular lessons (intro),
    // use the original full-width layout
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
            Padding(
              padding: EdgeInsets.only(left: Dimensions.kIconMargin(context)),
              child: CircularButtonWidget(
                type: CircularButtonType.leftArrow,
                onPressed: () => unawaited(_previousContent()),
              ),
            ),

          // Main content
          Expanded(
            child: isTapSendType
                ? TapSendLessonCard(
                    content: content,
                    isPlaying: false,
                    isLastItem: isLast,
                    onCorrectAnswer: () {
                      unawaited(_nextContent());
                    },
                    onLessonComplete: () async {
                      await _audioProvider?.stopAudio();
                      if (!mounted) return;
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

                        // Track lesson completion for parent metrics (completedActivities & mostPracticedTopics)
                        await MetricsTrackingHelper.trackLessonCompletion(
                          context: context,
                          lessonId: widget.lesson.id.toString(),
                          topicName: widget.lesson.lessonName,
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
                      unawaited(_nextContent());
                    },
                    onLessonComplete: () async {
                      await _audioProvider?.stopAudio();
                      if (!mounted) return;
                      await _saveProgress(content, contentIndex);
                      // For tap_target lessons, handle completion
                      try {
                        final lessonProvider = context.read<LessonProvider>();
                        await lessonProvider.incrementTotalLessonsCompleted(
                          context,
                          widget.lesson.id,
                          widget.lesson.lessonName,
                        );

                        // Track lesson completion for parent metrics (completedActivities & mostPracticedTopics)
                        await MetricsTrackingHelper.trackLessonCompletion(
                          context: context,
                          lessonId: widget.lesson.id.toString(),
                          topicName: widget.lesson.lessonName,
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
                      unawaited(_nextContent());
                    },
                    onLessonComplete: () async {
                      await _audioProvider?.stopAudio();
                      if (!mounted) return;
                      logger.d(
                        'DragToMatchLessonCard onLessonComplete callback started',
                      );
                      await _saveProgress(content, contentIndex);
                      // For drag_to_match lessons, handle completion
                      try {
                        logger.d(
                          'Calling incrementTotalLessonsCompleted for lesson: ${widget.lesson.id}',
                        );
                        final lessonProvider = context.read<LessonProvider>();
                        await lessonProvider.incrementTotalLessonsCompleted(
                          context,
                          widget.lesson.id,
                          widget.lesson.lessonName,
                        );

                        logger.d(
                          'Calling MetricsTrackingHelper.trackLessonCompletion for lesson: ${widget.lesson.id}',
                        );
                        // Track lesson completion for parent metrics (completedActivities & mostPracticedTopics)
                        await MetricsTrackingHelper.trackLessonCompletion(
                          context: context,
                          lessonId: widget.lesson.id.toString(),
                          topicName: widget.lesson.lessonName,
                        );
                        logger.d(
                          'MetricsTrackingHelper.trackLessonCompletion completed for lesson: ${widget.lesson.id}',
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
            Padding(
              padding: EdgeInsets.only(right: Dimensions.kIconMargin(context)),
              child: CircularButtonWidget(
                type: CircularButtonType.rightArrow,
                onPressed: () => unawaited(_nextContent()),
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

    final contentList =
        _reorderedContent; // Use reordered content (cat before rabbit)
    final idx = _currentContentIndex;

    logger.d(
      'LessonContentScreen: total: ${contentList.length}, current: $idx, remaining: ${contentList.length - idx}',
    );
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, value) {
        if (didPop) {
          logger.d('PopScope: onPopInvoked called');
          unawaited(_stopLessonAudio());
          _saveCurrentProgress();
        }
      },
      child: Builder(
        builder: (context) {
          final contentList =
              _reorderedContent; // Use reordered content (cat before rabbit)
          final idx = _currentContentIndex;
          final hasBackgroundImage = _hasBackgroundImage(idx, contentList);
          final backgroundImage = _getBackgroundImage(idx, contentList);

          // Build main content widget
          final mainContent = idx == 0
              ? _buildLessonIntro(context)
              : idx > 0 && idx <= contentList.length
              ? _buildLessonContent(contentList[idx - 1], idx - 1)
              : const SizedBox();

          // Build action buttons
          final actionButtons = _buildActionButtons(
            context,
            idx,
            contentList.length,
          );

          // Build content with overlay widgets (good remark, etc.)
          final overlayWidgets = _buildOverlayWidgets(
            context,
            idx,
            contentList,
          );

          // If there's a background image, it should cover the whole screen
          if (hasBackgroundImage && backgroundImage != null) {
            // Check if this is tap-target or drag-to-match (animals need full screen)
            final currentContent = idx > 0 && idx <= contentList.length
                ? contentList[idx - 1]
                : null;
            final isAnimalLesson =
                currentContent?.type == 'tap_target' ||
                currentContent?.type == 'drag_to_match';

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox.expand(
                child: Stack(
                  children: [
                    // Background image extends to full screen (behind SafeArea)
                    _buildFullScreenBackground(backgroundImage),
                    // Animal content (tap-target, drag-to-match) outside SafeArea for full screen
                    if (isAnimalLesson) mainContent,
                    // Content with SafeArea for interactive elements
                    SafeArea(
                      right: false,
                      child: Stack(
                        children: [
                          ...actionButtons,
                          if (!isAnimalLesson) mainContent,
                          ...overlayWidgets,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // For lessons without background image, use Positioned.fill pattern to cover full screen
          // If intro screen, use lessonBgColor; otherwise use white
          final backgroundColor = idx == 0
              ? AppColors.lessonBgColor
              : AppColors.kWhite;

          // Check if this is tap-target or drag-to-match (animals need full screen)
          final currentContent = idx > 0 && idx <= contentList.length
              ? contentList[idx - 1]
              : null;
          final isAnimalLesson =
              currentContent?.type == 'tap_target' ||
              currentContent?.type == 'drag_to_match';

          return Scaffold(
            backgroundColor: backgroundColor,
            body: SizedBox.expand(
              child: Stack(
                children: [
                  // Background color extends to full screen (behind SafeArea)
                  Positioned.fill(child: Container(color: backgroundColor)),
                  // Animal content (tap-target, drag-to-match) outside SafeArea for full screen
                  if (isAnimalLesson) mainContent,
                  // Content with SafeArea for interactive elements
                  SafeArea(
                    right: false,
                    child: Stack(
                      children: [
                        ...actionButtons,
                        if (!isAnimalLesson) mainContent,
                        ...overlayWidgets,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
