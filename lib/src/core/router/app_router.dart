import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AppRoutes {
  static const String comingSoon = '/coming';
  static const String errorScreen = '/error';
  static const String noInternetScreen = '/no-internet';
  static const String notFoundScreen = '/not-found';
  static const String logout = '/logout';

  /// [System] Routes
  static const String systemScreen = '/system';
  static const String aboutUsScreen = '/about-us';
  static const String contactScreen = '/contact-us';
  static const String faqsScreen = '/faqs';

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

  /// Child Register Routes
  static const String childRegisterScreen = '/child/register';
  static const String childRS1Screen = '/child/register/step1';
  static const String childRS2Screen = '/child/register/step2';
  static const String childRS3Screen = '/child/register/step3';
  static const String childRS4Screen = '/child/register/step4';

  /// [Dashboard] Routes
  static const String dashboardScreen = '/dashboard';
  static const String guestDashboardScreen = '/guest/dashboard';

  /// [Drawer] Routes
  static const String drawerRoutes = '/drawer';

  /// [User] Routes
  static const String userScreen = '/user';

  /// [Reward] Routes
  static const String rewardScreen = '/reward';
  static const String rewardCollectionScreen = '/reward/collection';
  static const String chooseRewardScreen = '/reward/choose';

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

  /// [Parent] ---> [Review] Routes
  static const String parentReviewScreen = '/parent/review';

  /// [Parent] ---> [Notification] Routes
  static const String parentNotificationScreen = '/parent/notification';

  /// [Parent] ---> [Plans] Routes
  static const String parentPlansScreen = '/parent/plans';

  /// A map of the application's routes.
  static Map<String, WidgetBuilder> routes = {
    systemScreen: (context) => const SystemScreen(),
    aboutUsScreen: (context) => const AboutUsScreen(),
    contactScreen: (context) => const ContactScreen(),
    faqsScreen:
        (context) => FaqsScreen(
          faqsData:
              ModalRoute.of(context)?.settings.arguments as List<FaqModel>? ??
              [],
        ),

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

    childRegisterScreen: (context) => const ChildRegisterScreen(),
    childRS1Screen: (context) => const ChildRS1Screen(),
    childRS2Screen: (context) => const ChildRS2Screen(),
    childRS3Screen: (context) => const ChildRS3Screen(),

    // childRS4Screen: (context) => const ChildRS4Screen(),
    dashboardScreen: (context) => const DashboardScreen(),
    guestDashboardScreen: (context) => const GuestDashboardScreen(),
    userScreen: (context) => const UserScreen(),

    rewardScreen: (context) => const RewardScreen(),
    rewardCollectionScreen: (context) => const RewardCollectionWidget(),
    chooseRewardScreen: (context) => ChooseRewardWidget(),
    languageScreen: (context) => const LanguageScreen(),

    childProfileScreen:
        (context) => CUserScreen(
          child: ModalRoute.of(context)?.settings.arguments as ChildUserModel,
        ),
    parentProfileScreen: (context) => const UserScreen(),

    // Parent Zone Routes
    parentDashboardScreen: (context) => const ParentDashboardScreen(),
    parentPinScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final fromScreenTimeLimit = args?['fromScreenTimeLimit'] ?? false;
      return ParentZoneScreen(fromScreenTimeLimit: fromScreenTimeLimit);
    },
    parentHomeScreen: (context) => const PHomeScreen(),
    parentBlogScreen: (context) => const ParentBlogScreen(),
    parentSettingScreen: (context) => const ParentSettingScreen(),
    blogDetailScreen:
        (context) => PBlogDetailScreen(
          data: ModalRoute.of(context)?.settings.arguments as PzBlogModel?,
        ),

    parentReviewScreen: (context) => const PreviewScreen(),
    parentNotificationScreen: (context) => const NotificationScreen(),

    parentPlansScreen: (context) => const PlanScreen(),
  };
}
