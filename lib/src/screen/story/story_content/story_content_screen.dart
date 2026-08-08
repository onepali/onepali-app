import 'package:flutter/material.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/screen/story/story_content/widget/button_tap_content2.dart';
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
  bool _storyIntroAudioStarted = false;

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
    if (_storyIntroAudioStarted || widget.story.audio.isEmpty) return;
    _storyIntroAudioStarted = true;

    try {
      if (!mounted) {
        _storyIntroAudioStarted = false;
        return;
      }
      final storyProvider = _storyProvider ?? context.read<StoryProvider>();
      await storyProvider.playAudio(widget.story.audio);
      logger.d('Playing story audio: ${widget.story.audio}');
    } catch (e) {
      _storyIntroAudioStarted = false;
      logger.e('Error playing story audio: $e');
    }
  }

  void _disposeStoryAudio([StoryProvider? provider]) {
    _storyIntroAudioStarted = false;
    (provider ?? _storyProvider)?.stopAudioAndResetIndex();
  }

  @override
  void dispose() {
    try {
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
  String? _getBackgroundImage(
    int idx,
    List<Content> contentList, {
    bool isMobile = true,
  }) {
    if (idx > 0 && idx <= contentList.length) {
      if (!isMobile && contentList[idx - 1].imageTb != null) {
        return contentList[idx - 1].imageTb;
      }
      return contentList[idx - 1].image;
    }
    return null;
  }

  /// Builds the full-screen background image widget
  Widget _buildFullScreenBackground(String imagePath) {
    return Positioned.fill(
      child: imagePath.toLowerCase().contains('.svg')
          ? SvgHelper.fromSource(
              path: imagePath,
              type: SvgSourceType.network,
              fit: BoxFit.cover,
            )
          : CustomImage(
              imagePath,
              imageType: CustomImageType.network,
              boxFit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
    );
  }

  String? _getStoryIntroImage(StoryModel story, bool isMobile) {
    final image = isMobile ? story.bgImageMobile : story.bgImageTablet;
    return image != null && image.isNotEmpty ? image : null;
  }

  Color _getStoryIntroColor(StoryModel story) {
    return colorFromHex(story.bgColor) ?? AppColors.sunshineYellow;
  }

  /// Builds action buttons (close, next) for the story screen
  List<Widget> _buildActionButtons(
    BuildContext context,
    StoryProvider provider,
  ) {
    return [
      TopRightPositionedCloseButton(
        onTap: () {
          _disposeStoryAudio(provider);
          Navigator.of(context).pop();
        },
      ),
      CenterRightAlignedForwardButton(
        onTap: () {
          _disposeStoryAudio(provider);
          provider.nextContent(context);
        },
      ),
    ];
  }

  /// Builds the story intro screen
  Widget _buildStoryIntro() => const SizedBox.shrink();

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
    final isMobile = PlatformUtility.isMobile(context);
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
              final backgroundImage = _getBackgroundImage(
                idx,
                contentList,
                isMobile: isMobile,
              );
              final storyIntroImage = idx == 0
                  ? _getStoryIntroImage(story, isMobile)
                  : null;

              // Build main content widget
              final mainContent = idx == 0
                  ? () {
                      Misc.onLayoutRendered(() {
                        _playStoryAudio();
                      });
                      return _buildStoryIntro();
                    }()
                  : _buildStoryContent(idx, contentList);

              // Build action buttons (only for intro)
              final actionButtons = idx == 0
                  ? _buildActionButtons(context, provider)
                  : <Widget>[];

              // If there's a background image, it should cover the whole screen
              if (hasBackgroundImage && backgroundImage != null) {
                if (contentList[idx - 1].type == "button_tap2") {
                  return ButtonTapContent2(
                    content: contentList[idx - 1],
                    playAudio: true,
                    isLast: idx == contentList.length,
                  );
                }
                return Stack(
                  children: [
                    // Background image extends to full screen (behind SafeArea)
                    _buildFullScreenBackground(backgroundImage),
                    // Content with SafeArea for interactive elements
                    SafeArea(
                      right: false,
                      child: Stack(children: [mainContent, ...actionButtons]),
                    ),
                  ],
                );
              }

              // For intro screen (idx == 0), use yellow background covering whole screen
              if (idx == 0) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: ColoredBox(color: _getStoryIntroColor(story)),
                    ),
                    if (storyIntroImage != null)
                      _buildFullScreenBackground(storyIntroImage),
                    // Content with SafeArea for interactive elements
                    SafeArea(
                      right: false,
                      child: Stack(children: [mainContent, ...actionButtons]),
                    ),
                  ],
                );
              }

              // For other screens without background image, use Container + SafeArea pattern
              return Container(
                color: AppColors.kSkyBlue,
                child: SafeArea(
                  right: false,
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
