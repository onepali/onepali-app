import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../src.dart';

class GoogleAuthProvider with ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  final SharedPreferencesService _sharedPrefs = SharedPreferencesService();

  final AuthState authState;
  GoogleAuthProvider({required this.authState});

  Future<void> signInWithGoogle(context) async {
    setStatus(DataFetchStatus.loading);

    try {
      final GoogleSignInAccount? googleUser = await _signInWithGoogle(context);
      logger.d('googleUser: $googleUser');
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      logger.d(
        'accessToken: $accessToken   ---> idToken ${googleAuth.idToken}',
      );
      if (accessToken == null) {
        handleError('Failed to retrieve ID token', context);
        return;
      }

      _user = googleUser;

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

      await _sharedPrefs.setStringPref(AppConstants.accessToken, accessToken);
      await _sharedPrefs.setStringPref(
        AppConstants.userInfo,
        json.encode(userInfo),
      );
      await _sharedPrefs.setBoolPref(AppConstants.logged, true);

      // Save UserModel to Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);

        final userModel = UserModel(
          uid: user.uid,
          fullName: authState.fullName ?? googleUser.displayName ?? "",
          email: googleUser.email,
          yearOfBirth: authState.yearOfBirth ?? 0,
          heardAbout: authState.heardAbout ?? "",
          learningReason: authState.learningReason ?? "",
          authProvider: AuthProviderType.google.name,
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
            // Convert DateTime to String for JSON encoding if present
            if (updateData['created_at'] is DateTime) {
              updateData['created_at'] =
                  (updateData['created_at'] as DateTime).toIso8601String();
            }
            logger.d('Firestore updateData ---> ${json.encode(updateData)}');
            await userDocRef.update(updateData);
          }
          // Convert DateTime to String for JSON encoding
          final userJson = userModel.toJson();
          if (userJson['created_at'] is DateTime) {
            userJson['created_at'] =
                (userJson['created_at'] as DateTime).toIso8601String();
          }
          await userDocRef.set(userJson);
          logger.d(
            'Firestore set userModel ---> ${json.encode(userModel.toJson())}',
          );
          await userDocRef.set(userModel.toJson());
        }
      }

      logger.d('accessToken---> $accessToken');
      logger.d(
        'logged---> ${await _sharedPrefs.getBoolPref(AppConstants.logged)}',
      );

      if (!context.mounted) return;
      _status = DataFetchStatus.success;
      notifyListeners();

      if (!context.mounted) return;
      onNavigate(context);
      showCustomToaster( 'Login Successful');
      return;
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
      await googleSignIn.signOut();
      await _sharedPrefs.setStringPref(AppConstants.accessToken, "");
      await _sharedPrefs.setStringPref(AppConstants.userInfo, "");
      await _sharedPrefs.setBoolPref(AppConstants.logged, false);
      _user = null;

      // Reset AuthState
      authState.clear();

      setStatus(DataFetchStatus.initial);
      notifyListeners();
      if (!context.mounted) return;
      showCustomToaster( "Signed out successfully.");
      Utility.navigate(context, AppRoutes.splashScreen);
    } catch (e) {
      showCustomToaster( "Failed to sign out.", isError: true);
    }
  }

  onNavigate(context) {
    Utility.navigate(context, AppRoutes.dashboardScreen);
  }

  Future<GoogleSignInAccount?> _signInWithGoogle(context) async {
    try {
      return await googleSignIn.signIn();
    } on PlatformException catch (e, s) {
      logger.e('error---> $e ---- --> stack --> $s');
      _handlePlatformException(context, e);
      return null;
    }
  }

  void _handlePlatformException(BuildContext context, PlatformException e) {
    String message = "An error occurred: ${e.message}";
    if (e.code == GoogleSignIn.kSignInCanceledError) {
      message = "Sign in cancelled.";
    } else if (e.code == GoogleSignIn.kSignInFailedError) {
      message = "Sign in failed.";
    }
    handleError(message, context);
  }

  setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  void handleError(String msg, context) {
    return showCustomToaster( msg, isError: true);
  }
}
