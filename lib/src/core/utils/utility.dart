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
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .set({'fcmToken': fcmToken}, SetOptions(merge: true));
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .set({'fcmToken': newToken}, SetOptions(merge: true));
    });
  }
}
