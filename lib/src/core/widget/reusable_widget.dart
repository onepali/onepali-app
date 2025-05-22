import 'package:flutter/material.dart';

import '../../src.dart';

class ReusableWidget {
  static horizontalIconTitle({
    String? icon,
    String? title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },

      child: Container(
        height: 45,
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
            SvgHelper.fromSource(
              path: icon ?? Assets.google,
              height: 24,
              width: 24,
            ),
            Gaps.horizontalGapOf(15),
            Text(
              title ?? 'Sign in with Google',
              style: AppStyles.text14PxRegular,
            ),
          ],
        ),
      ),
    );
  }
}
