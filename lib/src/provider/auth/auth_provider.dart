import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../src.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final AuthState authState;
  AuthProvider({required this.authState});

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

      // Send email verification after sign up
      if (_user != null && !_user!.emailVerified) {
        await _user!.sendEmailVerification();
      }

      setStatus(DataFetchStatus.success);
      notifyListeners();
      if (!context.mounted) return;
      CustomToast.showToast(
        context,
        "Registration successful! Please verify your email.",
      );
    } on FirebaseAuthException catch (e) {
      setStatus(DataFetchStatus.initial);
      CustomToast.showToast(
        context,
        e.message ?? "Registration failed",
        isError: true,
      );
    }
  }

  Future<dynamic> loginWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    setStatus(DataFetchStatus.loading);
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;

      if (_user != null && !_user!.emailVerified) {
        setStatus(DataFetchStatus.success);
        notifyListeners();
        return 'not_verified';
      }

      // Save user info and tokens
      final SharedPreferencesService sharedPrefs = SharedPreferencesService();
      final String? accessToken = await _user?.getIdToken();
      final Map<String, dynamic> userInfo = {
        'full_name': _user?.displayName ?? authState.fullName ?? "",
        'email': _user?.email ?? "",
        'user_dp': _user?.photoURL ?? "",
        'login_type': AuthProviderType.email.name,
        'access_token': accessToken ?? "",
        'refresh_token': _user?.refreshToken ?? "",
      };
      logger.d('userInfo---> $userInfo');
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

      // Save UserModel to Firestore
      if (_user != null) {
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid);

        final userModel = UserModel(
          uid: _user!.uid,
          fullName: authState.fullName ?? "",
          email: _user!.email ?? "",
          yearOfBirth: authState.yearOfBirth ?? 0,
          heardAbout: authState.heardAbout ?? "",
          learningReason: authState.learningReason ?? "",
          authProvider: AuthProviderType.email.name,
          createdAt: DateTime.now().toIso8601String(),
        );
        logger.d('userModel---> ${userModel.toJson()}');

        final docSnapshot = await userDocRef.get();
        if (docSnapshot.exists) {
          // Update only missing or empty fields
          final data = docSnapshot.data() as Map<String, dynamic>;
          final Map<String, dynamic> updateData = {};

          if ((data['full_name'] == null ||
                  (data['full_name'] as String).isEmpty) &&
              userModel.fullName.isNotEmpty) {
            updateData['full_name'] = userModel.fullName;
          }
          if ((data['year_of_birth'] == null || data['year_of_birth'] == 0) &&
              userModel.yearOfBirth != 0) {
            updateData['year_of_birth'] = userModel.yearOfBirth;
          }
          if ((data['heard_about'] == null ||
                  (data['heard_about'] as String).isEmpty) &&
              userModel.heardAbout.isNotEmpty) {
            updateData['heard_about'] = userModel.heardAbout;
          }
          if ((data['learning_reason'] == null ||
                  (data['learning_reason'] as String).isEmpty) &&
              userModel.learningReason.isNotEmpty) {
            updateData['learning_reason'] = userModel.learningReason;
          }
          // Always update authProvider if missing
          if ((data['auth_provider'] == null ||
              (data['auth_provider'] as String).isEmpty)) {
            updateData['auth_provider'] = userModel.authProvider;
          }
          // Optionally update createdAt if missing
          if (data['created_at'] == null) {
            updateData['created_at'] = userModel.createdAt;
          }

          if (updateData.isNotEmpty) {
            logger.d('Firestore updateData ---> ${json.encode(updateData)}');
            await userDocRef.update(updateData);
          }
        } else {
          // Create new document
          logger.d(
            'Firestore set userModel ---> ${json.encode(userModel.toJson())}',
          );
          await userDocRef.set(userModel.toJson());
        }
      }

      setStatus(DataFetchStatus.success);
      notifyListeners();
      if (!context.mounted) return true;
      CustomToast.showToast(context, "Login successful!");
      return true;
    } on FirebaseAuthException catch (e) {
      setStatus(DataFetchStatus.initial);
      CustomToast.showToast(
        context,
        e.message ?? "Login failed",
        isError: true,
      );
      return false;
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

  /// Resend email verification to the current user.
  Future<void> resendEmailVerification(BuildContext context) async {
    if (_user != null && !_user!.emailVerified) {
      try {
        await _user!.sendEmailVerification();
        if (!context.mounted) return;
        CustomToast.showToast(context, "Verification email resent!");
      } catch (e) {
        CustomToast.showToast(
          context,
          "Failed to resend verification email",
          isError: true,
        );
      }
    } else {
      if (!context.mounted) return;
      CustomToast.showToast(
        context,
        "Email already verified or user not found.",
        isError: true,
      );
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

    // Reset AuthState
    authState.clear();

    setStatus(DataFetchStatus.initial);
    notifyListeners();
    if (!context.mounted) return;
    CustomToast.showToast(context, "Logged out");
    Utility.navigate(context, AppRoutes.splashScreen);
  }
}
