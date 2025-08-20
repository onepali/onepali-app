import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class PlanCard extends StatelessWidget {
  final String planName;
  final DateTime? activeDate;
  final DateTime? expiryDate;
  final bool isFree;

  const PlanCard({
    super.key,
    required this.planName,
    this.activeDate,
    this.expiryDate,
    this.isFree = false,
  });

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime? date) {
      if (date == null) return 'MM/DD/YYYY';
      return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current plan',
                style: AppStyles.text16PxRegular.copyWith(
                  color: AppColors.kBlack,
                ),
              ),
              Text(
                planName,
                style: AppStyles.text16PxMedium.copyWith(
                  color: AppColors.kBlack,
                ),
              ),
            ],
          ),
        ),
        if (!isFree) ...[
          Gaps.verticalGapOf(16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active from',
                  style: AppStyles.text16PxRegular.copyWith(
                    color: AppColors.kBlack,
                  ),
                ),
                Text(
                  formatDate(activeDate),
                  style: AppStyles.text16PxMedium.copyWith(
                    color: AppColors.kBlack,
                  ),
                ),
              ],
            ),
          ),
          Gaps.verticalGapOf(16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Available until', style: AppStyles.text16PxRegular),
                Text(
                  formatDate(expiryDate),
                  style: AppStyles.text16PxMedium.copyWith(
                    color: AppColors.kBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
