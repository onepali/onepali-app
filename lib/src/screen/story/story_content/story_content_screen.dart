import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class StoryContentScreen extends StatefulWidget {
  final StoryModel story;
  final bool isFromRecommended;
  const StoryContentScreen({
    super.key,
    required this.story,
    this.isFromRecommended = false,
  });

  @override
  State<StoryContentScreen> createState() => _StoryContentScreenState();
}

class _StoryContentScreenState extends State<StoryContentScreen> {
  StoryProvider? _storyProvider;
  CustomAudioWidget? _storyAudio;

  @override
  void initState() {
    super.initState();

    // Start learning session for metrics tracking (safe for initState)
    MetricsTrackingHelper.startLearningSessionSafe(context);

    Misc.onLayoutRendered(() async {
      final authState = context.read<AuthState>();
      final childId = await ChildLocalStorage.getCurrentChildId();
      if (childId != null && childId.isNotEmpty) {
        authState.setCurrentChildId(childId);
      }
      if (!mounted) return;

      // Store provider reference for safe dispose usage
      _storyProvider = context.read<StoryProvider>();

      // Only restore progress for recommended stories
      int? savedProgress;
      if (widget.isFromRecommended) {
        // Fetch recommended stories to get saved progress
        await _storyProvider!.fetchRecommendedStoriesForActiveChild(context);

        // Get saved progress for this story
        if (childId != null && childId.isNotEmpty) {
          final recommendedStoryProvider = context
              .read<RecommendedStoryProvider>();
          final recommendedStories =
              recommendedStoryProvider.recommendedStories;
          final storyProgress = recommendedStories
              .where((r) => r.storyId == widget.story.nameEn)
              .firstOrNull;
          if (storyProgress != null && storyProgress.progress > 0) {
            savedProgress = storyProgress.progress;
          }
        }
      }

      // Set story with saved progress (only for recommended stories)
      _storyProvider!.setCurrentStory(widget.story, progress: savedProgress);
    });
  }

  void _playStoryAudio() async {
    if (widget.story.audio.isEmpty) return;

    try {
      // If there are multiple audio files, play the first one
      final audioUrl = widget.story.audio.isNotEmpty
          ? widget.story.audio.first
          : '';
      if (audioUrl.isEmpty) return;

      _storyAudio = CustomAudioWidget(
        audioPath: audioUrl,
        audioSourceType: AudioSourceType.network,
      );
      await _storyAudio!.play();
      logger.d('Playing story audio: $audioUrl');
    } catch (e) {
      logger.e('Error playing story audio: $e');
    }
  }

  void _disposeStoryAudio() async {
    try {
      if (_storyAudio != null) {
        await _storyAudio!.dispose();
        _storyAudio = null;
        logger.d('Story audio disposed');
      }
    } catch (e) {
      logger.e('Error disposing story audio: $e');
    }
  }

  @override
  void dispose() {
    try {
      _storyProvider?.stopAudioAndResetIndex();
      _disposeStoryAudio();
    } catch (e) {
      logger.e('Error stopping audio in dispose: $e');
    }

    MetricsTrackingHelper.endLearningSessionSafe();
    super.dispose();
  }

  /// Checks if current content has a background image
  bool _hasBackgroundImage(int idx, List<Content> contentList) {
    if (idx > 0 && idx <= contentList.length) {
      final currentContent = contentList[idx - 1];
      return currentContent.image.isNotEmpty;
    }
    return false;
  }

  /// Gets the background image path if available
  String? _getBackgroundImage(int idx, List<Content> contentList) {
    if (idx > 0 && idx <= contentList.length) {
      return contentList[idx - 1].image;
    }
    return null;
  }

  /// Builds the full-screen background image widget
  Widget _buildFullScreenBackground(String imagePath) {
    return Positioned.fill(
      child: CustomImage(
        imagePath,
        imageType: CustomImageType.network,
        boxFit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  /// Builds action buttons (close, next) for the story screen
  List<Widget> _buildActionButtons(
    BuildContext context,
    StoryProvider provider,
  ) {
    return [
      Positioned(
        top: 16,
        right: Dimensions.kIconMargin(context),
        child: CircularButtonWidget(
          type: CircularButtonType.close,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      Positioned(
        right: Dimensions.kIconMargin(context),
        top: 0,
        bottom: 0,
        child: Center(
          child: CircularButtonWidget(
            type: CircularButtonType.rightArrow,
            onPressed: () {
              _disposeStoryAudio();
              provider.nextContent(context);
            },
          ),
        ),
      ),
    ];
  }

  /// Builds the story intro screen
  Widget _buildStoryIntro(BuildContext context, StoryProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Background color is handled at parent level to cover whole screen
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, innerConstraints) {
                  // Use percentages of full screen height, but account for SafeArea
                  final screenHeight = MediaQuery.of(context).size.height;
                  final availableHeight = innerConstraints.maxHeight;
                  final availableWidth = innerConstraints.maxWidth;

                  // Get SafeArea padding to reserve space at top and bottom
                  final safeAreaTop = MediaQuery.of(context).padding.top;
                  final safeAreaBottom = MediaQuery.of(context).padding.bottom;

                  // Calculate fixed sizes as percentages of screen height
                  // Top padding: 5% of screen height (but ensure we have space for SafeArea)
                  final topPadding = (screenHeight * 0.05).clamp(
                    safeAreaTop,
                    screenHeight,
                  );

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
                  final descHeight = widget.story.nameEn.isNotEmpty
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

                  // Reserve bottom space for SafeArea
                  final bottomReserve = safeAreaBottom;
                  final maxContentHeight = availableHeight - bottomReserve;

                  // Ensure we don't exceed available height - adjust thumbnail if needed
                  final adjustedThumbnailSize = totalUsed > maxContentHeight
                      ? thumbnailSize - (totalUsed - maxContentHeight)
                      : thumbnailSize;

                  return SizedBox(
                    height: availableHeight,
                    width: availableWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: topPadding),
                        // Story thumbnail - fixed size
                        if (widget.story.thumbnail.isNotEmpty)
                          SizedBox(
                            width: adjustedThumbnailSize,
                            height: adjustedThumbnailSize,
                            child: SvgHelper.fromSource(
                              path: widget.story.thumbnail,
                              width: adjustedThumbnailSize,
                              height: adjustedThumbnailSize,
                              fit: BoxFit.contain,
                              type: SvgSourceType.network,
                            ),
                          ),
                        SizedBox(height: gap1),
                        // Story title - fixed height
                        SizedBox(
                          height: titleHeight,
                          child: Center(
                            child: Text(
                              widget.story.nameNp,
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
                        // Story description - fixed height
                        if (widget.story.nameEn.isNotEmpty)
                          SizedBox(
                            height: descHeight,
                            child: Center(
                              child: Text(
                                widget.story.nameEn,
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
            ..._buildActionButtons(context, provider),
          ],
        );
      },
    );
  }

  /// Builds the story content card
  Widget _buildStoryContent(int idx, List<Content> contentList) {
    if (idx > 0 && idx <= contentList.length) {
      final content = contentList[idx - 1];
      return Column(
        children: [
          Expanded(
            child: StoryContentCard(
              content: content,
              isLast: idx == contentList.length,
              onConfetti: () {},
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSkyBlue,
      body: Builder(
        builder: (context) {
          return Consumer<StoryProvider>(
            builder: (context, provider, _) {
              final story = provider.currentStory ?? widget.story;
              final contentList = story.content;
              final idx = provider.currentContentIndex;

              // Logging for debugging
              logger.d(
                '[StoryContentScreen] total: \\${contentList.length}, current: \\$idx, remaining: \\${contentList.length - idx}',
              );

              // Check if current content has background image
              final hasBackgroundImage = _hasBackgroundImage(idx, contentList);
              final backgroundImage = _getBackgroundImage(idx, contentList);

              // Build main content widget
              final mainContent = idx == 0
                  ? () {
                      Misc.onLayoutRendered(() {
                        _playStoryAudio();
                      });
                      return _buildStoryIntro(context, provider);
                    }()
                  : _buildStoryContent(idx, contentList);

              // Build action buttons (only for intro)
              final actionButtons = idx == 0
                  ? _buildActionButtons(context, provider)
                  : <Widget>[];

              // If there's a background image, it should cover the whole screen
              if (hasBackgroundImage && backgroundImage != null) {
                return Stack(
                  children: [
                    // Background image extends to full screen (behind SafeArea)
                    _buildFullScreenBackground(backgroundImage),
                    // Content with SafeArea for interactive elements
                    SafeArea(
                      child: Stack(children: [mainContent, ...actionButtons]),
                    ),
                  ],
                );
              }

              // For intro screen (idx == 0), use yellow background covering whole screen
              if (idx == 0) {
                return Stack(
                  children: [
                    // Yellow background extends to full screen (behind SafeArea)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.sunshineYellow,
                        ),
                      ),
                    ),
                    // Content with SafeArea for interactive elements
                    SafeArea(
                      child: Stack(children: [mainContent, ...actionButtons]),
                    ),
                  ],
                );
              }

              // For other screens without background image, use Container + SafeArea pattern
              return Container(
                color: AppColors.kSkyBlue,
                child: SafeArea(
                  child: Stack(children: [mainContent, ...actionButtons]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
