import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    await context.read<SplashProvider>().waitAndNavigate(context);
  }

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
