import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../src.dart';

class RewardProvider extends ChangeNotifier {
  Future<void> saveRewardForChild(RewardModel reward) async {
    final childId = await ChildLocalStorage.getCurrentChildId();
    if (childId == null) {
      logger.e('Child ID not found');
      return;
    }

    final rewardData = reward.toJson();

    try {
      final querySnapshot =
          await _firestore
              .collection('creward')
              .where('childId', isEqualTo: childId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;
        await docRef.update({
          'rewards': FieldValue.arrayUnion([rewardData]),
        });
        logger.d('Reward appended for childId: $childId');
      } else {
        await _firestore.collection('creward').add({
          'childId': childId,
          'rewards': [rewardData],
        });
        logger.d('Reward created for childId: $childId');
      }
    } catch (e) {
      logger.e('Failed to save reward for childId: $childId. Error: $e');
    }
  }

  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  List<RewardModel> _rewards = [];
  List<RewardModel> get rewards => _rewards;

  List<RewardModel> _childRewards = [];
  List<RewardModel> get childRewards => _childRewards;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> fetchRewardCollection() async {
    setStatus(DataFetchStatus.loading);
    try {
      final querySnapshot =
          await _firestore.collection('reward_collection').get();
      _rewards =
          querySnapshot.docs
              .map((doc) => RewardModel.fromJson(doc.data()))
              .toList();
      setStatus(DataFetchStatus.success);
    } catch (e) {
      setStatus(DataFetchStatus.error);
      rethrow;
    }
  }

  Future<void> fetchChildRewards() async {
    setStatus(DataFetchStatus.loading);
    await ensureCrewardCollectionExists();
    final childId = await ChildLocalStorage.getCurrentChildId();
    if (childId == null) {
      logger.e('Child ID not found');
      setStatus(DataFetchStatus.error);
      return;
    }
    try {
      final querySnapshot =
          await _firestore
              .collection('creward')
              .where('childId', isEqualTo: childId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final rewards = doc.data()['rewards'] as List<dynamic>?;
        _childRewards =
            rewards != null
                ? rewards.map((reward) => RewardModel.fromJson(reward)).toList()
                : [];
        logger.d('Fetched ${_childRewards.length} child rewards');
      } else {
        _childRewards = [];
        logger.d('No rewards found for childId: $childId');
      }

      setStatus(DataFetchStatus.success);
    } catch (e) {
      setStatus(DataFetchStatus.error);
      logger.e(
        'Failed to fetch child rewards for childId: $childId. Error: $e',
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
      final querySnapshot =
          await _firestore
              .collection('creward')
              .where('childId', isEqualTo: childId)
              .get();

      if (querySnapshot.docs.isEmpty) {
        await _firestore.collection('creward').add({
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
