import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class AppCardResponsive {
  static double getCardWidth(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final width = MediaQuery.of(context).size.width;
    double result;
    if (isTablet) {
      result = isLandscape ? width * 0.45 : width * 0.36;
    } else if (isMobile) {
      result = isLandscape ? width * 0.45 : width * 0.6;
    } else {
      result = width * 0.4;
    }

    logger.d(
      'AppCardResponsive.getCardWidth: $result (width: $width, isTablet: $isTablet, isMobile: $isMobile, isLandscape: $isLandscape)',
    );
    return result;
  }

  static double getCardHeight(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final height = MediaQuery.of(context).size.height;
    double result;
    if (isTablet) {
      result = isLandscape ? height * 0.55 : height * 0.5;
    } else if (isMobile) {
      result = isLandscape ? height * 0.55 : height * 0.55;
    } else {
      result = height * 0.5;
    }

    logger.d(
      'AppCardResponsive.getCardHeight: $result (height: $height, isTablet: $isTablet, isMobile: $isMobile, isLandscape: $isLandscape)',
    );
    return result;
  }

  static double getLessonCardHeight(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final height = MediaQuery.of(context).size.height;
    double result;
    if (isTablet) {
      result = isLandscape ? height * 0.55 : height * 0.5;
    } else if (isMobile) {
      result = isLandscape ? height * 0.55 : height * 0.55;
    } else {
      result = height * 0.5;
    }

    logger.d(
      'AppCardResponsive.getLessonCardHeight: $result (height: $height, isTablet: $isTablet, isMobile: $isMobile, isLandscape: $isLandscape)',
    );
    return result;
  }

  static double getThumbnailHeight(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final height = MediaQuery.of(context).size.height;
    if (isTablet) {
      return isLandscape ? height * 0.25 : height * 0.25;
    } else if (isMobile) {
      return isLandscape ? height * 0.25 : height * 0.25;
    } else {
      return height * 0.25;
    }
  }

  static double getThumbnailWidth(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final width = MediaQuery.of(context).size.width;
    if (isTablet) {
      return isLandscape ? width * 0.4 : width * 0.3;
    } else if (isMobile) {
      return isLandscape ? width * 0.3 : width * 0.3;
    } else {
      return width * 0.3;
    }
  }
}
