import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class PrintablesCard extends StatelessWidget {
  final PrintableModel printable;
  final VoidCallback onTap;

  const PrintablesCard({
    super.key,
    required this.printable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return customInkwell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kLightGrey, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    printable.title,
                    style: AppStyles.text16PxRegular.copyWith(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gaps.horizontalGapOf(12),

                CustomImage(
                  printable.thumbnail,
                  height: 60,
                  width: 60,
                  cover: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
