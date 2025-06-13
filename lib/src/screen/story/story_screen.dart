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
      context.read<StoryProvider>().fetchRecommendedStoriesForActiveChild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isWeb = PlatformUtility.isWeb(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    double cardWidth;
    double listHeight;
    if (isWeb) {
      cardWidth = 400;
      listHeight = 320;
    } else if (isTablet) {
      cardWidth = isLandscape ? 350 : 300;
      listHeight = isLandscape ? 260 : 350;
    } else {
      cardWidth = isLandscape ? 320 : 260;
      listHeight = isLandscape ? 220 : 320;
    }
    return Consumer<StoryProvider>(
      builder: (context, provider, _) {
        if (provider.status == DataFetchStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.status == DataFetchStatus.error) {
          return const Center(child: Text('Failed to load stories'));
        }
        final stories = provider.stories;
        if (stories.isEmpty) {
          return const Center(child: Text('No stories found'));
        }
        return SizedBox(
          height: listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: stories.length,
            separatorBuilder: (_, __) => Gaps.horizontalGapOf(16),
            itemBuilder: (context, i) {
              final story = stories[i];
              return SizedBox(width: cardWidth, child: StoryCard(story: story));
            },
          ),
        );
      },
    );
  }
}
