import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class AppCardResponsive {
  /// Get card width based on screen width (consistent for mobile and tablet)
  /// Uses 40% of screen width for both mobile and tablet
  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final result = screenWidth * 0.4;

    logger.d(
      'AppCardResponsive.getCardWidth: $result (screenWidth: $screenWidth)',
    );
    return result;
  }

  /// Get card height based on card width (consistent for mobile and tablet)
  /// Height is 60% of card width for both mobile and tablet
  static double getCardHeight(BuildContext context) {
    final cardWidth = getCardWidth(context);
    final result = cardWidth * 0.60;

    logger.d(
      'AppCardResponsive.getCardHeight: $result (cardWidth: $cardWidth)',
    );
    return result;
  }

  /// Get lesson card height (same as card height)
  static double getLessonCardHeight(BuildContext context) {
    return getCardHeight(context);
  }

  /// Get thumbnail height based on card height (consistent calculation)
  /// Thumbnail is 65% of card height to make images prominent
  static double getThumbnailHeight(BuildContext context) {
    final cardHeight = getCardHeight(context);
    final result = cardHeight * 0.65;

    logger.d(
      'AppCardResponsive.getThumbnailHeight: $result (cardHeight: $cardHeight)',
    );
    return result;
  }

  /// Get thumbnail width (same as thumbnail height - square thumbnails)
  static double getThumbnailWidth(BuildContext context) {
    return getThumbnailHeight(context);
  }

  /// Get gap height between thumbnail and text (0.5% of card height)
  static double getCardGapHeight(BuildContext context) {
    final cardHeight = getCardHeight(context);
    return cardHeight * 0.005;
  }

  /// Get text height allocation (27% of card height)
  static double getCardTextHeight(BuildContext context) {
    final cardHeight = getCardHeight(context);
    return cardHeight * 0.27;
  }

  /// Get the card height for dashboard display (consistent for mobile and tablet)
  /// Uses the same calculation as getCardHeight: 60% of card width
  /// This ensures consistent sizing across mobile and tablet
  static double getDashboardCardHeight(BuildContext context) {
    // Return same height for both mobile and tablet
    // Height is always 60% of card width (which is 40% of screen width)
    return getLessonCardHeight(context);
  }
}
