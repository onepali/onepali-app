import 'package:flutter/material.dart';
import 'package:onepali/src/core/utils/platform_utility.dart';

class AppCardResponsive {
  static double getCardWidth(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final width = MediaQuery.of(context).size.width;
    if (isTablet) {
      return isLandscape ? width * 0.45 : width * 0.36;
    } else if (isMobile) {
      return isLandscape ? width * 0.45 : width * 0.6;
    } else {
      return width * 0.4;
    }
  }

  static double getCardHeight(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final height = MediaQuery.of(context).size.height;
    if (isTablet) {
      return isLandscape ? height * 0.45 : height * 0.5;
    } else if (isMobile) {
      return isLandscape ? height * 0.45 : height * 0.55;
    } else {
      return height * 0.5;
    }
  }

  static double getLessonCardHeight(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final height = MediaQuery.of(context).size.height;
    if (isTablet) {
      return isLandscape ? height * 0.55 : height * 0.5;
    } else if (isMobile) {
      return isLandscape ? height * 0.55 : height * 0.55;
    } else {
      return height * 0.5;
    }
  }
}
