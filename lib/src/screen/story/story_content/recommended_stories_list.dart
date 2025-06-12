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
        if (recommendedStoryModels.isEmpty) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                'Recommended Stories',
                style: AppStyles.text20PxSemiBold,
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recommendedStoryModels.length,
                separatorBuilder: (_, __) => Gaps.horizontalGapOf(16),
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
                    width: 260,
                    child: StoryCard(
                      story: story,
                      progressPercent: progressPercent,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
