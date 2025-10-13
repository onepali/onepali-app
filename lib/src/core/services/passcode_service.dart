import 'package:cloud_firestore/cloud_firestore.dart';

import '../../src.dart';

class PasscodeService {
  static Future<bool> savePasscode(
    String userId,
    PasscodeModel passcodeModel,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'passcode': passcodeModel.toMap()});

      logger.i('✅ Passcode saved successfully for user: $userId');
      return true;
    } catch (e) {
      logger.e('❌ Failed to save passcode: $e');
      return false;
    }
  }

  static Future<PasscodeModel?> getStoredPasscode(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data();
      if (data == null || !data.containsKey('passcode')) {
        return null;
      }

      final passcodeData = data['passcode'] as Map<String, dynamic>;
      return PasscodeModel.fromMap(passcodeData);
    } catch (e) {
      return null;
    }
  }

  static Future<PasscodeVerificationResult> verifyEnteredPasscode(
    String userId,
    String enteredPasscode,
  ) async {
    try {
      final storedPasscode = await getStoredPasscode(userId);

      if (storedPasscode == null) {
        return PasscodeVerificationResult.noPasscodeExists;
      }

      // Check if account is locked
      if (storedPasscode.isLocked) {
        final remaining = storedPasscode.lockTimeRemaining;
        return PasscodeVerificationResult.accountLocked(remaining);
      }

      // Verify passcode using utility
      final isValid = PasscodeUtility.verifyPasscode(
        enteredPasscode,
        storedPasscode.hash,
        storedPasscode.salt,
      );

      if (isValid) {
        if (storedPasscode.attempts > 0) {
          await _resetAttempts(userId, storedPasscode);
        }
        return PasscodeVerificationResult.success;
      } else {
        // Increment attempts and potentially lock account
        await _incrementAttempts(userId, storedPasscode);
        final newAttempts = storedPasscode.attempts + 1;
        final remainingAttempts = PasscodeUtility.calculateRemainingAttempts(
          newAttempts,
        );

        if (PasscodeUtility.shouldLockAccount(newAttempts)) {
          final lockDuration = PasscodeUtility.calculateLockoutDuration(
            newAttempts,
          );
          return PasscodeVerificationResult.accountLocked(lockDuration);
        } else {
          return PasscodeVerificationResult.invalidPasscode(
            attemptsRemaining: remainingAttempts,
          );
        }
      }
    } catch (e) {
      return PasscodeVerificationResult.error;
    }
  }

  /// Reset attempts after successful verification
  static Future<void> _resetAttempts(
    String userId,
    PasscodeModel passcode,
  ) async {
    try {
      final updatedPasscode = passcode.copyWith(
        attempts: 0,
        clearLockedUntil: true,
        updatedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'passcode': updatedPasscode.toMap()});
    } catch (e) {
      logger.e('Failed to reset attempts: $e');
    }
  }

  static Future<void> _incrementAttempts(
    String userId,
    PasscodeModel passcode,
  ) async {
    try {
      final newAttempts = passcode.attempts + 1;
      DateTime? lockUntil;

      if (PasscodeUtility.shouldLockAccount(newAttempts)) {
        final lockDuration = PasscodeUtility.calculateLockoutDuration(
          newAttempts,
        );
        lockUntil = DateTime.now().add(lockDuration);
      }

      final updatedPasscode = passcode.copyWith(
        attempts: newAttempts,
        lockedUntil: lockUntil,
        updatedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'passcode': updatedPasscode.toMap()});
    } catch (e) {
      logger.e('Failed to increment attempts: $e');
    }
  }

  /// Reset passcode using date of birth verification
  static Future<bool> resetPasscodeWithDateOfBirth(
    String userId,
    int yearOfBirth,
  ) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        return false;
      }

      final userData = userDoc.data();
      if (userData == null) {
        return false;
      }

      final storedYearOfBirth = userData['yearOfBirth'] as int?;
      if (storedYearOfBirth == null || storedYearOfBirth != yearOfBirth) {
        return false;
      }

      if (!PasscodeUtility.isValidYearOfBirth(yearOfBirth.toString())) {
        logger.w('⚠️ Invalid year of birth format for reset');
        return false;
      }

      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'passcode': FieldValue.delete()});

      return true;
    } catch (e) {
      logger.e('Failed to reset passcode: $e');
      return false;
    }
  }

  static Future<bool> hasPasscode(String userId) async {
    final passcode = await getStoredPasscode(userId);
    return passcode != null;
  }

  /// Update existing passcode
  static Future<bool> updatePasscode(
    String userId,
    String newPasscode, {
    PasscodeMode? mode,
  }) async {
    try {
      final existingPasscode = await getStoredPasscode(userId);
      if (existingPasscode == null) {
        return false;
      }

      final newPasscodeModel = PasscodeUtility.createPasscodeModel(
        newPasscode,
        mode: mode ?? existingPasscode.mode,
      );

      return await savePasscode(userId, newPasscodeModel);
    } catch (e) {
      return false;
    }
  }
}

/// Result class for passcode verification
class PasscodeVerificationResult {
  final bool isSuccess;
  final bool isLocked;
  final bool hasError;
  final bool passcodeExists;
  final int? attemptsRemaining;
  final Duration? lockDuration;
  final String? errorMessage;

  const PasscodeVerificationResult._({
    required this.isSuccess,
    required this.isLocked,
    required this.hasError,
    required this.passcodeExists,
    this.attemptsRemaining,
    this.lockDuration,
    this.errorMessage,
  });

  static const PasscodeVerificationResult success =
      PasscodeVerificationResult._(
        isSuccess: true,
        isLocked: false,
        hasError: false,
        passcodeExists: true,
      );

  static const PasscodeVerificationResult noPasscodeExists =
      PasscodeVerificationResult._(
        isSuccess: false,
        isLocked: false,
        hasError: false,
        passcodeExists: false,
      );

  static const PasscodeVerificationResult error = PasscodeVerificationResult._(
    isSuccess: false,
    isLocked: false,
    hasError: true,
    passcodeExists: true,
    errorMessage: AppConstants.passcodeErrorGeneral,
  );

  static PasscodeVerificationResult invalidPasscode({
    required int attemptsRemaining,
  }) {
    return PasscodeVerificationResult._(
      isSuccess: false,
      isLocked: false,
      hasError: false,
      passcodeExists: true,
      attemptsRemaining: attemptsRemaining,
    );
  }

  static PasscodeVerificationResult accountLocked(Duration? duration) {
    return PasscodeVerificationResult._(
      isSuccess: false,
      isLocked: true,
      hasError: false,
      passcodeExists: true,
      lockDuration: duration,
    );
  }
}
