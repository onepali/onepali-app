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
    final colors = [
      AppColors.kAccentColor,
      AppColors.sunshineYellow,
      AppColors.kVideoColor,
    ];
    final minHeight = isMobilePortrait ? 140.0 : 290.0;
    mostPracticedTopics.sort(
      (a, b) => b.completedCount.compareTo(a.completedCount),
    );

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Most practiced topics',
                          style: AppStyles.text16PxMedium.copyWith(
                            fontFamily: AppConstants.kDMSansFont,
                            fontSize: isMobilePortrait ? 16 : 24,
                          ),
                        ),
                        Gaps.verticalGapOf(8),
                        ...List.generate(
                          mostPracticedTopics.length > 3
                              ? 3
                              : mostPracticedTopics.length,
                          (i) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: colors[i % colors.length], // .withValues(
                              //   alpha: 0.3,
                              // ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${i + 1}. ${mostPracticedTopics[i].contentName}',
                                  style: AppStyles.text16PxMedium.copyWith(
                                    // color: colors[i % colors.length],
                                    fontFamily: AppConstants.kDMSansFont,
                                    fontSize: isMobilePortrait ? 16 : 24,
                                  ),
                                ),
                                Text(
                                  'x${mostPracticedTopics[i].completedCount}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        if (isMobilePortrait) Gaps.verticalGapOf(16),
        if (isMobilePortrait)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Most practiced topics',
                    style: AppStyles.text14PxMedium.copyWith(
                      fontFamily: AppConstants.kDMSansFont,
                    ),
                  ),
                ),
                Gaps.verticalGapOf(8),
                ...List.generate(
                  mostPracticedTopics.length > 3
                      ? 3
                      : mostPracticedTopics.length,
                  (i) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      // .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${i + 1}. ${mostPracticedTopics[i].contentName}',
                          style: AppStyles.text14PxMedium.copyWith(
                            fontFamily: AppConstants.kDMSansFont,
                          ),

                          // .copyWith(
                          //   color: colors[i % colors.length],
                          // )
                        ),

                        Text('x${mostPracticedTopics[i].completedCount}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
