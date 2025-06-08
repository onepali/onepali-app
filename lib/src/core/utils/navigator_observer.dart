import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onepali/src/src.dart';

class OrientationRouteObserver extends NavigatorObserver {
  static const List<String> portraitRoutes = [
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
  ];

  void _setOrientation(Route<dynamic>? route) {
    final name = route?.settings.name ?? '';
    if (portraitRoutes.contains(name)) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
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
