import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widget/gaps.dart';

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('Days learning', style: AppStyles.text14PxRegular),
          Gaps.verticalGapOf(8),
          Text(
            '$dayStreak/7',
            style:
                isMobilePortrait
                    ? AppStyles.text32PxSemiBold
                    : AppStyles.text40PxSemiBold,
          ),
          Gaps.verticalGapOf(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final checked = weeklyStreak.length > i && weeklyStreak[i];
              return Column(
                children: [
                  Text(days[i], style: AppStyles.text12PxRegular),
                  Gaps.verticalGapOf(4),
                  Icon(
                    checked ? Icons.check_circle : Icons.radio_button_unchecked,
                    color:
                        checked ? AppColors.kButtonGreen : AppColors.kLightGrey,
                    size: 24,
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
