import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../src.dart';

class ChildAuthProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Validates that the provided parentUid matches the currently authenticated user
  bool _validateParentUid(String parentUid) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      logger.e('❌ Validation failed: No authenticated user found');
      return false;
    }
    if (currentUser.uid != parentUid) {
      logger.e(
        '❌ Validation failed: Parent UID mismatch. Current: ${currentUser.uid}, Provided: $parentUid',
      );
      return false;
    }
    logger.d('✅ Parent UID validation passed: $parentUid');
    return true;
  }

  /// Creates a child user and returns the child document ID
  /// Returns null if creation fails
  Future<String?> createChildUser({
    required String childName,
    required String childDob,
    required double screenTime,
    required bool hasScreenTime,
    required String avatarFilePath,
    required String parentUid,
    required String parentEmail,
  }) async {
    setStatus(DataFetchStatus.loading);
    try {
      // Validate parent UID matches current authenticated user
      if (!_validateParentUid(parentUid)) {
        setStatus(DataFetchStatus.error);
        throw Exception(
          'Parent UID validation failed. User may have been logged out or account mismatch detected.',
        );
      }

      // Validate child name (optional: check for duplicates within family)
      // final validation = await ChildNameValidator.validateChildName(
      //   parentUid: parentUid,
      //   childName: childName,
      // );
      //
      // if (!validation.isValid) {
      //   setStatus(DataFetchStatus.error);
      //   showCustomToaster(validation.message, isError: true);
      //   return;
      // }
      final childDoc = _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc();
      final childId = childDoc.id;
      logger.d('Avatar file path: $avatarFilePath');
      String avatarUrl = await MediaUtility.uploadAvatarImage(
        avatarFilePath,
        childId,
      );
      logger.d('Avatar URL: $avatarUrl');

      logger.i('📋 Creating child data with screen time tracking:');
      logger.i('   - Child name: $childName');
      logger.i('   - Child ID: $childId');
      logger.i('   - Parent UID: $parentUid');
      logger.i('   - Parent email: $parentEmail');
      logger.i('   - Screen time limit: $screenTime minutes');
      logger.i('   - Has screen time setup: $hasScreenTime');

      final childData = {
        'uid': childId,
        'full_name': childName,
        'dob': childDob,
        'has_screen_time': hasScreenTime,
        'avatar_url': avatarUrl,
        'role': 'child',
        'parent_uid': parentUid,
        'parent_email': parentEmail,
        'created_at': DateTime.now().toIso8601String(),
        'screenTimeTracking': {
          'totalAllowed': screenTime,
          'totalUsed': 0.0,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
      };
      logger.d('Child data: $childData');
      await childDoc.set(childData);

      // Verify child was created successfully
      final createdDoc = await childDoc.get();
      if (!createdDoc.exists) {
        throw Exception('Child document was not created successfully');
      }
      final createdData = createdDoc.data();
      if (createdData?['parent_uid'] != parentUid) {
        throw Exception(
          'Child document parent_uid mismatch. Expected: $parentUid, Found: ${createdData?['parent_uid']}',
        );
      }

      logger.i(
        '✅ Child profile created successfully with screen time tracking. Child ID: $childId',
      );
      setStatus(DataFetchStatus.success);
      return childId;
    } catch (e, s) {
      logger.e('❌ Error creating child user: $e $s');
      setStatus(DataFetchStatus.error);
      rethrow;
    }
  }

  void setStatus(DataFetchStatus value) {
    _status = value;
    notifyListeners();
  }
}
