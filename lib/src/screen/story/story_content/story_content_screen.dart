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

  @override
  void dispose() {
    // Use stored provider reference to avoid context access in dispose
    try {
      _storyProvider?.stopAudio();
    } catch (e) {
      logger.e('Error stopping audio in dispose: $e');
    }

    // End learning session when leaving story (context-free for safe disposal)
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
              return Stack(
                children: [
                  Positioned.fill(
                    child: StoryCard(
                      story: story,
                      isRadius: false,
                      isRecommended: true,
                      isIntro: true,
                    ),
                  ),
                  // Right arrow to go to next lesson
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
                  Positioned(
                    right: 25,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => provider.nextContent(context),
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(12),
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
                        child: SvgHelper.fromSource(path: Assets.rightArrow),
                      ),
                    ),
                  ),
                ],
              );
            }

            // Show content card for idx in 1..contentList.length (inclusive)
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
