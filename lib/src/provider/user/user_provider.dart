import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src.dart';

class UserProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  UserModel? _user;

  DataFetchStatus get status => _status;
  UserModel? get user => _user;
  String? _userId;
  String? get userId => _userId;

  Future<void> fetchOwnProfile() async {
    _status = DataFetchStatus.loading;
    notifyListeners();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _status = DataFetchStatus.error;
        notifyListeners();
        return;
      }
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .get();
      if (doc.exists) {
        _user = UserModel.fromJson(doc.data()!);
        _userId = _user?.uid;
        logger.d('User fetched: ${_user?.toJson()}');
        _status = DataFetchStatus.success;
      } else {
        _user = null;
        _status = DataFetchStatus.error;
      }
      notifyListeners();
    } catch (e) {
      _user = null;
      _status = DataFetchStatus.error;
      notifyListeners();
    }
  }

  Future<bool> isMatchedPin(int pin) async {
    logger.d('Checking PIN match for user: ${_user?.yearOfBirth}, PIN: $pin');
    if (_user == null) {
      logger.w('User not fetched yet, cannot check PIN match');
      showCustomToaster(
        'User not fetched yet. Please try again later.',
        isError: true,
      );
      return false;
    }
    // Check if pin is a valid year and matches user's yearOfBirth
    if (pin < 1900 || pin > DateTime.now().year || _user!.yearOfBirth != pin) {
      showCustomToaster('Invalid PIN. Please try again.', isError: true);
      logger.w('Invalid PIN: $pin');
      return false;
    }
    logger.d('PIN match: true');
    return true;
  }

  // ===== PASSCODE METHODS =====

  /// Check if user has a passcode set
  Future<bool> hasPasscode() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;
    return await PasscodeService.hasPasscode(currentUser.uid);
  }

  Future<PasscodeModel?> getStoredPasscode() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;
    return await PasscodeService.getStoredPasscode(currentUser.uid);
  }

  Future<bool> createPasscode(
    String passcode, {
    PasscodeMode mode = PasscodeMode.digits4,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      showCustomToaster('User not authenticated.', isError: true);
      return false;
    }

    try {
      final passcodeModel = PasscodeUtility.createPasscodeModel(
        passcode,
        mode: mode,
      );
      final success = await PasscodeService.savePasscode(
        currentUser.uid,
        passcodeModel,
      );

      if (success) {
        showCustomToaster(AppConstants.passcodeSuccessCreated);
        logger.i('✅ Passcode created for user: ${currentUser.uid}');
      } else {
        showCustomToaster(AppConstants.passcodeErrorSave, isError: true);
        logger.e('❌ Failed to create passcode for user: ${currentUser.uid}');
      }

      return success;
    } catch (e) {
      showCustomToaster(AppConstants.passcodeErrorSave, isError: true);
      logger.e('❌ Error creating passcode: $e');
      return false;
    }
  }

  /// Verify entered passcode
  Future<PasscodeVerificationResult> verifyPasscode(
    String enteredPasscode,
  ) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return PasscodeVerificationResult.error;
    }

    return await PasscodeService.verifyEnteredPasscode(
      currentUser.uid,
      enteredPasscode,
    );
  }

  /// Update existing passcode
  Future<bool> updatePasscode(String newPasscode, {PasscodeMode? mode}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      showCustomToaster('User not authenticated.', isError: true);
      return false;
    }

    try {
      final success = await PasscodeService.updatePasscode(
        currentUser.uid,
        newPasscode,
        mode: mode,
      );

      if (success) {
        showCustomToaster(AppConstants.passcodeSuccessUpdated);
        logger.i('✅ Passcode updated for user: ${currentUser.uid}');
      } else {
        showCustomToaster(AppConstants.passcodeErrorUpdate, isError: true);
        logger.e('❌ Failed to update passcode for user: ${currentUser.uid}');
      }

      return success;
    } catch (e) {
      showCustomToaster(AppConstants.passcodeErrorUpdate, isError: true);
      logger.e('❌ Error updating passcode: $e');
      return false;
    }
  }

  /// Reset passcode using date of birth
  Future<bool> resetPasscodeWithBirth(int yearOfBirth) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      showCustomToaster('User not authenticated.', isError: true);
      return false;
    }

    try {
      // Reset the passcode using the service
      final success = await PasscodeService.resetPasscodeWithDateOfBirth(
        currentUser.uid,
        yearOfBirth,
      );

      if (success) {
        showCustomToaster(AppConstants.passcodeSuccessReset);
        logger.i('✅ Passcode reset for user: ${currentUser.uid}');
      } else {
        showCustomToaster(AppConstants.passcodeErrorInvalidYear, isError: true);
        logger.e('❌ Failed to reset passcode for user: ${currentUser.uid}');
      }

      return success;
    } catch (e) {
      showCustomToaster(AppConstants.passcodeErrorReset, isError: true);
      logger.e('❌ Error resetting passcode: $e');
      return false;
    }
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String email,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      showCustomToaster('User not signed in.', isError: true);
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .update({'fullName': fullName, 'email': email});
      if (_user != null) {
        _user = UserModel(
          uid: _user!.uid,
          fullName: fullName,
          email: email,
          yearOfBirth: _user!.yearOfBirth,
          heardAbout: _user!.heardAbout,
          learningReason: _user!.learningReason,
          authProvider: _user!.authProvider,
          createdAt: _user!.createdAt,
        );
      }
      notifyListeners();
      showCustomToaster('Profile updated successfully.');
    } catch (e) {
      showCustomToaster('Failed to update profile.', isError: true);
    }
  }
}


// pin > DateTime.now().year ||