import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = PlatformUtility.isTablet(context);
    final double size = isTablet ? 360.0 : 120.0;

    return Center(
      child: LottieHelper.fromSource(
        path: Assets.preLoader,
        height: size,
        width: size,
      ),
    );
  }
}
