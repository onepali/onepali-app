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

/// Default padding to the left [24] mobile and [32] tablet
class CenterLeftAlignedBackButton extends StatelessWidget {
  const CenterLeftAlignedBackButton({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: isMobile ? 24 : 32),
        child: BackArrowButton(onTap: onTap),
      ),
    );
  }
}
