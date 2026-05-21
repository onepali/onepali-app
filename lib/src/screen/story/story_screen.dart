import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<StoryProvider>().fetchStories();
      context.read<StoryProvider>().fetchRecommendedStoriesForActiveChild(
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, provider, _) {
        return StatusHandler(
          status: provider.status,
          hasData: provider.stories.isNotEmpty,
          errorTitle: 'No stories found',
          errorMessage: 'Please check back later for new stories.',
          checkConnectivity: false,
          onRetry: () {
            context.read<StoryProvider>().fetchStories();
          },
          successBuilder: () {
            final stories = provider.stories;
            double cardHeight = AppCardResponsive.getDashboardCardHeight(
              context,
            );

            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: stories.length,
                separatorBuilder: (_, _) => Gaps.horizontalGapOf(16),
                itemBuilder: (context, i) {
                  final story = stories[i];
                  return SizedBox(
                    width: AppCardResponsive.getCardWidth(context),
                    height: cardHeight,
                    child: StoryCard(
                      story: story,
                      isGuestUser: GuestUtil.isGuestUser(),
                      isLocked: i > 0,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
