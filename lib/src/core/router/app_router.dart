import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AppRoutes {
  /// [Splash] & [OnBoarding] Routes
  static const String splashScreen = '/splash';

  /// [Dashboard] Routes
  static const String dashboardScreen = '/dashboard';

  /// A map of the application's routes.
  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),

    dashboardScreen: (context) => const DashboardScreen(),
  };
}
