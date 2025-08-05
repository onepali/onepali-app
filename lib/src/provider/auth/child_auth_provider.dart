import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../src.dart';

class ChildAuthProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createChildUser({
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
      final childDoc =
          _firestore
              .collection('users')
              .doc(parentUid)
              .collection('children')
              .doc();
      logger.d('Avatar file path: $avatarFilePath');
      String avatarUrl = await MediaUtility.uploadAvatarImage(
        avatarFilePath,
        childDoc.id,
      );
      logger.d('Avatar URL: $avatarUrl');

      logger.i('📋 Creating child data with screen time tracking:');
      logger.i('   - Child name: $childName');
      logger.i('   - Screen time limit: $screenTime minutes');
      logger.i('   - Has screen time setup: $hasScreenTime');

      final childData = {
        'uid': childDoc.id,
        'full_name': childName,
        'dob': childDob,
        'screen_time': screenTime,
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

      logger.i('Child profile created successfully with screen time tracking');
      setStatus(DataFetchStatus.success);
    } catch (e, s) {
      logger.e('Error creating child user: $e $s');
      setStatus(DataFetchStatus.error);
      rethrow;
    }
  }

  void setStatus(DataFetchStatus value) {
    _status = value;
    notifyListeners();
  }
}
