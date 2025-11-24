import 'package:flutter/widgets.dart';
import 'package:responsive_builder/responsive_builder.dart' as rb;

import '../src.dart';

class ResponsiveConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockWidth = 0;
  static double blockHeight = 0;
  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;

  // Actual device dimensions (regardless of orientation)
  static double deviceWidth = 0;
  static double deviceHeight = 0;
  static double deviceShortestSide = 0;
  static double deviceLongestSide = 0;

  // Legacy flags (deprecated - use enums instead)
  static bool isPortrait = true;
  static bool isMobilePortrait = false;
  static bool isTablet = false;
  static bool isLargerScreen = false;
  static bool isTabletLandscape = false;
  static bool isIpadMini = false;

  // Device type from responsive_builder
  static rb.DeviceScreenType deviceScreenType = rb.DeviceScreenType.mobile;

  // App-specific enums for device classification
  static DeviceType currentDeviceType = DeviceType.mobile;
  static RefinedSize currentRefinedSize = RefinedSize.normal;
  static RefinedOrientation currentOrientation = RefinedOrientation.portrait;

  // Minimum width for defining device types
  static const double minPhoneSize = 480;
  static const double minTabletSize = 768;
  static const double minDesktopSize = 1440;
  static const double minTabletLandscapeSize = 1100;
  // iPad mini (6th gen and A17 Pro) logical width/height
  static const double ipadMiniPortraitWidth = 744;
  static const double ipadMiniLandscapeWidth = 1133;

  // Initialize screen sizes and other device-specific configurations
  void init(BoxConstraints constraints, Orientation orientation) {
    // Use actual constraint dimensions (don't swap for orientation)
    screenWidth = constraints.maxWidth;
    screenHeight = constraints.maxHeight;
    isPortrait = orientation == Orientation.portrait;

    // Calculate device dimensions (shortest/longest side)
    deviceShortestSide = screenWidth < screenHeight
        ? screenWidth
        : screenHeight;
    deviceLongestSide = screenWidth > screenHeight ? screenWidth : screenHeight;
    deviceWidth = screenWidth;
    deviceHeight = screenHeight;

    // Get device type from responsive_builder
    deviceScreenType = rb.getDeviceType(Size(screenWidth, screenHeight));

    // Set orientation enum
    currentOrientation = isPortrait
        ? RefinedOrientation.portrait
        : RefinedOrientation.landscape;

    // Set device type enum based on shortest side
    if (deviceShortestSide >= minDesktopSize) {
      currentDeviceType = DeviceType.desktop;
    } else if (deviceShortestSide >= minTabletSize) {
      currentDeviceType = DeviceType.tablet;
    } else {
      currentDeviceType = DeviceType.mobile;
    }

    // Set refined size enum based on shortest side
    if (deviceShortestSide < 375) {
      currentRefinedSize = RefinedSize.small; // iPhone SE, small phones
    } else if (deviceShortestSide < 768) {
      currentRefinedSize = RefinedSize.normal; // Standard phones
    } else if (deviceShortestSide < 1024) {
      currentRefinedSize = RefinedSize.large; // iPad, tablets
    } else {
      currentRefinedSize = RefinedSize.extraLarge; // iPad Pro, desktops
    }

    // Set legacy flags for backward compatibility
    isMobilePortrait = deviceShortestSide < minPhoneSize && isPortrait;
    isTablet =
        deviceShortestSide >= minTabletSize &&
        deviceShortestSide < minDesktopSize;
    isTabletLandscape = isTablet && !isPortrait;
    isLargerScreen = deviceShortestSide >= minDesktopSize;

    // Detect iPad mini (6th gen and A17 Pro) by shortest side
    isIpadMini =
        (deviceShortestSide >= ipadMiniPortraitWidth - 10 &&
        deviceShortestSide <= ipadMiniPortraitWidth + 10);

    logger.d(
      'Screen: ${screenWidth}x$screenHeight | '
      'Orientation: $currentOrientation | '
      'Device: ${deviceShortestSide}x$deviceLongestSide | '
      'Type: $currentDeviceType | '
      'Size: $currentRefinedSize | '
      'isTablet: $isTablet | isIpadMini: $isIpadMini',
    );

    // Calculate block sizes for responsive scaling
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;

    // Use smaller multiplier for landscape to prevent overflow
    if (isPortrait) {
      textMultiplier = blockHeight;
      imageSizeMultiplier = blockWidth;
      heightMultiplier = blockHeight;
      widthMultiplier = blockWidth;
    } else {
      // In landscape, use reduced multipliers to fit content
      // More aggressive reduction for mobile landscape to prevent overflow
      final isMobileLandscape = currentDeviceType == DeviceType.mobile && !isPortrait;
      final reductionFactor = isMobileLandscape ? 0.6 : 0.8;
      
      textMultiplier = blockHeight * reductionFactor;
      imageSizeMultiplier = blockWidth * reductionFactor;
      heightMultiplier = blockHeight * (isMobileLandscape ? 0.7 : 0.9);
      widthMultiplier = blockWidth;
    }
  }

  // Utility method for getting dynamic font size
  static double getFontSize(double baseFontSize) {
    return baseFontSize * textMultiplier;
  }

  // Example: Use this in your widgets for iPad mini specific adjustments
  // if (ResponsiveConfig.isIpadMini) { ...custom layout... }

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

  // ========== Enum-based Helper Methods ==========

  /// Check if current device is mobile
  static bool get isMobile => currentDeviceType == DeviceType.mobile;

  /// Check if current device is tablet
  static bool get isTabletDevice => currentDeviceType == DeviceType.tablet;

  /// Check if current device is desktop
  static bool get isDesktop => currentDeviceType == DeviceType.desktop;

  /// Check if current device is watch
  static bool get isWatch => currentDeviceType == DeviceType.watch;

  /// Check if current orientation is portrait
  static bool get isPortraitOrientation =>
      currentOrientation == RefinedOrientation.portrait;

  /// Check if current orientation is landscape
  static bool get isLandscapeOrientation =>
      currentOrientation == RefinedOrientation.landscape;

  /// Check if device size is small (e.g., iPhone SE, small phones)
  static bool get isSmallDevice => currentRefinedSize == RefinedSize.small;

  /// Check if device size is normal (e.g., standard phones)
  static bool get isNormalDevice => currentRefinedSize == RefinedSize.normal;

  /// Check if device size is large (e.g., iPad, tablets)
  static bool get isLargeDevice => currentRefinedSize == RefinedSize.large;

  /// Check if device size is extra large (e.g., iPad Pro, desktops)
  static bool get isExtraLargeDevice =>
      currentRefinedSize == RefinedSize.extraLarge;

  /// Get device type classification
  static DeviceType get deviceType => currentDeviceType;

  /// Get refined size classification
  static RefinedSize get refinedSize => currentRefinedSize;

  /// Get orientation classification
  static RefinedOrientation get orientation => currentOrientation;

  /// Helper to check if device is mobile in portrait mode
  static bool get isMobileInPortrait => isMobile && isPortraitOrientation;

  /// Helper to check if device is mobile in landscape mode
  static bool get isMobileInLandscape => isMobile && isLandscapeOrientation;

  /// Helper to check if device is tablet in portrait mode
  static bool get isTabletInPortrait => isTabletDevice && isPortraitOrientation;

  /// Helper to check if device is tablet in landscape mode
  static bool get isTabletInLandscape =>
      isTabletDevice && isLandscapeOrientation;

  /// Get appropriate font size based on device size
  static double getAdaptiveFontSize({
    required double small,
    required double normal,
    required double large,
    required double extraLarge,
  }) {
    switch (currentRefinedSize) {
      case RefinedSize.small:
        return getFontSize(small);
      case RefinedSize.normal:
        return getFontSize(normal);
      case RefinedSize.large:
        return getFontSize(large);
      case RefinedSize.extraLarge:
        return getFontSize(extraLarge);
    }
  }

  /// Get appropriate spacing based on device size
  static double getAdaptiveSpacing({
    required double small,
    required double normal,
    required double large,
    required double extraLarge,
  }) {
    switch (currentRefinedSize) {
      case RefinedSize.small:
        return small;
      case RefinedSize.normal:
        return normal;
      case RefinedSize.large:
        return large;
      case RefinedSize.extraLarge:
        return extraLarge;
    }
  }

  /// Get appropriate padding based on device size
  static EdgeInsets getAdaptivePadding({
    required EdgeInsets small,
    required EdgeInsets normal,
    required EdgeInsets large,
    required EdgeInsets extraLarge,
  }) {
    switch (currentRefinedSize) {
      case RefinedSize.small:
        return small;
      case RefinedSize.normal:
        return normal;
      case RefinedSize.large:
        return large;
      case RefinedSize.extraLarge:
        return extraLarge;
    }
  }
}
