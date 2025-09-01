import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onepali/src/src.dart';

class OrientationRouteObserver extends NavigatorObserver {
  static const List<String> portraitRoutes = [
    AppRoutes.systemScreen,
    AppRoutes.aboutUsScreen,
    AppRoutes.contactScreen,
    AppRoutes.faqsScreen,
    AppRoutes.splashScreen,
    AppRoutes.loginScreen,
    AppRoutes.onboardingScreen,
    AppRoutes.registerScreen,
    AppRoutes.rs1Screen,
    AppRoutes.rs2Screen,
    AppRoutes.rs3Screen,
    AppRoutes.rs4Screen,
    AppRoutes.rs5Screen,
    AppRoutes.rs6Screen,
    AppRoutes.parentDashboardScreen,
    AppRoutes.parentHomeScreen,
    AppRoutes.parentBlogScreen,
    AppRoutes.parentProfileScreen,
    AppRoutes.blogDetailScreen,
    AppRoutes.childProfileScreen,
    AppRoutes.parentProfileScreen,
    AppRoutes.parentNotificationScreen,
    AppRoutes.parentSettingScreen,
    AppRoutes.parentPlansScreen,
    AppRoutes.parentReviewScreen,
    AppRoutes.childRegisterScreen,
    AppRoutes.childRS1Screen,
    AppRoutes.childRS2Screen,
    AppRoutes.childRS3Screen,
    AppRoutes.childRS4Screen,
  ];

  // Helper method to check if a route is a modal that shouldn't change orientation
  bool _isModalRoute(Route<dynamic>? route) {
    if (route == null) return false;

    final name = route.settings.name;

    // Check if it's a modal route without a name or with modal-specific names
    if (route is ModalRoute &&
        (name == null ||
            (name.contains(AppConstants.modalRoute)) ||
            (name.contains(AppConstants.bottomSheetModal)) ||
            (name.contains(AppConstants.dialogModal)) ||
            name == AppConstants.datePickerModal ||
            name == AppConstants.timePickerModal ||
            name == AppConstants.avatarPickerModal ||
            name == AppConstants.customDialogModal ||
            name == AppConstants.popupMenuModal)) {
      return true;
    }

    return false;
  }

  void _setOrientation(Route<dynamic>? route) {
    final name = route?.settings.name ?? '';
    logger.i('OrientationRouteObserver: route name = $name');

    // Skip orientation changes for modal routes (bottom sheets, dialogs)
    if (_isModalRoute(route)) {
      logger.i(
        'Skipping orientation change for modal route (bottom sheet/dialog)',
      );
      return;
    }

    if (portraitRoutes.contains(name)) {
      logger.i('Setting orientation: PORTRAIT');
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else if (name.isNotEmpty) {
      logger.i('Setting orientation: LANDSCAPE');
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _setOrientation(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _setOrientation(previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _setOrientation(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
