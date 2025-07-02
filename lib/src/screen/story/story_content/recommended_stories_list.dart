import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class RecommendedStoriesList extends StatelessWidget {
  const RecommendedStoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    // final authState = Provider.of<AuthState>(context, listen: false);
    // final childId = authState.currentChildId ?? '';

    return Consumer2<RecommendedStoryProvider, StoryProvider>(
      builder: (context, recommendedProvider, storyProvider, _) {
        final status = recommendedProvider.status;
        if (status == DataFetchStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (status == DataFetchStatus.error) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Failed to load recommended stories.',
              style: AppStyles.text16PxMedium.copyWith(color: Colors.red),
            ),
          );
        }
        // Map RecommendedStoryModel to StoryModel for display
        final allStories = storyProvider.stories;
        final recommendedStories = recommendedProvider.recommendedStories;
        final recommendedStoryIds =
            recommendedStories.map((r) => r.storyId).toSet();
        final List<StoryModel> recommendedStoryModels =
            allStories
                .where((s) => recommendedStoryIds.contains(s.nameEn))
                .toList();
        if (recommendedStoryModels.isEmpty &&
            recommendedProvider.status == DataFetchStatus.error) {
          return const SizedBox();
        }
        return SizedBox(
          height: AppCardResponsive.getCardHeight(context),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommendedStoryModels.length,
            separatorBuilder: (_, _) => Gaps.horizontalGapOf(16),
            itemBuilder: (context, i) {
              final story = recommendedStoryModels[i];
              final rec =
                  recommendedStories
                          .where((r) => r.storyId == story.nameEn)
                          .isNotEmpty
                      ? recommendedStories.firstWhere(
                        (r) => r.storyId == story.nameEn,
                      )
                      : null;
              double? progressPercent;
              if (rec != null && story.content.isNotEmpty) {
                progressPercent = rec.progress / story.content.length;
              }
              return SizedBox(
                width: AppCardResponsive.getCardWidth(context),
                child: StoryCard(
                  story: story,
                  progressPercent: progressPercent,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
