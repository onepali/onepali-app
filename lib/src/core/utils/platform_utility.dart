import 'package:flutter/material.dart';

class PlatformUtility {
  PlatformUtility._();

  /// Returns true if the device is a tablet (width >= 900 and not web)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final shortest = MediaQuery.of(context).size.shortestSide;
    return !isWeb(context) && (shortest >= 600 || width >= 900);
  }

  /// Returns true if the device is a mobile (width < 900 and not web)
  static bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final shortest = MediaQuery.of(context).size.shortestSide;
    return !isWeb(context) && (shortest < 600 && width < 900);
  }

  /// Returns true if the app is running on web
  static bool isWeb(BuildContext context) {
    return identical(0, 0.0);
  }

  /// Returns true if the device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Returns true if the device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
}
