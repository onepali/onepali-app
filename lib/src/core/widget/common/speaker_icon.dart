import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

final double iconSizeMobile = 48.0; // 48x48
final double iconSizeTablet = 64.0; // 64x64

class SpeakerIcon extends StatelessWidget {
  const SpeakerIcon({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: isMobile ? iconSizeMobile : iconSizeTablet,
        height: isMobile ? iconSizeMobile : iconSizeTablet,
        child: SvgHelper.fromSource(path: Assets.sound),
      ),
    );
  }
}
