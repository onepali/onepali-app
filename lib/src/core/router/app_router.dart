import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AppRoutes {
  static const String comingSoon = '/coming';
  static const String errorScreen = '/error';
  static const String noInternetScreen = '/no-internet';
  static const String notFoundScreen = '/not-found';
  static const String logout = '/logout';

  /// [Splash] & [OnBoarding] Routes
  static const String splashScreen = '/splash';
  static const String onboardingScreen = '/onboarding';

  /// [Auth] Routes
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';

  /// [Auth]  --->  [Register] Routes
  static const String rs1Screen = '/register/step1';
  static const String rs2Screen = '/register/step2';
  static const String rs3Screen = '/register/step3';
  static const String rs4Screen = '/register/step4';
  static const String rs5Screen = '/register/step5';
  static const String rs6Screen = '/register/step6';

  /// [Dashboard] Routes
  static const String dashboardScreen = '/dashboard';

  /// [User] Routes
  static const String userScreen = '/user';

  /// [Language] Routes
  static const String languageScreen = '/language';

  /// [Profile] Update Routes
  static const String childProfileScreen = '/cprofile/update';
  static const String parentProfileScreen = '/pz_profile/update';

  //*--------- Parent Zone Routes ---------*/
  /// [Parent] Routes
  static const String parentDashboardScreen = '/parent/dashboard';
  static const String parentPinScreen = '/parent/pin';
  static const String parentHomeScreen = '/parent/home';
  static const String parentSettingScreen = '/parent/setting';
  static const String parentBlogScreen = '/parent/blog';
  static const String blogDetailScreen = '/parent/blog/detail';

  /// A map of the application's routes.
  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    onboardingScreen: (context) => const OnboardingScreen(),

    loginScreen: (context) => const LoginScreen(),
    registerScreen: (context) => const RegisterScreen(),

    rs1Screen: (context) => const RS1Screen(),
    rs2Screen: (context) => const RS2Screen(),
    rs3Screen: (context) => const RS3Screen(),
    rs4Screen: (context) => const RS4Screen(),
    rs5Screen: (context) => const RS5Screen(),
    rs6Screen: (context) => const RS6Screen(),

    dashboardScreen: (context) => const DashboardScreen(),
    userScreen: (context) => const UserScreen(),
    languageScreen: (context) => const LanguageScreen(),

    childProfileScreen:
        (context) => CUserScreen(
          child: ModalRoute.of(context)?.settings.arguments as ChildUserModel,
        ),
    parentProfileScreen: (context) => const UserScreen(),

    // Parent Zone Routes
    parentDashboardScreen: (context) => const ParentDashboardScreen(),
    parentPinScreen: (context) => const ParentZoneScreen(),
    parentHomeScreen: (context) => const PHomeScreen(),
    parentBlogScreen: (context) => const ParentBlogScreen(),
    parentSettingScreen: (context) => const ParentSettingScreen(),
    blogDetailScreen:
        (context) => PBlogDetailScreen(
          data: ModalRoute.of(context)?.settings.arguments as PzBlogModel?,
        ),
  };
}
