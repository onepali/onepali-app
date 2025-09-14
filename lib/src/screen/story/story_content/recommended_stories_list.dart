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
        final allStories = storyProvider.stories;
        final recommendedStories = recommendedProvider.recommendedStories;
        final recommendedStoryIds =
            recommendedStories.map((r) => r.storyId).toSet();
        final List<StoryModel> recommendedStoryModels =
            allStories
                .where((s) => recommendedStoryIds.contains(s.nameEn))
                .toList();
        return StatusHandler(
          status: recommendedProvider.status,
          hasData: recommendedStoryModels.isNotEmpty,
          errorTitle: 'No recommended stories',
          errorMessage: 'Please check back later for new stories.',
          checkConnectivity: false,
          onRetry: () {
            recommendedProvider.fetchRecommendedStories();
          },
          successBuilder: () {
            return SizedBox(
              height: AppCardResponsive.getCardHeight(context),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
      },
    );
  }
}
