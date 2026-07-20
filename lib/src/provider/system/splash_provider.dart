import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class SplashProvider extends ChangeNotifier {
  final Duration splashDelay;

  SplashProvider({this.splashDelay = const Duration(milliseconds: 3400)});

  Future<void> waitAndNavigate(context) async {
    // final audioController = CustomAudioWidget(audioPath: Assets.eww);
    // audioController.play();

    await Future.delayed(splashDelay, () {
      // audioController.dispose();

      Utility.navigate(context, AppRoutes.onboardingScreen);
    });
  }
}
