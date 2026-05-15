import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../src.dart';

class AAuthProvider with ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final SharedPreferencesService _sharedPrefs = SharedPreferencesService();
  final AuthState authState;

  AAuthProvider({required this.authState});

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  Future<void> signInWithApple(BuildContext context) async {
    setStatus(DataFetchStatus.loading);

    try {
      // Request Apple Sign In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuth credential from Apple ID token
      // For Firebase, we only need the idToken (not authorizationCode)
      final oauthCredential = firebase_auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with Apple credential
      final userCredential = await firebase_auth.FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );

      final firebaseUser = userCredential.user;

      // Prepare user info map
      final String fullName = appleCredential.givenName != null &&
              appleCredential.familyName != null
          ? '${appleCredential.givenName} ${appleCredential.familyName}'
          : appleCredential.givenName ??
              appleCredential.familyName ??
              firebaseUser?.displayName ??
              '';

      final Map<String, dynamic> userInfo = {
        'full_name': fullName,
        'email': appleCredential.email ?? firebaseUser?.email ?? '',
        'user_dp': firebaseUser?.photoURL ?? '',
        'login_type': AppConstants.apple,
        'access_token': appleCredential.identityToken ?? '',
      };

      await _sharedPrefs.setStringPref(
        AppConstants.accessToken,
        appleCredential.identityToken ?? '',
      );
      await _sharedPrefs.setStringPref(
        AppConstants.userInfo,
        json.encode(userInfo),
      );
      await _sharedPrefs.setBoolPref(AppConstants.logged, true);
      // Reset parent login status on new login - user must verify passcode again
      await _sharedPrefs.setBoolPref(AppConstants.parentDashboardLogged, false);

      // Save UserModel to Firestore
      final user = firebaseUser;
      if (user != null) {
        final userDocRef = FirebaseFirestore.instance
            .collection(AppConstants.usersCollection)
            .doc(user.uid);

        final userModel = UserModel(
          uid: user.uid,
          fullName: authState.fullName ?? fullName,
          email: appleCredential.email ?? user.email ?? "",
          yearOfBirth: authState.yearOfBirth ?? 0,
          heardAbout: authState.heardAbout ?? "",
          learningReason: authState.learningReason ?? "",
          authProvider: AuthProviderType.apple.name,
          createdAt: DateTime.now().toIso8601String(),
        );
        logger.d('userModel---> ${userModel.toJson()}');

        final docSnapshot = await userDocRef.get();
        if (docSnapshot.exists) {
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
          if ((data['auth_provider'] == null ||
              (data['auth_provider'] as String).isEmpty)) {
            updateData['auth_provider'] = userModel.authProvider;
          }
          if (data['created_at'] == null) {
            updateData['created_at'] = userModel.createdAt;
          }

          if (updateData.isNotEmpty) {
            logger.d('Firestore updateData ---> ${json.encode(updateData)}');
            await userDocRef.update(updateData);
          }
        } else {
          logger.d(
            'Firestore set userModel ---> ${json.encode(userModel.toJson())}',
          );
          await userDocRef.set(userModel.toJson());
        }
        // Save FCM token after Apple login/registration
        await Utility.saveFcmTokenToFirestore(user.uid);
      }

      logger.d('Apple identityToken---> ${appleCredential.identityToken}');
      logger.d(
        'logged---> ${await _sharedPrefs.getBoolPref(AppConstants.logged)}',
      );

      if (!context.mounted) return;
      _status = DataFetchStatus.success;
      notifyListeners();

      if (!context.mounted) return;
      onNavigate(context);
      showCustomToaster('Login Successful');
      return;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (!context.mounted) return;
      logger.e('Apple Sign In AuthorizationException: code=${e.code}, message=${e.message}');
      
      if (e.code == AuthorizationErrorCode.canceled) {
        handleError("Apple Sign In cancelled.", context);
      } else if (e.code == AuthorizationErrorCode.unknown) {
        // Error 1000 - Unknown error
        logger.e('Apple Sign In Error 1000 (Unknown). Common causes: missing capability, provisioning profile, or 2FA not enabled.');
        handleError(
          "Apple Sign In failed. Please ensure Sign in with Apple is properly configured. Error: ${e.message}",
          context,
        );
      } else {
        handleError("Apple Sign In failed: ${e.message} (Code: ${e.code})", context);
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
      // Apple Sign In doesn't require explicit logout like Facebook
      // Just clear local data and Firebase sign out
      await firebase_auth.FirebaseAuth.instance.signOut();

      await _sharedPrefs.setStringPref(AppConstants.accessToken, "");
      await _sharedPrefs.setStringPref(AppConstants.refreshToken, "");
      await _sharedPrefs.setStringPref(AppConstants.userInfo, "");
      await _sharedPrefs.setBoolPref(AppConstants.logged, false);
      await _sharedPrefs.setBoolPref(AppConstants.parentDashboardLogged, false);
      _userData = null;

      // Reset AuthState
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

  void onNavigate(context) {
    Utility.navigate(context, AppRoutes.dashboardScreen);
  }

  void _handlePlatformException(BuildContext context, PlatformException e) {
    String message = "An error occurred: ${e.message}";
    handleError(message, context);
  }

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  void handleError(String msg, context) {
    return showCustomToaster(msg, isError: true);
  }
}

