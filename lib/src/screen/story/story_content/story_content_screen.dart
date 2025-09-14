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
      _storyProvider!.setCurrentStory(widget.story);
      await _storyProvider!.fetchRecommendedStoriesForActiveChild(context);
    });
  }

  void _playStoryAudio() async {
    if (widget.story.audio.isEmpty) return;

    try {
      // If there are multiple audio files, play the first one
      final audioUrl =
          widget.story.audio.isNotEmpty ? widget.story.audio.first : '';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.kSkyBlue,
        body: Consumer<StoryProvider>(
          builder: (context, provider, _) {
            final story = provider.currentStory ?? widget.story;
            final contentList = story.content;
            final idx = provider.currentContentIndex;

            // Logging for debugging
            logger.d(
              '[StoryContentScreen] total: \\${contentList.length}, current: \\$idx, remaining: \\${contentList.length - idx}',
            );

            if (idx == 0) {
              Misc.onLayoutRendered(() {
                _playStoryAudio();
              });

              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.sunshineYellow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Story thumbnail
                          if (widget.story.thumbnail.isNotEmpty)
                            SvgHelper.fromSource(
                              path: widget.story.thumbnail,
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
                              fit: BoxFit.contain,
                              type: SvgSourceType.network,
                            ),
                          Gaps.verticalGapOf(30),
                          // Lesson title
                          Text(
                            widget.story.nameNp,
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
                          if (widget.story.nameEn.isNotEmpty)
                            Text(
                              widget.story.nameEn,
                              style: AppStyles.text16PxMedium.copyWith(
                                color: AppColors.kBlack,
                                fontSize:
                                    PlatformUtility.isTablet(context) &&
                                            PlatformUtility.isLandscape(context)
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  // Start button
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: customInkwell(
                      onTap: () {
                        _disposeStoryAudio();
                        provider.nextContent(context);
                      },
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
                        padding: const EdgeInsets.symmetric(horizontal: 24),

                        child: SvgHelper.fromSource(
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
                      ),
                    ),
                  ),
                ],
              );
            }

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
          },
        ),
      ),
    );
  }
}
