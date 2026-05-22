import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../src.dart';

class RewardProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  List<RewardModel> _rewards = [];
  List<RewardModel> get rewards => _rewards;

  List<RewardModel> _claimableRewards = [];
  List<RewardModel> get claimableRewards => _claimableRewards;

  List<RewardModel> _childRewards = [];
  List<RewardModel> get childRewards => _childRewards;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _totalStarBadge = 0;
  int get totalStarBadge => _totalStarBadge;

  Future<void> saveRewardForChild(RewardModel reward) async {
    final childId = await ChildLocalStorage.getCurrentChildId();
    final parentId = FirebaseAuth.instance.currentUser?.uid;
    if (parentId == null || parentId.isEmpty) {
      logger.e('Parent ID not found');
      return;
    }
    if (childId == null) {
      logger.e('Child ID not found');
      return;
    }

    // Check if reward already exists for this child
    if (await _isRewardAlreadyExists(childId, reward.id)) {
      logger.d(
        'Reward with ID ${reward.id} already exists for childId: $childId',
      );
      return;
    }

    final rewardData = reward.toJson();

    try {
      // Remove 5 rewards from the (users)/(children)/completedLessonsCount field.
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentId)
          .collection(AppConstants.childrenCollection)
          .doc(childId)
          .update({'completedLessonsCount': FieldValue.increment(-5)});
      // Save the reward to the childRewardCollection
      final querySnapshot = await _firestore
          .collection(AppConstants.childRewardCollection)
          .where('childId', isEqualTo: childId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;
        await docRef.update({
          'rewards': FieldValue.arrayUnion([rewardData]),
        });
        logger.d('Reward appended for childId: $childId');
      } else {
        await _firestore.collection(AppConstants.childRewardCollection).add({
          'childId': childId,
          'rewards': [rewardData],
        });
        logger.d('Reward created for childId: $childId');
      }
    } catch (e) {
      logger.e('Failed to save reward for childId: $childId. Error: $e');
    }
  }

  // Helper method to check if reward already exists for a child
  Future<bool> _isRewardAlreadyExists(String childId, String rewardId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.childRewardCollection)
          .where('childId', isEqualTo: childId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final rewards = doc.data()['rewards'] as List<dynamic>?;

        if (rewards != null) {
          return rewards.any((reward) => reward['id'] == rewardId);
        }
      }
      return false;
    } catch (e) {
      logger.e('Error checking if reward exists: $e');
      return false;
    }
  }

  setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> fetchRewardCollection() async {
    setStatus(DataFetchStatus.loading);
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.rewardCollection)
          .get();
      _rewards = querySnapshot.docs
          .map((doc) => RewardModel.fromJson(doc.data()))
          .toList();
      setStatus(DataFetchStatus.success);
    } catch (e) {
      setStatus(DataFetchStatus.error);
      rethrow;
    }
  }

  Future<void> fetchClaimableRewards(String childId) async {
    try {
      setStatus(DataFetchStatus.loading);
      // Fetch all rewards
      final querySnapshot = await _firestore
          .collection(AppConstants.rewardCollection)
          .get();
      final allRewards = querySnapshot.docs
          .map((doc) => RewardModel.fromJson(doc.data()))
          .toList();
      // Fetch child rewards
      final childRewards = await _firestore
          .collection(AppConstants.childRewardCollection)
          .where('childId', isEqualTo: childId)
          .limit(1)
          .get();
      // check if this doc is already exists
      if (childRewards.docs.isNotEmpty) {
        final childReward = childRewards.docs.first;
        final childRewardData = childReward.data();
        final childRewardRewards = childRewardData['rewards'] as List<dynamic>;
        final childRewardRewardsIds = childRewardRewards
            .map((reward) => reward['id'])
            .toList();
        _claimableRewards = allRewards
            .where((reward) => !childRewardRewardsIds.contains(reward.id))
            .toList();
      } else {
        _claimableRewards = allRewards;
      }
      setStatus(DataFetchStatus.success);
    } catch (e) {
      setStatus(DataFetchStatus.error);
      rethrow;
    }
  }

  Future<void> fetchChildRewards({String? childId}) async {
    setStatus(DataFetchStatus.loading);

    final targetChildId =
        childId ?? await ChildLocalStorage.getCurrentChildId();
    logger.d('fetchChildRewards - targetChildId: $targetChildId');
    if (targetChildId == null) {
      logger.e('Child ID not found');
      setStatus(DataFetchStatus.error);
      return;
    }

    if (childId == null) {
      await ensureCrewardCollectionExists();
    }

    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.childRewardCollection)
          .where('childId', isEqualTo: targetChildId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final rewards = doc.data()['rewards'] as List<dynamic>?;
        _childRewards = rewards != null
            ? rewards.map((reward) => RewardModel.fromJson(reward)).toList()
            : [];
        _totalStarBadge = _childRewards.length;
        logger.d(
          'Fetched ${_childRewards.length} child rewards for childId: $targetChildId',
        );
      } else {
        _childRewards = [];
        logger.d('No rewards found for childId: $targetChildId');
      }

      setStatus(DataFetchStatus.success);
    } catch (e) {
      setStatus(DataFetchStatus.error);
      logger.e(
        'Failed to fetch child rewards for childId: $targetChildId. Error: $e',
      );
    }
  }

  Future<void> ensureCrewardCollectionExists() async {
    final childId = await ChildLocalStorage.getCurrentChildId();
    if (childId == null) {
      logger.e('Child ID not found');
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.childRewardCollection)
          .where('childId', isEqualTo: childId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await _firestore.collection(AppConstants.childRewardCollection).add({
          'childId': childId,
          'rewards': [],
        });
        logger.d('Created creward collection for childId: $childId');
      } else {
        logger.d('creward collection already exists for childId: $childId');
      }
    } catch (e) {
      logger.e(
        'Failed to ensure creward collection exists for childId: $childId. Error: $e',
      );
    }
  }
}
