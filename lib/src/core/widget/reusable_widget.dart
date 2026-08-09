import 'package:flutter/material.dart';

import '../../src.dart';

class ReusableWidget {
  static GestureDetector horizontalIconTitle({
    String? icon,
    IconData? iconData,
    String? title,
    VoidCallback? onTap,
    double? height,
    double iconSize = 24,
    TextStyle? textStyle,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },

      child: Container(
        height: height ?? 45,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.kGrey.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null)
              Icon(iconData, size: iconSize, color: AppColors.kPitchBlack)
            else
              SvgHelper.fromSource(
                path: icon ?? Assets.google,
                height: iconSize,
                width: iconSize,
              ),
            Gaps.horizontalGapOf(15),
            Text(
              title ?? 'Sign in with Google',
              style: textStyle ?? AppStyles.text14PxRegular,
            ),
          ],
        ),
      ),
    );
  }
}
