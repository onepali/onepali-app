import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AppRoutes {
  static const String comingSoon = '/coming-soon';

  /// [Splash] & [OnBoarding] Routes
  static const String splashScreen = '/splash';
  static const String onboardingScreen = '/onboarding';

  /// [Dashboard] Routes
  static const String dashboardScreen = '/dashboard';

  /// [User] Routes
  static const String userScreen = '/user';

  /// [Lesson] Routes
  static const String lessonScreen = '/lesson';

  /// A map of the application's routes.
  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    onboardingScreen: (context) => const OnboardingScreen(),

    dashboardScreen: (context) => const DashboardScreen(),
    userScreen: (context) => const UserScreen(),
    lessonScreen: (context) => const LessonScreen(),
  };
}
