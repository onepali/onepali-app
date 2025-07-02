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
        if (provider.status == DataFetchStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final stories = provider.stories;
        if (stories.isEmpty && provider.status == DataFetchStatus.error) {
          return ErrorScreen(
            title: 'No Stories Found',
            message: 'Please check back later for new stories.',
            onRetry: () {
              context.read<StoryProvider>().fetchStories();
            },
          );
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: stories.length,
          separatorBuilder: (_, _) => Gaps.horizontalGapOf(16),
          itemBuilder: (context, i) {
            final story = stories[i];
            return SizedBox(
              width: AppCardResponsive.getCardWidth(context),
              child: StoryCard(story: story),
            );
          },
        );
      },
    );
  }
}
