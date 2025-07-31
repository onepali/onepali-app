import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../src.dart';

class GoogleAuthProvider with ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  final SharedPreferencesService _sharedPrefs = SharedPreferencesService();

  final AuthState authState;
  GoogleAuthProvider({required this.authState});

  Future<void> signInWithGoogle(
    BuildContext context, {
    bool isLogin = false,
  }) async {
    setStatus(DataFetchStatus.loading);

    try {
      final GoogleSignInAccount googleUser = await _signInWithGoogle(context);

      // Get authorization for required scopes
      final scopes = <String>["email", "profile", "openid"];
      final GoogleSignInClientAuthorization? authorization = await googleUser
          .authorizationClient
          .authorizationForScopes(scopes);
      if (authorization == null) {
        if (!context.mounted) return;
        handleError('Failed to retrieve authorization for scopes', context);
        return;
      }

      // Get ID token for Firebase
      final String? idToken = googleUser.authentication.idToken;
      final String accessToken = authorization.accessToken;
      logger.d('accessToken: $accessToken ---> idToken: $idToken');
      if (accessToken.isEmpty || idToken == null) {
        if (!context.mounted) return;
        handleError('Failed to retrieve access or ID token', context);
        return;
      }

      _user = googleUser;

      final firebase_auth.OAuthCredential credential = firebase_auth
          .GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth
          .instance
          .signInWithCredential(credential);
      final firebase_auth.User? firebaseUser = userCredential.user;

      if (!context.mounted) return;
      if (firebaseUser == null) {
        handleError('Firebase sign-in failed.', context);
        return;
      }

      final Map<String, dynamic> userInfo = {
        'full_name': googleUser.displayName,
        'email': googleUser.email,
        'user_dp':
            Utility.isAccessible(googleUser.photoUrl)
                ? googleUser.photoUrl!.replaceAll('=s96-c', '=s512-c')
                : "",
        'login_type': AuthProviderType.google.name,
        'access_token': accessToken,
      };

      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid);

      final userModel = UserModel(
        uid: firebaseUser.uid,
        fullName: authState.fullName ?? googleUser.displayName ?? "",
        email: googleUser.email,
        yearOfBirth: authState.yearOfBirth ?? 0,
        heardAbout: authState.heardAbout ?? "",
        learningReason: authState.learningReason ?? "",
        authProvider: AuthProviderType.google.name,
        createdAt: DateTime.now().toIso8601String(),
      );

      logger.d('userModel ---> ${userModel.toJson()}');

      if (!isLogin) {
        await userDocRef.set(userModel.toJson());
        // Save FCM token after registration
        await Utility.saveFcmTokenToFirestore(firebaseUser.uid);
      }

      if (isLogin) {
        await _sharedPrefs.setStringPref(AppConstants.accessToken, accessToken);
        await _sharedPrefs.setStringPref(
          AppConstants.userInfo,
          json.encode(userInfo),
        );
        await _sharedPrefs.setBoolPref(AppConstants.logged, true);
        // Save FCM token after login
        await Utility.saveFcmTokenToFirestore(firebaseUser.uid);
      }

      if (!context.mounted) return;

      _status = DataFetchStatus.success;
      notifyListeners();

      if (isLogin) {
        Utility.navigate(context, AppRoutes.dashboardScreen);
        showCustomToaster('Login Successful');
      } else {
        Utility.navigate(context, AppRoutes.onboardingScreen);
        showCustomToaster('Registration Successful');
      }
    } on PlatformException catch (e) {
      _handlePlatformException(context, e);
    } catch (e, s) {
      logger.e('error ---> $e ----> stack --> $s');
      handleError(e.toString(), context);
    } finally {
      setStatus(DataFetchStatus.initial);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await googleSignIn.signOut();
      await firebase_auth.FirebaseAuth.instance.signOut();
      logger.d('User signed out from Google and Firebase.');

      await _sharedPrefs.setStringPref(AppConstants.accessToken, "");
      await _sharedPrefs.setStringPref(AppConstants.userInfo, "");
      await _sharedPrefs.setBoolPref(AppConstants.logged, false);
      await _sharedPrefs.setBoolPref(AppConstants.parentDashboardLogged, false);

      _user = null;

      authState.clear();
      ChildLocalStorage.clear();
      ParentLocalStorage.clear();
      _sharedPrefs.clear();
      setStatus(DataFetchStatus.initial);
      notifyListeners();

      if (!context.mounted) return;
      showCustomToaster("Signed out successfully.");
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.onboardingScreen,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      showCustomToaster("Failed to sign out.", isError: true);
    }
  }

  void onNavigate(BuildContext context) {
    Utility.navigate(context, AppRoutes.dashboardScreen);
  }

  Future<GoogleSignInAccount> _signInWithGoogle(BuildContext context) async {
    try {
      return await googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      logger.e('error ---> $e');
      _handleGoogleSignInException(context, e);
      return Future.error(e);
    }
  }

  void _handlePlatformException(BuildContext context, PlatformException e) {
    String message = "An error occurred: ${e.message}";
    handleError(message, context);
  }

  void _handleGoogleSignInException(
    BuildContext context,
    GoogleSignInException e,
  ) {
    String message;
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        message = "Sign in cancelled.";
        break;
      default:
        message = "Sign in failed: ${e.description}";
    }
    handleError(message, context);
  }

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  void handleError(String msg, BuildContext context) {
    showCustomToaster(msg, isError: true);
  }
}
