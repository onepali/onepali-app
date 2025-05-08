import 'package:flutter/widgets.dart';

class ResponsiveConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockWidth = 0;
  static double blockHeight = 0;
  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;

  static bool isPortrait = true;
  static bool isMobilePortrait = false;
  static bool isTablet = false;
  static bool isLargerScreen = false;
  static bool isTabletLandscape = false;

  // Minimum width for defining device types
  static const double minPhoneSize = 480;
  static const double minTabletSize = 768;
  static const double minDesktopSize = 1440;
  static const double minTabletLandscapeSize = 1100;

  // Initialize screen sizes and other device-specific configurations
  void init(BoxConstraints constraints, Orientation orientation) {
    screenWidth =
        orientation == Orientation.portrait
            ? constraints.maxWidth
            : constraints.maxHeight;
    screenHeight =
        orientation == Orientation.portrait
            ? constraints.maxHeight
            : constraints.maxWidth;
    isPortrait = orientation == Orientation.portrait;

    // Set flags for different device types
    isMobilePortrait = screenWidth < minPhoneSize && isPortrait;
    isTablet = screenWidth >= minTabletSize && screenWidth < minDesktopSize;
    isTabletLandscape =
        isTablet && !isPortrait && screenWidth >= minTabletLandscapeSize;
    isLargerScreen = screenWidth >= minDesktopSize;

    // Calculate block sizes for responsive scaling
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;

    textMultiplier = blockHeight;
    imageSizeMultiplier = blockWidth;
    heightMultiplier = blockHeight;
    widthMultiplier = blockWidth;
  }

  // Utility method for getting dynamic font size
  static double getFontSize(double baseFontSize) {
    return baseFontSize * textMultiplier;
  }

  // Utility method for dynamic image size
  static double getImageSize(double baseSize) {
    return baseSize * imageSizeMultiplier;
  }

  // Utility method for dynamic width
  static double getResponsiveWidth(double baseWidth) {
    return baseWidth * widthMultiplier;
  }

  // Utility method for dynamic height
  static double getResponsiveHeight(double baseHeight) {
    return baseHeight * heightMultiplier;
  }
}
