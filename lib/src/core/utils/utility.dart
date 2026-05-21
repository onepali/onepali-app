import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../src.dart';

class Utility {
  static Future navigate(
    BuildContext context,
    String route, {
    dynamic arguments,
  }) {
    return Navigator.of(context).pushNamed(route, arguments: arguments);
  }

  static Future navigateMaterialRoute(
    BuildContext context,
    screen, {
    String? routeName,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
    );
  }

  static Row horizontalDividerTitle({String? title, TextStyle? titleStyle}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            indent: 20.0,
            endIndent: 12.0,
            color: AppColors.kGrey,
            thickness: 1,
          ),
        ),
        Text(
          title ?? "Or continue with",
          style:
              titleStyle ??
              AppStyles.text12PxRegular.copyWith(color: AppColors.kPitchBlack),
        ),
        Expanded(
          child: Divider(
            indent: 12.0,
            endIndent: 20.0,
            color: AppColors.kGrey,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  static bool isAccessible(data) {
    bool isEmpty = true;
    try {
      if (data != null) {
        if (data is int) {
          return isEmpty;
        }
        if (data?.isEmpty) {
          isEmpty = false;
        }
      } else {
        isEmpty = false;
      }
      return isEmpty;
    } catch (e) {
      return isEmpty;
    }
  }

  static AuthProviderType getAuthTypeFromUserInfo(String userInfo) {
    AuthProviderType type = AuthProviderType.email;
    final loginType = userInfo;
    if (loginType == AuthProviderType.google.name) {
      type = AuthProviderType.google;
    } else if (loginType == AuthProviderType.apple.name) {
      type = AuthProviderType.apple;
    }
    return type;
  }

  static Future<void> authWiseLogout(
    BuildContext context,
    AuthProviderType type,
  ) async {
    switch (type) {
      case AuthProviderType.email:
        await context.read<AuthProvider>().logout(context);
        break;
      case AuthProviderType.google:
        await context.read<GoogleAuthProvider>().signOut(context);
        break;
      case AuthProviderType.apple:
        await context.read<AAuthProvider>().signOut(context);
        break;
      default:
        break;
    }
  }

  static List<Color> parseHexColors(String hexString) {
    final hexParts = hexString.split('/');
    return hexParts.map((hex) {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }).toList();
  }

  static IconData? getProgressTypeIcon(String type) {
    switch (type) {
      case 'completed':
        return Icons.check_circle;
      case 'locked':
        return Icons.lock;
      case 'in-progress':
        return Icons.hourglass_bottom;
      default:
        return null;
    }
  }

  static String? extractYoutubeVideoId(String url) {
    final RegExp regExp = RegExp(
      r'(?:v=|\/)([0-9A-Za-z_-]{11})(?:\?|&|\/|$)',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  static String ytThumbnailType(String type) {
    if (type.isEmpty) {
      return 'hqdefault';
    }
    switch (type) {
      case 'mq':
        return 'mqdefault';
      case 'hq':
        return 'hqdefault';
      case 'sd':
        return 'sddefault';
      case 'max':
        return 'maxresdefault';
      default:
        return 'hqdefault';
    }
  }

  static String generateYoutubeThumbnailUrl(String url, {String type = 'max'}) {
    if (url.isEmpty) {
      return '';
    }
    return 'https://img.youtube.com/vi/${extractYoutubeVideoId(url)}/${ytThumbnailType(type)}.jpg';
  }

  static Future<void> saveFcmTokenToFirestore(String userId) async {
    try {
      // Request notification permissions (will show popup - user can click "Don't allow")
      // IMPORTANT: This function never throws errors - sign-in will always complete successfully
      // even if user clicks "Don't allow" or any error occurs
      final fcmSettings = await FirebaseMessaging.instance.requestPermission();

      // If user clicked "Don't allow", skip token saving gracefully - no errors thrown
      // Sign-in will continue normally - this is completely optional
      if (fcmSettings.authorizationStatus == AuthorizationStatus.denied) {
        logger.d(
          'User declined notification permissions. Skipping FCM token save. Sign-in will continue normally.',
        );
        // Setup listener in case user enables notifications later in settings
        _setupTokenRefreshListener(userId);
        return; // Return early - sign-in continues successfully
      }

      // If permissions are not determined or provisional, wait a bit and try again
      if (fcmSettings.authorizationStatus ==
              AuthorizationStatus.notDetermined ||
          fcmSettings.authorizationStatus == AuthorizationStatus.provisional) {
        logger.d(
          'Notification permissions not fully determined. Will retry when available.',
        );
        _setupTokenRefreshListener(userId);
        return;
      }

      // Permissions granted - proceed to get FCM token
      // On iOS, wait for APNS token to be available before getting FCM token
      if (Platform.isIOS) {
        String? apnsToken;
        int retries = 3;
        int delayMs = 500;

        // Wait for APNS token to be set
        for (int i = 0; i < retries; i++) {
          try {
            apnsToken = await FirebaseMessaging.instance.getAPNSToken();
            if (apnsToken != null) {
              logger.d('APNS token available, proceeding to get FCM token');
              break;
            }
          } catch (e) {
            logger.d(
              'APNS token not available yet (attempt ${i + 1}/$retries): $e',
            );
          }

          if (apnsToken == null && i < retries - 1) {
            // Wait before retrying (exponential backoff)
            await Future.delayed(Duration(milliseconds: delayMs * (i + 1)));
          }
        }

        if (apnsToken == null) {
          logger.d(
            'APNS token not available yet. FCM token will be saved when APNS token is ready via onTokenRefresh.',
          );
          _setupTokenRefreshListener(userId);
          return;
        }
      }

      // Now get the FCM token (permissions granted and APNS token available on iOS)
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        final errorMessage = e.toString().toLowerCase();
        // Check for the specific APNS token error format
        if (errorMessage.contains('apns-token-not-set') ||
            (errorMessage.contains('apns') &&
                errorMessage.contains('not set'))) {
          logger.d(
            'FCM token error (APNS not set): $e. Token will be saved when available via onTokenRefresh.',
          );
          _setupTokenRefreshListener(userId);
          return;
        } else {
          // Different error, log and return gracefully - no errors thrown
          logger.d(
            'Error getting FCM token: $e. This is optional - app will continue without push notifications.',
          );
          _setupTokenRefreshListener(userId);
          return;
        }
      }

      if (fcmToken != null) {
        await FirebaseFirestore.instance
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .set({'fcmToken': fcmToken}, SetOptions(merge: true));
        logger.d('FCM token saved to Firestore for user: $userId');
      }

      // Setup token refresh listener for future updates
      _setupTokenRefreshListener(userId);
    } catch (e) {
      // Completely optional - don't throw errors, just log
      // User can decline notifications and app will work fine
      logger.d(
        'Error saving FCM token to Firestore (optional): $e. App will continue without push notifications.',
      );
      _setupTokenRefreshListener(userId);
    }
  }

  // Helper method to setup token refresh listener
  static void _setupTokenRefreshListener(String userId) {
    // Listen for token refresh - this will catch the token when APNS is ready
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      try {
        await FirebaseFirestore.instance
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .set({'fcmToken': newToken}, SetOptions(merge: true));
        logger.d(
          'FCM token refreshed and saved to Firestore for user: $userId',
        );
      } catch (e) {
        logger.e('Error saving refreshed FCM token: $e');
      }
    });
  }
}
