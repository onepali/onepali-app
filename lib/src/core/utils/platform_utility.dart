import 'package:flutter/material.dart';

class PlatformUtility {
  PlatformUtility._();

  /// Returns true if the device is a tablet (shortest side >= 720dp)
  /// Uses shortest side to correctly identify devices regardless of orientation
  /// Threshold set to 720dp to avoid misclassifying large phones/phablets as tablets
  static bool isTablet(BuildContext context) {
    if (isWeb(context)) return false;
    final shortest = MediaQuery.of(context).size.shortestSide;
    // Use 720dp threshold to ensure phones (even large ones) are not misclassified
    // Common phone sizes: 320px - 540px (all < 720dp)
    // Tablets typically start at 600dp+ but we use 720dp to be more conservative
    return shortest >= 720;
  }

  /// Returns true if the device is a mobile (shortest side < 720dp)
  /// Uses shortest side to correctly identify all known mobile devices regardless of orientation
  static bool isMobile(BuildContext context) {
    if (isWeb(context)) return false;
    final shortest = MediaQuery.of(context).size.shortestSide;
    // Use 720dp threshold to capture all known mobile devices (phones, phablets)
    // Common phone sizes: 320px - 540px (all < 720dp)
    return shortest < 720;
  }

  /// Returns true if the device is iOS
  static bool isIOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  /// Returns true if the device is Android
  static bool isAndroid(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android;
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

  /// Returns true if the device is a tablet in portrait orientation
  static bool isTabletPortrait(BuildContext context) {
    return isTablet(context) && isPortrait(context);
  }
}
