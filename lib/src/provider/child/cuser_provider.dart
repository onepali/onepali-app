import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class ChildUserProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ChildUserModel> _childUser = [];
  List<ChildUserModel> get childUser => _childUser;

  int _totalChildren = 3;
  int get totalChildren => _totalChildren;

  Future<void> selectDefaultChildIfNeeded(BuildContext context) async {
    final currentChildId = await ChildLocalStorage.getCurrentChildId();
    if ((currentChildId == null || currentChildId.isEmpty) &&
        _childUser.isNotEmpty) {
      final firstChild = _childUser.first;
      await ChildLocalStorage.saveCurrentChildId(firstChild.uid);
      await ChildLocalStorage.saveCurrentAvatarUrl(firstChild.avatarUrl);
      // Optionally, update AuthState if needed
      if (context.mounted) {
        final authState = Provider.of<AuthState>(context, listen: false);
        authState.setCurrentChildId(firstChild.uid);
      }
    }
  }

  /// Returns the current child user based on local storage, or null if not found
  Future<ChildUserModel?> getCurrentChild() async {
    final currentChildId = await ChildLocalStorage.getCurrentChildId();
    if (currentChildId != null && _childUser.isNotEmpty) {
      return _childUser.firstWhere(
        (c) => c.uid == currentChildId,
        orElse: () => _childUser.first,
      );
    }
    return null;
  }

  Future<void> fetchChildUser() async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      logger.e('User is not authenticated.');
      handleError("User not signed in.");
      return;
    }
    final String parentUid = user.uid;
    logger.i('Parent UID: $user');
    logger.d('Current UID: ${FirebaseAuth.instance.currentUser?.uid}');
    logger.d('Target path: /users/$parentUid/children');

    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .doc(parentUid)
              .collection('children')
              .get();
      _childUser =
          querySnapshot.docs
              .map((doc) => ChildUserModel.fromJson(doc.data()))
              .toList();
      logger.d('Fetched ${_childUser.length} child users');
      if (_childUser.isNotEmpty) {
        _totalChildren = _childUser.length;
      }
      setStatus(DataFetchStatus.success);
    } catch (e, s) {
      logger.e('Error fetching child users: $e');
      logger.e('Stack trace: $s');
      handleError(e.toString());
    }
  }

  Future<void> updateChildUserProfile({
    required String childUid,
    required String fullName,
    required String dob,
    required double screenTime,
    required String avatarUrl,
  }) async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      showCustomToaster('User not signed in.', isError: true);
      setStatus(DataFetchStatus.error);
      return;
    }
    final String parentUid = user.uid;
    try {
      await _firestore
          .collection('users')
          .doc(parentUid)
          .collection('children')
          .doc(childUid)
          .update({
            'full_name': fullName,
            'dob': dob,
            'screen_time': screenTime,
            'avatar_url': avatarUrl,
            'screenTimeTracking': {
              'totalAllowed': screenTime,
              'totalUsed': 0.0,
              'lastUpdated': DateTime.now().toIso8601String(),
            },
          });
      // Update local list
      int idx = _childUser.indexWhere((c) => c.uid == childUid);
      if (idx != -1) {
        final newScreenTimeTracking = ScreenTimeModel(
          totalAllowed: screenTime,
          totalUsed: 0.0,
          lastUpdated: DateTime.now(),
        );

        _childUser[idx] = ChildUserModel(
          avatarUrl: avatarUrl,
          createdAt: _childUser[idx].createdAt,
          dob: dob,
          fullName: fullName,
          parentEmail: _childUser[idx].parentEmail,
          parentUid: _childUser[idx].parentUid,
          role: _childUser[idx].role,
          screenTime: screenTime,
          totalLessonsCompleted: _childUser[idx].totalLessonsCompleted,
          uid: childUid,
          screenTimeTracking: newScreenTimeTracking,
        );
        notifyListeners();
      }
      showCustomToaster('Child profile updated successfully.');
      setStatus(DataFetchStatus.success);
    } catch (e) {
      showCustomToaster('Failed to update child profile.', isError: true);
      setStatus(DataFetchStatus.error);
    }
  }

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  void handleError(String error) {
    _status = DataFetchStatus.error;
    showCustomToaster(error, isError: true);
    notifyListeners();
  }
}
