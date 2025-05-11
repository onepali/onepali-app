import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class SplashProvider extends ChangeNotifier {
  final Duration splashDelay;

  SplashProvider({this.splashDelay = const Duration(milliseconds: 1500)});

  Future<void> waitAndNavigate(context) async {
    await Future.delayed(splashDelay, () {
      Utility.navigate(context, AppRoutes.dashboardScreen);
    });
  }
}
