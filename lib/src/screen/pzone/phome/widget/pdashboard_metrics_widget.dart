import 'package:flutter/material.dart';

import '../../../../src.dart';

class PDashboardMetricsWidget extends StatelessWidget {
  final int averageDailyLearningTime;
  final List<PzCompletedContentModel> mostPracticedTopics;
  final bool isMobilePortrait;

  const PDashboardMetricsWidget({
    super.key,
    required this.averageDailyLearningTime,
    required this.mostPracticedTopics,
    required this.isMobilePortrait,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [AppColors.kPink, AppColors.kYellow, AppColors.kPurple];
    final minHeight = isMobilePortrait ? 140.0 : 290.0;
    final sortedTopics = List<PzCompletedContentModel>.from(mostPracticedTopics)
      ..sort((a, b) => b.completedCount.compareTo(a.completedCount));

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minHeight: minHeight),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$averageDailyLearningTime',
                            style: AppStyles.text40PxSemiBold.copyWith(
                              fontSize: isMobilePortrait ? 40 : 72,
                            ),
                          ),
                          Gaps.horizontalGapOf(8),
                          Text(
                            'mins',
                            style: AppStyles.text16PxMedium.copyWith(
                              fontFamily: AppConstants.kDMSansFont,
                              fontSize: isMobilePortrait ? 16 : 24,
                            ),
                          ),
                        ],
                      ),
                      Gaps.verticalGapOf(8),
                      Text(
                        'Average daily learning time',
                        textAlign: TextAlign.center,
                        style: AppStyles.text16PxMedium.copyWith(
                          fontFamily: AppConstants.kDMSansFont,
                          fontSize: isMobilePortrait ? 16 : 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isMobilePortrait) Gaps.horizontalGapOf(32),
              if (!isMobilePortrait)
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(minHeight: minHeight),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.kWhite,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _MostPracticedTopicsList(
                      topics: sortedTopics,
                      colors: colors,
                      isMobilePortrait: isMobilePortrait,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (isMobilePortrait) Gaps.verticalGapOf(16),
        if (isMobilePortrait)
          Container(
            height: minHeight,
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _MostPracticedTopicsList(
              topics: sortedTopics,
              colors: colors,
              isMobilePortrait: isMobilePortrait,
            ),
          ),
      ],
    );
  }
}

class _MostPracticedTopicsList extends StatelessWidget {
  const _MostPracticedTopicsList({
    required this.topics,
    required this.colors,
    required this.isMobilePortrait,
  });

  final List<PzCompletedContentModel> topics;
  final List<Color> colors;
  final bool isMobilePortrait;

  @override
  Widget build(BuildContext context) {
    final textStyle = isMobilePortrait
        ? AppStyles.text14PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          )
        : AppStyles.text16PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
            fontSize: 24,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobilePortrait)
          Center(child: Text('Most practiced topics', style: textStyle))
        else
          Text('Most practiced topics', style: textStyle),
        Gaps.verticalGapOf(8),
        ...List.generate(topics.length > 3 ? 3 : topics.length, (index) {
          final topic = topics[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${topic.contentName}',
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gaps.horizontalGapOf(8),
                Text('x${topic.completedCount}', style: textStyle),
              ],
            ),
          );
        }),
      ],
    );
  }
}
