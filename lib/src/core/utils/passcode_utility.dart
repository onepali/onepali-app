import 'dart:convert';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';

import '../../src.dart';

/// Utility class for passcode operations
/// Handles hashing, validation, and security-related operations
class PasscodeUtility {
  /// Generate a cryptographically secure random salt
  static String generateSalt() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random.secure();
    return List.generate(
      AppConstants.passcodeSaltLength,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Hash a passcode with salt using SHA-256
  static String hashPasscode(String passcode, String salt) {
    final saltedPasscode = '$passcode$salt';
    final bytes = utf8.encode(saltedPasscode);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify a passcode against stored hash
  static bool verifyPasscode(
    String enteredPasscode,
    String storedHash,
    String salt,
  ) {
    final enteredHash = hashPasscode(enteredPasscode, salt);
    return enteredHash == storedHash;
  }

  /// Create a new passcode model with secure hash and salt
  static PasscodeModel createPasscodeModel(
    String passcode, {
    PasscodeMode mode = PasscodeMode.digits4,
  }) {
    final salt = generateSalt();
    final hash = hashPasscode(passcode, salt);
    final now = DateTime.now();

    return PasscodeModel(
      hash: hash,
      salt: salt,
      createdAt: now,
      updatedAt: now,
      mode: mode,
    );
  }

  /// Validate passcode format
  static bool isValidPasscodeFormat(String passcode, PasscodeMode mode) {
    if (passcode.isEmpty) return false;

    // Check if passcode contains only digits
    if (!RegExp(r'^\d+$').hasMatch(passcode)) return false;

    // Check length based on mode
    switch (mode) {
      case PasscodeMode.digits4:
        return passcode.length == AppConstants.passcodeDefaultLength;
      case PasscodeMode.digits6:
        return passcode.length == AppConstants.passcodeAlternateLength;
    }
  }

  /// Validate year of birth format
  static bool isValidYearOfBirth(String year) {
    if (year.isEmpty || year.length != 4) return false;

    final yearInt = int.tryParse(year);
    if (yearInt == null) return false;

    final currentYear = DateTime.now().year;
    return yearInt >= 1900 && yearInt <= currentYear;
  }

  /// Calculate lockout duration based on attempt number
  static Duration calculateLockoutDuration(int attemptNumber) {
    final lockoutIndex = math.min(
      attemptNumber - AppConstants.passcodeMaxAttempts,
      AppConstants.passcodeLockoutDurations.length - 1,
    );

    final seconds = AppConstants.passcodeLockoutDurations[lockoutIndex];
    return Duration(seconds: seconds);
  }

  /// Format lockout duration for display
  static String formatLockoutDuration(Duration? lockDuration) {
    if (lockDuration == null) return AppConstants.passcodeErrorLocked;

    final minutes = lockDuration.inMinutes;
    final seconds = lockDuration.inSeconds % 60;

    if (minutes > 0) {
      return 'Account locked for ${minutes}m ${seconds}s. Please try again later.';
    } else {
      return 'Account locked for ${seconds}s. Please try again later.';
    }
  }

  /// Generate error message for invalid attempts
  static String formatAttemptsRemainingMessage(int attemptsRemaining) {
    if (attemptsRemaining <= 0) {
      return 'No attempts remaining. Account will be locked.';
    } else if (attemptsRemaining == 1) {
      return 'Invalid passcode. 1 attempt remaining.';
    } else {
      return 'Invalid passcode. $attemptsRemaining attempts remaining.';
    }
  }

  /// Check if account should be locked based on attempts
  static bool shouldLockAccount(int currentAttempts) {
    return currentAttempts >= AppConstants.passcodeMaxAttempts;
  }

  /// Calculate remaining attempts
  static int calculateRemainingAttempts(int currentAttempts) {
    return math.max(0, AppConstants.passcodeMaxAttempts - currentAttempts);
  }

  /// Validate passcode strength (basic validation)
  static PasscodeStrength validatePasscodeStrength(String passcode) {
    if (passcode.length < AppConstants.passcodeDefaultLength) {
      return PasscodeStrength.tooShort;
    }

    // Check for sequential numbers (1234, 4321)
    if (_isSequential(passcode)) {
      return PasscodeStrength.sequential;
    }

    // Check for repeated digits (1111, 2222)
    if (_isRepeated(passcode)) {
      return PasscodeStrength.repeated;
    }

    // Check for common patterns
    if (_isCommonPattern(passcode)) {
      return PasscodeStrength.common;
    }

    return PasscodeStrength.good;
  }

  /// Check if passcode is sequential
  static bool _isSequential(String passcode) {
    if (passcode.length < 3) return false;

    final digits = passcode.split('').map(int.parse).toList();

    // Check ascending sequence
    bool isAscending = true;
    bool isDescending = true;

    for (int i = 1; i < digits.length; i++) {
      if (digits[i] != digits[i - 1] + 1) isAscending = false;
      if (digits[i] != digits[i - 1] - 1) isDescending = false;
    }

    return isAscending || isDescending;
  }

  /// Check if passcode has repeated digits
  static bool _isRepeated(String passcode) {
    if (passcode.isEmpty) return false;
    return passcode.split('').every((digit) => digit == passcode[0]);
  }

  /// Check if passcode is a common pattern
  static bool _isCommonPattern(String passcode) {
    const commonPatterns = [
      '0000',
      '1111',
      '2222',
      '3333',
      '4444',
      '5555',
      '6555',
      '7777',
      '8888',
      '9999',
      '1234',
      '4321',
      '2468',
      '1357',
      '0123',
      '3210',
    ];
    return commonPatterns.contains(passcode);
  }
}

/// Enum for passcode strength validation
enum PasscodeStrength { tooShort, sequential, repeated, common, good }

extension PasscodeStrengthExtension on PasscodeStrength {
  String get message {
    switch (this) {
      case PasscodeStrength.tooShort:
        return 'Passcode is too short';
      case PasscodeStrength.sequential:
        return 'Avoid sequential numbers (1234, 4321)';
      case PasscodeStrength.repeated:
        return 'Avoid repeated digits (1111, 2222)';
      case PasscodeStrength.common:
        return 'This passcode is too common. Try a different one.';
      case PasscodeStrength.good:
        return 'Good passcode';
    }
  }

  bool get isValid => this == PasscodeStrength.good;
}
