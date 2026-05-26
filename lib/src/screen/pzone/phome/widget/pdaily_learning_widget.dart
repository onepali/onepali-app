import 'package:flutter/material.dart';
import '../../../../src.dart';

class PDailyLearningWidget extends StatelessWidget {
  final int dayStreak;
  final List<bool> weeklyStreak;
  final bool isMobilePortrait;

  const PDailyLearningWidget({
    super.key,
    required this.dayStreak,
    required this.weeklyStreak,
    required this.isMobilePortrait,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final activeDaysThisWeek = weeklyStreak.where((active) => active).length;
    double? height = isMobilePortrait ? null : 320;
    return Container(
      width: double.infinity,
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Day streak',
            style: AppStyles.text16PxMedium.copyWith(
              fontFamily: AppConstants.kDMSansFont,
              fontSize: isMobilePortrait ? 16 : 24,
            ),
          ),
          Gaps.verticalGapOf(8),
          Text(
            '$dayStreak',
            style: AppStyles.text40PxSemiBold.copyWith(
              fontSize: isMobilePortrait ? 40 : 72,
            ),
          ),
          Gaps.verticalGapOf(4),
          Text(
            '$activeDaysThisWeek/7 this week',
            style: AppStyles.text16PxRegular.copyWith(
              fontFamily: AppConstants.kDMSansFont,
              fontSize: isMobilePortrait ? 14 : 20,
            ),
          ),
          Gaps.verticalGapOf(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final checked = weeklyStreak.length > i && weeklyStreak[i];
              return Column(
                children: [
                  Text(
                    days[i],
                    style: AppStyles.text16PxRegular.copyWith(
                      fontFamily: AppConstants.kDMSansFont,
                      fontSize: isMobilePortrait ? 16 : 24,
                    ),
                  ),
                  Gaps.verticalGapOf(4),
                  Icon(
                    checked ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: checked
                        ? AppColors.kButtonGreen
                        : AppColors.kLightGrey,
                    size: isMobilePortrait ? 24 : 48,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
