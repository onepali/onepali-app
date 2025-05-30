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
      showCustomToaster("Registration successful! Please verify your email.");
    } on FirebaseAuthException catch (e) {
      setStatus(DataFetchStatus.initial);
      if (e.code == 'email-already-in-use') {
        showCustomToaster(
          "Email is already in use. Please use a different email.",
          isError: true,
        );
      } else {
        showCustomToaster(e.message ?? "Registration failed", isError: true);
      }
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
      showCustomToaster("Login successful!");
      return true;
    } on FirebaseAuthException catch (e) {
      setStatus(DataFetchStatus.initial);
      showCustomToaster(e.message ?? "Login failed", isError: true);
      return false;
    }
  }

  /// Simple sign in method: handles login, verification, error handling, and navigation.
  Future<void> signIn(
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
        // Navigate to verification screen
        if (!context.mounted) return;
        Utility.navigateMaterialRoute(context, RS5Screen(isLogin: true));
        showCustomToaster("Please verify your email.", isError: true);
        return;
      }

      // Save user info and tokens to SharedPreferences
      final SharedPreferencesService sharedPrefs = SharedPreferencesService();
      final String? accessToken = await _user?.getIdToken();
      final Map<String, dynamic> userInfo = {
        'full_name': _user?.displayName,
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

      setStatus(DataFetchStatus.success);
      notifyListeners();
      if (!context.mounted) return;
      showCustomToaster("Login successful!");
      Utility.navigate(context, AppRoutes.dashboardScreen);
    } on FirebaseAuthException catch (e) {
      logger.e("FirebaseAuthException: ${e.code}");
      setStatus(DataFetchStatus.initial);
      if (e.code == 'user-not-found') {
        showCustomToaster("User or account not found", isError: true);
      } else if (e.code == 'invalid-credential') {
        showCustomToaster(
          "Invalid credentials, please try again",
          isError: true,
        );
      } else if (e.code == 'account-exists-with-different-credential') {
        showCustomToaster(
          "Account exists with different credentials",
          isError: true,
        );
      } else {
        showCustomToaster(e.message ?? "Login failed", isError: true);
      }
    } catch (e) {
      setStatus(DataFetchStatus.initial);
      showCustomToaster("Login failed", isError: true);
    }
  }

  /// New register method: handles registration, user data update, prefs, navigation, and error handling.
  Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String fullName,
    int? yearOfBirth,
    String? heardAbout,
    String? learningReason,
  }) async {
    setStatus(DataFetchStatus.loading);
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;

      // Send email verification
      if (_user != null && !_user!.emailVerified) {
        await _user!.sendEmailVerification();
      }

      // Save user info and tokens to SharedPreferences
      final SharedPreferencesService sharedPrefs = SharedPreferencesService();
      final String? accessToken = await _user?.getIdToken();
      final Map<String, dynamic> userInfo = {
        'full_name': fullName,
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
          fullName: fullName,
          email: _user!.email ?? "",
          yearOfBirth: yearOfBirth ?? 0,
          heardAbout: heardAbout ?? "",
          learningReason: learningReason ?? "",
          authProvider: AuthProviderType.email.name,
          createdAt: DateTime.now().toIso8601String(),
        );
        logger.d('userModel---> ${userModel.toJson()}');

        await userDocRef.set(userModel.toJson(), SetOptions(merge: true));
      }

      setStatus(DataFetchStatus.success);
      notifyListeners();
      if (!context.mounted) return;
      showCustomToaster("Registration successful! Please verify your email.");
      Utility.navigate(context, AppRoutes.rs5Screen);
    } on FirebaseAuthException catch (e) {
      setStatus(DataFetchStatus.initial);
      String errorMsg;
      switch (e.code) {
        case 'email-already-in-use':
          errorMsg = "Email is already in use. Please use a different email.";
          break;
        case 'invalid-email':
          errorMsg = "Invalid email address.";
          break;
        case 'weak-password':
          errorMsg = "Password is too weak.";
          break;
        case 'operation-not-allowed':
          errorMsg = "Operation not allowed. Please contact support.";
          break;
        default:
          errorMsg = e.message ?? "Registration failed";
      }
      showCustomToaster(errorMsg, isError: true);
    } catch (e) {
      setStatus(DataFetchStatus.initial);
      showCustomToaster("Registration failed", isError: true);
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    if (_user != null && !_user!.emailVerified) {
      try {
        await _user!.sendEmailVerification();
        if (!context.mounted) return;
        showCustomToaster("Verification email sent!");
      } catch (e) {
        showCustomToaster("Failed to send verification email", isError: true);
      }
    }
  }

  /// Resend email verification to the current user.
  Future<void> resendEmailVerification(BuildContext context) async {
    if (_user != null && !_user!.emailVerified) {
      try {
        await _user!.sendEmailVerification();
        if (!context.mounted) return;
        showCustomToaster("Verification email resent!");
      } catch (e) {
        showCustomToaster("Failed to resend verification email", isError: true);
      }
    } else {
      if (!context.mounted) return;
      showCustomToaster(
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
    showCustomToaster("Logged out");
    Utility.navigate(context, AppRoutes.loginScreen);
  }
}
