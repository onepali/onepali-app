import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widget/gaps.dart';

class PAverageLearningWidget extends StatelessWidget {
  final int completedActivities;
  final double answerSuccessRate;
  final bool isMobilePortrait;

  const PAverageLearningWidget({
    super.key,
    required this.completedActivities,
    required this.answerSuccessRate,
    required this.isMobilePortrait,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  completedActivities.toString(),
                  style:
                      isMobilePortrait
                          ? AppStyles.text32PxSemiBold
                          : AppStyles.text40PxSemiBold,
                ),
                Gaps.verticalGapOf(8),
                Text(
                  'Completed activities',
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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(answerSuccessRate * 100).toInt()}',
                  style:
                      isMobilePortrait
                          ? AppStyles.text32PxSemiBold
                          : AppStyles.text40PxSemiBold,
                ),
                Text('%', style: AppStyles.text14PxRegular),
                Gaps.verticalGapOf(8),
                Text(
                  'Answer success rate',
                  textAlign: TextAlign.center,
                  style: AppStyles.text14PxRegular,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
