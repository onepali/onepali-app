import 'package:flutter/material.dart';

import '../../../../src.dart';

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
    final minHeight = isMobilePortrait ? 140.0 : 290.0;
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
                    completedActivities.toString(),
                    style: AppStyles.text40PxSemiBold.copyWith(
                      fontSize: isMobilePortrait ? 40 : 72,
                    ),
                  ),
                  Gaps.verticalGapOf(8),
                  Text(
                    'Completed activities',
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
          Gaps.horizontalGapOf(isMobilePortrait ? 16 : 32),
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
                        '${(answerSuccessRate * 100).toInt()}',
                        style: AppStyles.text40PxSemiBold.copyWith(
                          fontSize: isMobilePortrait ? 40 : 72,
                        ),
                      ),
                      Gaps.horizontalGapOf(4),
                      Text(
                        '%',
                        style: AppStyles.text16PxSemiBold.copyWith(
                          fontSize: isMobilePortrait ? 16 : 24,
                        ),
                      ),
                    ],
                  ),
                  Gaps.verticalGapOf(8),
                  Text(
                    'Answer success rate',
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
        ],
      ),
    );
  }
}
