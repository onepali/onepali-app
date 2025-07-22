import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class GuestUtil {
  static bool? _isGuestUser;

  static Future<void> init() async {
    _isGuestUser = await ChildLocalStorage.getGuestLogged();
  }

  static bool isGuestUser() {
    return _isGuestUser ?? false;
  }

  static Future<void> setGuestUser(bool value) async {
    await ChildLocalStorage.setGuestLogged(value);
    _isGuestUser = value;
  }

  static void showGuestAccountPrompt(BuildContext context) {
    DialogManager.showCustomDialog(
      context: context,
      title: 'Save your progress and unlock more lessons!',
      content: '',
      isCross: true,
      image: Assets.guestAvatar,
      isSvg: true,
      onConfirm: () {
        Utility.navigate(context, AppRoutes.registerScreen);
      },
      confirmButtonText: 'Create account',
      barrierDismissible: true,
      hasSingleButton: true,
    );
  }
}
