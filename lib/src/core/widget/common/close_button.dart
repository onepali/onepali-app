import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

final double closeBtnIconSizeMobile = 48.0; // 48x48
final double closeBtnIconSizeTablet = 64.0; // 64x64

final double closeBtnPositionMobile = 24.0; // padding:24(top,right)
final double closeBtnPositionTablet = 32.0; // padding:32(top,right)

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return GestureDetector(
      onTap: onTap,
      child: SvgHelper.fromSource(
        path: Assets.wrong,
        height: isMobile ? closeBtnIconSizeMobile : closeBtnIconSizeTablet,
        width: isMobile ? closeBtnIconSizeMobile : closeBtnIconSizeTablet,
      ),
    );
  }
}

/// Use this widget as a child of [Stack] widget
class TopRightPositionedCloseButton extends StatelessWidget {
  const TopRightPositionedCloseButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return Positioned(
      top: isMobile ? closeBtnPositionMobile : closeBtnPositionTablet,
      right: isMobile ? closeBtnPositionMobile : closeBtnPositionTablet,
      child: CustomCloseButton(onTap: onTap),
    );
  }
}
