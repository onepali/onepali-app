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
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() async {
      final authState = context.read<AuthState>();
      final childId = await ChildLocalStorage.getCurrentChildId();
      if (childId != null && childId.isNotEmpty) {
        authState.setCurrentChildId(childId);
      }
      if (!mounted) return;
      context.read<StoryProvider>().setCurrentStory(widget.story);
      await context.read<StoryProvider>().fetchRecommendedStoriesForActiveChild(
        context,
      );
    });
  }

  @override
  void dispose() {
    context.read<StoryProvider>().stopAudio();
    context.read<StoryProvider>().fetchRecommendedStoriesForActiveChild(
      context,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSkyBlue,
      body: SafeArea(
        child: Consumer<StoryProvider>(
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
                    ),
                  ),
                  // Right arrow to go to next lesson
                  Positioned(
                    right: 32,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => provider.nextContent(context),
                      child: Container(
                        width: 48,
                        height: 48,
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
