import 'package:flutter/material.dart';

import '../../src.dart';

class Dimensions {
  Dimensions._();
  static double get iconSize => 48.0;
  static double get iconSizeLarge => 64.0;

  static double get iconMargin => 24.0;
  static double get iconMarginLarge => 32.0;

  static double get settingAvatarSize => 48.0;
  static double get settingAvatarSizeLarge => 64.0;

  static double get bottomNavIconSize => 24.0;
  static double get bottomNavIconSizeLarge => 48.0;

  static double get bottomNavHeight => 56.0;
  static double get bottomNavHeightLarge => 80.0;

  static double kIconSize(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    return isTablet && isLandscape ? iconSizeLarge : iconSize;
  }

  static double kIconMargin(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    return isTablet && isLandscape ? iconMarginLarge : iconMargin;
  }

  static double kSettingAvatarSize(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    // final isLandscape = PlatformUtility.isLandscape(context);
    return isTablet ? settingAvatarSizeLarge : settingAvatarSize;
  }

  static double kBottomNavIconSize(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    // final isLandscape = PlatformUtility.isLandscape(context);
    return isTablet ? bottomNavIconSizeLarge : bottomNavIconSize;
  }

  static double kBottomNavHeight(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    // final isLandscape = PlatformUtility.isLandscape(context);
    return isTablet ? bottomNavHeightLarge : bottomNavHeight;
  }
}
