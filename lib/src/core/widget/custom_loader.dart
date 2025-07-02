import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Center(
        child: LottieHelper.fromSource(
          path: Assets.preLoader,
          height: 120,
          width: 120,
        ),
      ),
    );
  }
}
