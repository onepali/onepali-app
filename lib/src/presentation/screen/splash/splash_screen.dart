import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.patternBg),
            fit: BoxFit.cover,
            opacity: 0.03,
          ),
        ),
        alignment: Alignment.center,
        child: LottieHelper.fromSource(
          path: Assets.logoLottie,
          repeat: false,
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
