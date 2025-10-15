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

  int _totalChildren = 0;
  int get totalChildren => _totalChildren;

  bool _hasScreenTimeEnabled = false;
  bool get hasScreenTimeEnabled => _hasScreenTimeEnabled;

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
      final currentChild = _childUser.firstWhere(
        (c) => c.uid == currentChildId,
        orElse: () => _childUser.first,
      );
      _updateScreenTimeEnabledStatus(currentChild);
      return currentChild;
    }
    return null;
  }

  void _updateScreenTimeEnabledStatus(ChildUserModel child) {
    final wasEnabled = _hasScreenTimeEnabled;
    _hasScreenTimeEnabled = child.hasScreenTime;

    if (wasEnabled != _hasScreenTimeEnabled) {
      logger.i(
        'Screen time enabled status changed: $_hasScreenTimeEnabled for child ${child.fullName}',
      );
      notifyListeners();
    }
  }

  Future<void> updateScreenTimeEnabledStatusByChildId(String childId) async {
    final child = _childUser.firstWhere(
      (c) => c.uid == childId,
      orElse: () => _childUser.isEmpty
          ? ChildUserModel(
              avatarUrl: '',
              createdAt: '',
              dob: '',
              fullName: '',
              parentEmail: '',
              parentUid: '',
              role: 'child',
              hasScreenTime: false,
              uid: '',
            )
          : _childUser.first,
    );

    if (child.uid == childId) {
      _updateScreenTimeEnabledStatus(child);
    }
  }

  Future<void> fetchChildUser() async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    // Check if it's a guest user
    bool isGuest = GuestUtil.isGuestUser();

    if (user == null && !isGuest) {
      logger.e('User is not authenticated and not a guest user.');
      handleError("User not signed in.");
      return;
    }

    // Skip further processing for guest users
    if (isGuest) {
      logger.i('Guest user detected. Skipping child user fetching.');
      setStatus(DataFetchStatus.success);
      return;
    }

    final String parentUid = user!.uid;
    logger.i('Parent UID: $user');
    logger.d('Current UID: ${FirebaseAuth.instance.currentUser?.uid}');
    logger.d('Target path: /users/$parentUid/children');

    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .get();
      _childUser = querySnapshot.docs
          .map((doc) => ChildUserModel.fromJson(doc.data()))
          .toList();
      logger.d('Fetched ${_childUser.length} child users');
      if (_childUser.isNotEmpty) {
        _totalChildren = _childUser.length;
        await getCurrentChild();
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
    bool? hasScreenTime,
  }) async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    // Check if it's a guest user
    bool isGuest = GuestUtil.isGuestUser();

    if (user == null && !isGuest) {
      showCustomToaster('User not signed in.', isError: true);
      setStatus(DataFetchStatus.error);
      return;
    }

    // Skip further processing for guest users
    if (isGuest) {
      logger.i('Guest user detected. Skipping child user profile update.');
      setStatus(DataFetchStatus.success);
      return;
    }

    final String parentUid = user!.uid;

    // Optional: Validate child name for duplicates within family
    // final validation = await ChildNameValidator.validateChildName(
    //   parentUid: parentUid,
    //   childName: fullName,
    //   excludeChildId: childUid, // Exclude current child from duplicate check
    // );
    //
    // if (!validation.isValid) {
    //   showCustomToaster(validation.message, isError: true);
    //   setStatus(DataFetchStatus.error);
    //   return;
    // }

    try {
      final childDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid)
          .get();

      double existingTotalUsed = 0.0;
      if (childDoc.exists && childDoc.data() != null) {
        final data = childDoc.data()!;
        if (data['screenTimeTracking'] != null &&
            data['screenTimeTracking']['totalUsed'] != null) {
          existingTotalUsed = (data['screenTimeTracking']['totalUsed'] as num)
              .toDouble();
        }
      }

      // Prepare update data
      Map<String, dynamic> updateData = {
        'full_name': fullName,
        'dob': dob,
        'avatar_url': avatarUrl,
      };

      // If screen time is enabled, update only screenTimeTracking
      if (hasScreenTime == true) {
        updateData['screenTimeTracking'] = {
          'totalAllowed': screenTime,
          'totalUsed': existingTotalUsed,
          'lastUpdated': DateTime.now().toIso8601String(),
        };
        updateData['has_screen_time'] = true;
      } else {
        // If screen time is disabled, reset all related fields
        updateData['screenTimeTracking'] = {
          'totalAllowed': 0.0,
          'totalUsed': 0.0,
          'lastUpdated': DateTime.now().toIso8601String(),
        };
        updateData['has_screen_time'] = false;
      }

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid)
          .update(updateData);
      // Update local list
      int idx = _childUser.indexWhere((c) => c.uid == childUid);
      if (idx != -1) {
        final newScreenTimeTracking = ScreenTimeModel(
          totalAllowed: hasScreenTime == true ? screenTime : 0.0,
          totalUsed: hasScreenTime == true ? existingTotalUsed : 0.0,
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
          hasScreenTime: hasScreenTime ?? _childUser[idx].hasScreenTime,
          uid: childUid,
          screenTimeTracking: newScreenTimeTracking,
          completedLessons: _childUser[idx].completedLessons,
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

  Future<void> deleteChildUser(String childUid) async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    // Check if it's a guest user
    bool isGuest = GuestUtil.isGuestUser();

    if (user == null && !isGuest) {
      showCustomToaster('User not signed in.', isError: true);
      setStatus(DataFetchStatus.error);
      return;
    }

    // Skip further processing for guest users
    if (isGuest) {
      logger.i('Guest user detected. Skipping child user deletion.');
      setStatus(DataFetchStatus.success);
      return;
    }

    final String parentUid = user!.uid;

    try {
      // Create a batch for atomic operations
      WriteBatch batch = _firestore.batch();

      // Delete child-related data from various collections
      List<String> collections = [
        'creward',
        'notification_setting',
        'recom_lesson',
        'recom_song',
        'recom_story',
      ];

      // Delete documents from child-related collections
      for (String collectionName in collections) {
        QuerySnapshot querySnapshot = await _firestore
            .collection(collectionName)
            .where('childId', isEqualTo: childUid)
            .get();

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          batch.delete(doc.reference);
        }
        logger.d(
          'Queued ${querySnapshot.docs.length} documents for deletion from $collectionName',
        );
      }

      // Delete the child document from the parent's children subcollection
      DocumentReference childRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid);

      batch.delete(childRef);
      logger.d(
        'Queued child document for deletion from users/$parentUid/children/$childUid',
      );

      // Commit the batch
      await batch.commit();
      logger.i(
        'Successfully deleted child user and all related data for childUid: $childUid',
      );

      // Remove from local list and update state
      _childUser.removeWhere((child) => child.uid == childUid);
      _totalChildren = _childUser.length;

      // Clear current child from local storage if it was the deleted child
      final currentChildId = await ChildLocalStorage.getCurrentChildId();
      if (currentChildId == childUid) {
        await ChildLocalStorage.saveCurrentChildId('');
        await ChildLocalStorage.saveCurrentAvatarUrl('');
      }

      showCustomToaster('Child profile deleted successfully.');
      setStatus(DataFetchStatus.success);
    } catch (e, s) {
      logger.e('Error deleting child user: $e');
      logger.e('Stack trace: $s');
      showCustomToaster('Failed to delete child profile.', isError: true);
      setStatus(DataFetchStatus.error);
    }
  }

  Future<void> extendScreenTime({
    required String childUid,
    required double additionalMinutes,
  }) async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    bool isGuest = GuestUtil.isGuestUser();

    if (user == null && !isGuest) {
      showCustomToaster('User not signed in.', isError: true);
      setStatus(DataFetchStatus.error);
      return;
    }

    if (isGuest) {
      logger.i('Guest user detected. Skipping screen time extension.');
      setStatus(DataFetchStatus.success);
      return;
    }

    final String parentUid = user!.uid;

    try {
      // Get the child document reference
      final childDoc = _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid);

      // Get current child data
      final docSnapshot = await childDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;

        // Get current screen time tracking data
        Map<String, dynamic>? screenTimeTracking = data['screenTimeTracking'];
        double newAllowed;
        double currentUsed = 0.0;

        if (screenTimeTracking != null) {
          final currentAllowed =
              (screenTimeTracking['totalAllowed'] as num?)?.toDouble() ?? 0.0;
          currentUsed =
              (screenTimeTracking['totalUsed'] as num?)?.toDouble() ?? 0.0;
          newAllowed = currentAllowed + additionalMinutes;

          await childDoc.update({
            'screenTimeTracking': {
              'totalAllowed': newAllowed,
              'totalUsed': currentUsed,
              'lastUpdated': DateTime.now().toIso8601String(),
            },
          });

          logger.i('Screen time extended by $additionalMinutes minutes.');
          logger.i('New totalAllowed: $newAllowed');
          logger.i('totalUsed remains: $currentUsed');
        } else {
          final child = _childUser.firstWhere((c) => c.uid == childUid);
          final currentScreenTime =
              child.screenTimeTracking?.totalAllowed ?? 0.0;
          newAllowed = currentScreenTime + additionalMinutes;

          await childDoc.update({
            'screenTimeTracking': {
              'totalAllowed': newAllowed,
              'totalUsed': 0.0,
              'lastUpdated': DateTime.now().toIso8601String(),
            },
          });

          logger.i(
            'Created screen time tracking with extended limit: $newAllowed',
          );
        }

        final childIndex = _childUser.indexWhere((c) => c.uid == childUid);
        if (childIndex != -1) {
          final updatedChild = _childUser[childIndex];
          final updatedScreenTimeTracking = ScreenTimeModel(
            totalAllowed: newAllowed,
            totalUsed: currentUsed,
            lastUpdated: DateTime.now(),
          );

          _childUser[childIndex] = ChildUserModel(
            avatarUrl: updatedChild.avatarUrl,
            createdAt: updatedChild.createdAt,
            dob: updatedChild.dob,
            fullName: updatedChild.fullName,
            parentEmail: updatedChild.parentEmail,
            parentUid: updatedChild.parentUid,
            role: updatedChild.role,
            hasScreenTime: updatedChild.hasScreenTime,
            uid: childUid,
            screenTimeTracking: updatedScreenTimeTracking,
            completedLessons: updatedChild.completedLessons,
          );

          logger.i('Updated local child data with extended screen time');
          notifyListeners();
        }
      } else {
        throw Exception('Child document not found');
      }

      showCustomToaster('Screen time extended successfully!');
      setStatus(DataFetchStatus.success);
    } catch (e, s) {
      logger.e('Error extending screen time: $e');
      logger.e('Stack trace: $s');
      showCustomToaster(
        'Failed to extend screen time. Please try again.',
        isError: true,
      );
      setStatus(DataFetchStatus.error);
    }
  }

  void handleError(String error) {
    _status = DataFetchStatus.error;
    showCustomToaster(error, isError: true);
    notifyListeners();
  }
}
