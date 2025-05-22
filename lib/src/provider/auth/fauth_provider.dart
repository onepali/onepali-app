import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../src.dart';

class FacebookAuthProvider with ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final SharedPreferencesService _sharedPrefs = SharedPreferencesService();
  final AuthState authState;

  FacebookAuthProvider({required this.authState});

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  Future<void> signInWithFacebook(BuildContext context) async {
    setStatus(DataFetchStatus.loading);

    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final userData = await FacebookAuth.instance.getUserData();
        _userData = userData;

        // Prepare user info map
        final String fullName = userData['name'] ?? '';

        final Map<String, dynamic> userInfo = {
          'full_name': fullName,
          'email': userData['email'] ?? '',
          'user_dp': userData['picture']?['data']?['url'] ?? '',
          'login_type': AppConstants.facebook,
          'access_token': accessToken.tokenString,
        };

        await _sharedPrefs.setStringPref(
          AppConstants.accessToken,
          accessToken.tokenString,
        );
        await _sharedPrefs.setStringPref(
          AppConstants.userInfo,
          json.encode(userInfo),
        );
        await _sharedPrefs.setBoolPref(AppConstants.logged, true);

        // Save UserModel to Firestore
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userModel = UserModel(
            uid: user.uid,
            fullName: authState.fullName ?? fullName,
            email: userData['email'] ?? "",
            yearOfBirth: authState.yearOfBirth ?? 0,
            heardAbout: authState.heardAbout ?? "",
            learningReason: authState.learningReason ?? "",
            authProvider: AuthProviderType.facebook.name,
            createdAt: DateTime.now(),
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userModel.toJson());
        }

        logger.d('Facebook accessToken---> ${accessToken.tokenString}');
        logger.d(
          'logged---> ${await _sharedPrefs.getBoolPref(AppConstants.logged)}',
        );

        if (!context.mounted) return;
        _status = DataFetchStatus.success;
        notifyListeners();

        if (!context.mounted) return;
        onNavigate(context);
        CustomToast.showToast(context, 'Login Successful');
        return;
      } else if (result.status == LoginStatus.cancelled) {
        if (!context.mounted) return;
        handleError("Facebook login cancelled.", context);
      } else {
        if (!context.mounted) return;

        handleError(result.message ?? "Facebook login failed.", context);
      }
    } on PlatformException catch (e) {
      _handlePlatformException(context, e);
    } catch (e, s) {
      logger.e('error---> $e ----> stack --> $s');
      handleError(e is String ? e : e.toString(), context);
    } finally {
      setStatus(DataFetchStatus.initial);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FacebookAuth.instance.logOut();

      await _sharedPrefs.setStringPref(AppConstants.accessToken, "");
      await _sharedPrefs.setStringPref(AppConstants.userInfo, "");
      await _sharedPrefs.setBoolPref(AppConstants.logged, false);
      _userData = null;
      setStatus(DataFetchStatus.initial);
      notifyListeners();
      if (!context.mounted) return;
      CustomToast.showToast(context, "Signed out successfully.");
    } catch (e) {
      CustomToast.showToast(context, "Failed to sign out.", isError: true);
    }
  }

  onNavigate(context) {
    Utility.navigate(context, AppRoutes.dashboardScreen);
  }

  void _handlePlatformException(BuildContext context, PlatformException e) {
    String message = "An error occurred: ${e.message}";
    handleError(message, context);
  }

  setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  void handleError(String msg, context) {
    return CustomToast.showToast(context, msg, isError: true);
  }
}
