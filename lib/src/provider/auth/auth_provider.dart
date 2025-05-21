import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../src.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  String? _verificationId;
  String? get verificationId => _verificationId;

  User? _user;
  User? get user => _user;

  setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> signUpWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    setStatus(DataFetchStatus.loading);
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      setStatus(DataFetchStatus.success);
      notifyListeners();
      if (!context.mounted) return;
      CustomToast.showToast(context, "Registration successful!");
    } on FirebaseAuthException catch (e) {
      setStatus(DataFetchStatus.initial);
      CustomToast.showToast(
        context,
        e.message ?? "Registration failed",
        isError: true,
      );
    }
  }

  Future<void> loginWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    setStatus(DataFetchStatus.loading);
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;

      // Save user info and tokens
      final SharedPreferencesService sharedPrefs = SharedPreferencesService();
      final Map<String, dynamic> userInfo = {
        'full_name': _user?.displayName ?? "",
        'email': _user?.email ?? "",
        'user_dp': _user?.photoURL ?? "",
        'login_type': "email",
        'access_token': await _user?.getIdToken(),
        'refresh_token': _user?.refreshToken ?? "",
      };
      await sharedPrefs.setStringPref(
        AppConstants.accessToken,
        userInfo['access_token'] ?? "",
      );
      await sharedPrefs.setStringPref(
        AppConstants.refreshToken,
        userInfo['refresh_token'] ?? "",
      );
      await sharedPrefs.setStringPref(
        AppConstants.userInfo,
        json.encode(userInfo),
      );
      await sharedPrefs.setBoolPref(AppConstants.logged, true);

      setStatus(DataFetchStatus.success);
      notifyListeners();
      if (!context.mounted) return;
      CustomToast.showToast(context, "Login successful!");
    } on FirebaseAuthException catch (e) {
      setStatus(DataFetchStatus.initial);
      CustomToast.showToast(
        context,
        e.message ?? "Login failed",
        isError: true,
      );
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    if (_user != null && !_user!.emailVerified) {
      try {
        await _user!.sendEmailVerification();
        if (!context.mounted) return;
        CustomToast.showToast(context, "Verification email sent!");
      } catch (e) {
        CustomToast.showToast(
          context,
          "Failed to send verification email",
          isError: true,
        );
      }
    }
  }

  Future<void> reloadUser() async {
    if (_user != null) {
      await _user!.reload();
      _user = _firebaseAuth.currentUser;
      notifyListeners();
    }
  }

  Future<bool> checkEmailVerified() async {
    await reloadUser();
    return _user?.emailVerified ?? false;
  }

  Future<void> logout(BuildContext context) async {
    await _firebaseAuth.signOut();
    _user = null;

    final SharedPreferencesService sharedPrefs = SharedPreferencesService();
    await sharedPrefs.setStringPref(AppConstants.accessToken, "");
    await sharedPrefs.setStringPref(AppConstants.refreshToken, "");
    await sharedPrefs.setStringPref(AppConstants.userInfo, "");
    await sharedPrefs.setBoolPref(AppConstants.logged, false);

    setStatus(DataFetchStatus.initial);
    notifyListeners();
    if (!context.mounted) return;
    CustomToast.showToast(context, "Logged out");
  }
}
