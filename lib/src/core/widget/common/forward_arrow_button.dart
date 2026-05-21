import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

final double forwardBtnIconSizeMobile = 48.0; // 48x48
final double forwardBtnIconSizeTablet = 64.0; // 64x64

class ForwardArrowButton extends StatelessWidget {
  const ForwardArrowButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return GestureDetector(
      onTap: onTap,
      child: SvgHelper.fromSource(
        path: Assets.rightArrow,
        height: isMobile ? forwardBtnIconSizeMobile : forwardBtnIconSizeTablet,
        width: isMobile ? forwardBtnIconSizeMobile : forwardBtnIconSizeTablet,
      ),
    );
  }
}

/// Default padding to the right [24] mobile and [32] tablet
class CenterRightAlignedForwardButton extends StatelessWidget {
  const CenterRightAlignedForwardButton({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: isMobile ? 24 : 32),
        child: ForwardArrowButton(onTap: onTap),
      ),
    );
  }
}
