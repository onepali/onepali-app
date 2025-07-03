import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widget/gaps.dart';

class PDashboardMetricsWidget extends StatelessWidget {
  final int averageDailyLearningTime;
  final List<String> mostPracticedTopics;
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
    final minHeight = isMobilePortrait ? 140.0 : 180.0;
    return IntrinsicHeight(
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
                  Text(
                    '$averageDailyLearningTime',
                    style:
                        isMobilePortrait
                            ? AppStyles.text32PxSemiBold
                            : AppStyles.text40PxSemiBold,
                  ),
                  Text('mins', style: AppStyles.text14PxRegular),
                  Gaps.verticalGapOf(8),
                  Text(
                    'Average daily learning time',
                    textAlign: TextAlign.center,
                    style: AppStyles.text14PxRegular,
                  ),
                ],
              ),
            ),
          ),
          Gaps.horizontalGapOf(12),
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
                    style: AppStyles.text14PxRegular,
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
                      decoration: BoxDecoration(
                        color: colors[i % colors.length].withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${i + 1}. ${mostPracticedTopics[i]}',
                        style: AppStyles.text14PxMedium.copyWith(
                          color: colors[i % colors.length],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
