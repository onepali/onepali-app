import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class AppCardResponsive {
  static double getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final result = width * 0.4;
    
    logger.d(
      'AppCardResponsive.getCardWidth: $result (width: $width)',
    );
    return result;
  }

  static double getCardHeight(BuildContext context) {
    final cardWidth = getCardWidth(context);
    final result = cardWidth * 0.60;

    logger.d(
      'AppCardResponsive.getCardHeight: $result (cardWidth: $cardWidth)',
    );
    return result;
  }

  static double getLessonCardHeight(BuildContext context) {
    return getCardHeight(context);
  }

  static double getThumbnailHeight(BuildContext context) {
    final cardHeight = getLessonCardHeight(context);
    return cardHeight * 0.42;
  }

  static double getThumbnailWidth(BuildContext context) {
    return getThumbnailHeight(context);
  }

  static double getCardGapHeight(BuildContext context) {
    final cardHeight = getLessonCardHeight(context);
    return cardHeight * 0.01;
  }

  static double getCardTextHeight(BuildContext context) {
    final cardHeight = getLessonCardHeight(context);
    return cardHeight * 0.27;
  }

  /// Get the card height for dashboard display (80% for tablets, 100% for mobile)
  /// This ensures consistent height for both recommended and regular cards
  static double getDashboardCardHeight(BuildContext context) {
    bool isTablet = PlatformUtility.isTablet(context);
    return isTablet
        ? getLessonCardHeight(context) * 0.8 // 20% smaller for tablets
        : getLessonCardHeight(context);
  }
}
