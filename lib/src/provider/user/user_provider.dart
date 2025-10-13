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
        logger.e('❌ fetchOwnProfile: No current user authenticated');
        _status = DataFetchStatus.error;
        notifyListeners();
        return;
      }

      logger.d(
        '🔍 fetchOwnProfile: Fetching profile for user: ${currentUser.uid}',
      );
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .get();

      if (doc.exists) {
        logger.d('✅ fetchOwnProfile: Document exists, parsing user data');
        final data = doc.data();
        logger.d('📄 fetchOwnProfile: Raw document data: $data');

        if (data!['uid'] == null) {
          data['uid'] = currentUser.uid;
        }

        _user = UserModel.fromJson(data);
        _userId = _user?.uid;
        logger.d(
          '✅ fetchOwnProfile: User fetched successfully: ${_user?.toJson()}',
        );
        _status = DataFetchStatus.success;
      } else {
        logger.w(
          '⚠️ fetchOwnProfile: Document does not exist for user: ${currentUser.uid}',
        );
        _user = null;
        _status = DataFetchStatus.error;
      }
      notifyListeners();
    } catch (e, stackTrace) {
      logger.e('❌ fetchOwnProfile: Error fetching user profile: $e');
      logger.e('📍 fetchOwnProfile: Stack trace: $stackTrace');
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

  /// Check if parent has completed required profile details
  bool hasCompleteProfile() {
    if (_user == null) return false;

    // Check required fields
    final hasValidName = _user != null && _user!.fullName.trim().isNotEmpty;
    final hasValidEmail = _user != null && _user!.email.trim().isNotEmpty;
    final hasValidYearOfBirth =
        _user != null && _user!.yearOfBirth > 0 && _user!.yearOfBirth >= 1900;

    logger.d('Parent profile validation:');
    logger.d(
      '  - Name: ${hasValidName ? "✓" : "✗"} (${_user?.fullName ?? "N/A"})',
    );
    logger.d(
      '  - Email: ${hasValidEmail ? "✓" : "✗"} (${_user?.email ?? "N/A"})',
    );
    logger.d(
      '  - Year of birth: ${hasValidYearOfBirth ? "✓" : "✗"} (${_user?.yearOfBirth ?? "N/A"})',
    );

    return hasValidName && hasValidEmail && hasValidYearOfBirth;
  }

  /// Get list of missing required fields
  List<String> getMissingFields() {
    if (_user == null) return ['All profile information'];

    final List<String> missing = [];

    if (_user!.fullName.trim().isEmpty) {
      missing.add('Full Name');
    }
    if (_user!.email.trim().isEmpty) {
      missing.add('Email');
    }
    if (_user!.yearOfBirth <= 0 || _user!.yearOfBirth < 1900) {
      missing.add('Year of Birth');
    }

    return missing;
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String email,
    int? yearOfBirth,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      showCustomToaster('User not signed in.', isError: true);
      return;
    }
    try {
      final Map<String, dynamic> updateData = {
        'fullName': fullName,
        'email': email,
      };

      // Only update yearOfBirth if provided
      if (yearOfBirth != null) {
        updateData['yearOfBirth'] = yearOfBirth;
      }

      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .update(updateData);

      if (_user != null) {
        _user = UserModel(
          uid: _user!.uid,
          fullName: fullName,
          email: email,
          yearOfBirth: yearOfBirth ?? _user!.yearOfBirth,
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
