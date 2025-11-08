import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class StoryContentScreen extends StatefulWidget {
  final StoryModel story;
  const StoryContentScreen({super.key, required this.story});

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
      
      // Fetch recommended stories to get saved progress
      await _storyProvider!.fetchRecommendedStoriesForActiveChild(context);
      
      // Get saved progress for this story
      int? savedProgress;
      if (childId != null && childId.isNotEmpty) {
        final recommendedStoryProvider = context.read<RecommendedStoryProvider>();
        final recommendedStories = recommendedStoryProvider.recommendedStories;
        final storyProgress = recommendedStories
            .where((r) => r.storyId == widget.story.nameEn)
            .firstOrNull;
        if (storyProgress != null && storyProgress.progress > 0) {
          savedProgress = storyProgress.progress;
        }
      }
      
      // Set story with saved progress (if available)
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
              return Stack(
                children: [
        // Background color is handled at parent level to cover whole screen
                  Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Story thumbnail
                          if (widget.story.thumbnail.isNotEmpty)
                            SvgHelper.fromSource(
                              path: widget.story.thumbnail,
                    width: PlatformUtility.isTablet(context) &&
                                          PlatformUtility.isLandscape(context)
                                      ? 475
                                      : 180,
                    height: PlatformUtility.isTablet(context) &&
                                          PlatformUtility.isLandscape(context)
                                      ? 300
                                      : 180,
                              fit: BoxFit.contain,
                              type: SvgSourceType.network,
                            ),
                          Gaps.verticalGapOf(
                            PlatformUtility.isTablet(context) &&
                                    PlatformUtility.isLandscape(context)
                                ? 30
                                : 10,
                ),
                          Text(
                            widget.story.nameNp,
                            style: AppStyles.text24PxBold.copyWith(
                    fontSize: PlatformUtility.isTablet(context) &&
                                          PlatformUtility.isLandscape(context)
                                      ? 64
                                      : 40,
                              fontFamily: AppConstants.kMuktaFont,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (PlatformUtility.isTablet(context) &&
                              PlatformUtility.isLandscape(context))
                  Gaps.verticalGapOf(10),
                          if (widget.story.nameEn.isNotEmpty)
                            Text(
                              widget.story.nameEn,
                              style: AppStyles.text16PxMedium.copyWith(
                                color: AppColors.kBlack,
                      fontSize: PlatformUtility.isTablet(context) &&
                                            PlatformUtility.isLandscape(context)
                                        ? 32
                                        : 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
        ..._buildActionButtons(context, provider),
                ],
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
              final hasBackgroundImage =
                  _hasBackgroundImage(idx, contentList);
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
                      child: Stack(
                        children: [
                          mainContent,
                          ...actionButtons,
                        ],
                      ),
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
                      child: Stack(
                        children: [
                          mainContent,
                          ...actionButtons,
                        ],
                      ),
                    ),
                  ],
                );
              }

              // For other screens without background image, use Container + SafeArea pattern
              return Container(
                color: AppColors.kSkyBlue,
                child: SafeArea(
                  child: Stack(
                    children: [
                      mainContent,
                      ...actionButtons,
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
