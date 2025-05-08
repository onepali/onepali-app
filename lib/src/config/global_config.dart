import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../src.dart';

class GlobalConfig {
  // App Settings
  static const String appName = AppConstants.appName;
  static const String appVersion = AppConstants.appVersion;

  // Debug
  static const bool isDebugMode = kDebugMode;
  static const bool isShowDebugModeBanner = false;

  // Crashlytics
  static const bool showCrashlytics = true;
  static const bool showFatalError = true;

  // Colors
  static const Color primaryColor = AppColors.kPrimaryColor;

  //-***** Don't change unless you know 100% what you are doing *****-//

  // BASE URL
  static String baseUrl = '';
}
