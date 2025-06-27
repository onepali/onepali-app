import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../src.dart';

class FAuthProvider with ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final SharedPreferencesService _sharedPrefs = SharedPreferencesService();
  final AuthState authState;

  FAuthProvider({required this.authState});

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

        // Authenticate with Firebase using Facebook access token
        final firebaseAuthCredential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );
        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          firebaseAuthCredential,
        );

        final firebaseUser = userCredential.user;

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
        final user = firebaseUser;
        if (user != null) {
          final userDocRef = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid);

          final userModel = UserModel(
            uid: user.uid,
            fullName: authState.fullName ?? fullName,
            email: userData['email'] ?? "",
            yearOfBirth: authState.yearOfBirth ?? 0,
            heardAbout: authState.heardAbout ?? "",
            learningReason: authState.learningReason ?? "",
            authProvider: AuthProviderType.facebook.name,
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
          // Save FCM token after Facebook login/registration
          await Utility.saveFcmTokenToFirestore(user.uid);
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
        showCustomToaster('Login Successful');
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
      await _sharedPrefs.setStringPref(AppConstants.refreshToken, "");
      await _sharedPrefs.setStringPref(AppConstants.userInfo, "");
      await _sharedPrefs.setBoolPref(AppConstants.logged, false);
      await _sharedPrefs.setBoolPref(AppConstants.parentDashboardLogged, false);
      _userData = null;

      // Reset AuthState
      authState.clear();

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
