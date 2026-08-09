import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

final double forwardBtnIconSizeMobile = 48.0; // 48x48
final double forwardBtnIconSizeTablet = 64.0; // 64x64

class BackArrowButton extends StatelessWidget {
  const BackArrowButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return GestureDetector(
      onTap: onTap,
      child: SvgHelper.fromSource(
        path: Assets.leftArrow,
        height: isMobile ? forwardBtnIconSizeMobile : forwardBtnIconSizeTablet,
        width: isMobile ? forwardBtnIconSizeMobile : forwardBtnIconSizeTablet,
      ),
    );
  }
}

/// Keeps the back button clear of the left safe area.
double leftAlignedBackButtonPadding(BuildContext context) {
  final isMobile = PlatformUtility.isMobile(context);
  final mediaQuery = MediaQuery.of(context);
  final hasLeftSystemInset =
      mediaQuery.padding.left > 0 || mediaQuery.viewPadding.left > 0;

  return hasLeftSystemInset ? 0 : (isMobile ? 24 : 32);
}

class CenterLeftAlignedBackButton extends StatelessWidget {
  const CenterLeftAlignedBackButton({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: leftAlignedBackButtonPadding(context)),
        child: SafeArea(
          right: false,
          bottom: false,
          top: false,
          left: true,
          child: BackArrowButton(onTap: onTap),
        ),
      ),
    );
  }
}
