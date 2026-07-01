import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src.dart';

class ChildNameValidator {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> isNameDuplicateForParent({
    required String parentUid,
    required String childName,
    String? excludeChildId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .where('full_name', isEqualTo: childName.trim())
          .get();

      if (excludeChildId != null) {
        return querySnapshot.docs.any((doc) => doc.id != excludeChildId);
      }

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      logger.e('Error checking duplicate child name: $e');
      return false;
    }
  }

  /// Validate child name before creation/update
  static Future<ValidationResult> validateChildName({
    required String parentUid,
    required String childName,
    String? excludeChildId,
  }) async {
    if (childName.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Child name cannot be empty',
      );
    }

    if (childName.trim().length < 2) {
      return ValidationResult(
        isValid: false,
        message: 'Child name must be at least 2 characters',
      );
    }

    // Check for duplicate within the same family
    final isDuplicate = await isNameDuplicateForParent(
      parentUid: parentUid,
      childName: childName,
      excludeChildId: excludeChildId,
    );

    if (isDuplicate) {
      return ValidationResult(
        isValid: false,
        message: 'A child with this name already exists in your family',
      );
    }

    return ValidationResult(isValid: true, message: 'Valid child name');
  }
}

class ValidationResult {
  final bool isValid;
  final String message;

  ValidationResult({required this.isValid, required this.message});
}
