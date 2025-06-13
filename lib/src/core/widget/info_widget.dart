import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class InfoWidget {
  static Row info(String text) {
    return Row(
      children: [
        Icon(Icons.info_outline, color: AppColors.kGrey, size: 16),
        Gaps.horizontalGapOf(8),
        Expanded(child: Text(text, style: AppStyles.text12PxRegular)),
      ],
    );
  }
}
