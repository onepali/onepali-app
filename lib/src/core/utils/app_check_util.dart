import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import '../../src.dart';

class AppCheckUtil {
  static Future<void> initialize() async {
    try {
      await FirebaseAppCheck.instance.activate(
        // For Android
        androidProvider: kDebugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,

        // For iOS
        appleProvider: kDebugMode
            ? AppleProvider.debug
            : AppleProvider.appAttest,

        // For Web (you'll need to configure reCAPTCHA v3 in Firebase Console)
        providerWeb: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      );

      logger.i('✅ Firebase App Check activated successfully');

      if (kDebugMode) {
        try {
          final token = await FirebaseAppCheck.instance.getToken();
          logger.d('🔑 App Check debug token: $token');
        } catch (e) {
          logger.w('Could not get App Check token: $e');
        }
      }
    } catch (e) {
      logger.e('❌ Failed to activate Firebase App Check: $e');

      if (kDebugMode) {
        logger.w('📋 Debug mode: You may need to:');
        logger.w('   1. Enable App Check in Firebase Console');
        logger.w('   2. Add debug tokens for development');
        logger.w('   3. Configure Play Integrity API for production');
      }

      // Don't rethrow - App Check failure should not prevent app from launching
      // The app can still function without App Check, it just won't have the extra protection
      logger.w('⚠️ Continuing app launch without App Check protection');
    }
  }

  static Future<String?> getToken() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();
      return token;
    } catch (e) {
      logger.e('Failed to get App Check token: $e');
      return null;
    }
  }

  static Future<bool> isActivated() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();
      return token != null;
    } catch (e) {
      return false;
    }
  }
}
