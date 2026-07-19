import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../src.dart';

class RewardProvider extends ChangeNotifier {
  static const int completionsPerReward = 5;

  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  List<RewardModel> _rewards = [];
  List<RewardModel> get rewards => _rewards;

  List<RewardModel> _claimableRewards = [];
  List<RewardModel> get claimableRewards => _claimableRewards;

  List<RewardModel> _childRewards = [];
  List<RewardModel> get childRewards => _childRewards;

  final FirebaseFirestore _firestore;

  RewardProvider({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  int _totalStarBadge = 0;
  int get totalStarBadge => _totalStarBadge;

  int _rewardProgressCount = 0;
  int get rewardProgressCount => _rewardProgressCount;

  bool _canClaimReward = false;
  bool get canClaimReward => _canClaimReward;

  static int claimedRewardsFromData(Map<String, dynamic>? data) {
    final rewards = data?['rewards'];
    if (rewards is List) return rewards.length;
    return 0;
  }

  static int rewardProgressFromCounts({
    required int completedLessons,
    required int claimedRewards,
  }) {
    final unclaimedCompletions =
        completedLessons - (claimedRewards * completionsPerReward);
    return unclaimedCompletions < 0 ? 0 : unclaimedCompletions;
  }

  static bool canClaimRewardFromProgress(int rewardProgress) {
    return rewardProgress >= completionsPerReward;
  }

  static bool canClaimRewardFromCounts({
    required int completedLessons,
    required int claimedRewards,
  }) {
    return canClaimRewardFromProgress(
      rewardProgressFromCounts(
        completedLessons: completedLessons,
        claimedRewards: claimedRewards,
      ),
    );
  }

  Future<bool> saveRewardForChild(
    RewardModel reward, {
    String? parentUid,
    String? childId,
  }) async {
    final targetChildId =
        childId ?? await ChildLocalStorage.getCurrentChildId();
    if (targetChildId == null) {
      logger.e('Child ID not found');
      return false;
    }
    if (parentUid == null || parentUid.isEmpty) {
      logger.e('Parent ID not found');
      return false;
    }

    final rewardProgress = await fetchRewardProgress(
      parentUid: parentUid,
      childUid: targetChildId,
    );
    if (!canClaimRewardFromProgress(rewardProgress)) {
      logger.w(
        'Not enough completed lessons to claim reward. '
        'childId: $targetChildId, progress: $rewardProgress',
      );
      return false;
    }

    // Check if reward already exists for this child
    if (await _isRewardAlreadyExists(targetChildId, reward.id)) {
      logger.d(
        'Reward with ID ${reward.id} already exists for childId: $targetChildId',
      );
      return false;
    }

    final rewardData = reward.toJson();

    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.childRewardCollection)
          .where('childId', isEqualTo: targetChildId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;
        await docRef.update({
          'rewards': FieldValue.arrayUnion([rewardData]),
        });
        logger.d('Reward appended for childId: $targetChildId');
      } else {
        await _firestore.collection(AppConstants.childRewardCollection).add({
          'childId': targetChildId,
          'rewards': [rewardData],
        });
        logger.d('Reward created for childId: $targetChildId');
      }
      await fetchChildRewards(childId: targetChildId);
      await fetchRewardProgress(parentUid: parentUid, childUid: targetChildId);
      return true;
    } catch (e) {
      logger.e('Failed to save reward for childId: $targetChildId. Error: $e');
      return false;
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

  Future<void> fetchClaimableRewards({String? childId}) async {
    setStatus(DataFetchStatus.loading);
    try {
      final targetChildId =
          childId ?? await ChildLocalStorage.getCurrentChildId();
      if (targetChildId == null) {
        logger.e('Child ID not found');
        _claimableRewards = [];
        setStatus(DataFetchStatus.error);
        return;
      }

      final rewardSnapshot = await _firestore
          .collection(AppConstants.rewardCollection)
          .get();
      final allRewards = rewardSnapshot.docs
          .map((doc) => RewardModel.fromJson(doc.data()))
          .toList();

      final childRewardSnapshot = await _childRewardsQuery(targetChildId).get();
      final claimedRewardIds = <String>{
        for (final doc in childRewardSnapshot.docs)
          for (final reward in (doc.data()['rewards'] as List<dynamic>? ?? []))
            if (reward is Map && reward['id'] != null) reward['id'].toString(),
      };

      _claimableRewards = allRewards
          .where((reward) => !claimedRewardIds.contains(reward.id))
          .toList();
      _rewards = allRewards;
      setStatus(DataFetchStatus.success);
    } catch (e) {
      _claimableRewards = [];
      setStatus(DataFetchStatus.error);
      logger.e('Failed to fetch claimable rewards. Error: $e');
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
      final querySnapshot = await _childRewardsQuery(targetChildId).get();

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

  Future<int> fetchRewardProgress({
    required String parentUid,
    required String childUid,
  }) async {
    try {
      final completedLessonsSnapshot = await _completedLessonsQuery(
        parentUid,
        childUid,
      ).get();
      final rewardsSnapshot = await _childRewardsQuery(childUid).get();
      final completedLessons = completedLessonsSnapshot.docs.length;
      final claimedRewards = rewardsSnapshot.docs.fold<int>(
        0,
        (total, doc) => total + claimedRewardsFromData(doc.data()),
      );
      final progress = rewardProgressFromCounts(
        completedLessons: completedLessons,
        claimedRewards: claimedRewards,
      );
      _rewardProgressCount = progress;
      _canClaimReward = canClaimRewardFromProgress(progress);
      notifyListeners();
      return progress;
    } catch (e) {
      logger.e('Failed to fetch reward progress: $e');
      return 0;
    }
  }

  Stream<int> watchRewardProgress({
    required String parentUid,
    required String childUid,
  }) {
    late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    lessonsSubscription;
    late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    rewardsSubscription;

    final controller = StreamController<int>();
    int completedLessons = 0;
    int claimedRewards = 0;

    void emitProgress() {
      if (controller.isClosed) return;
      controller.add(
        rewardProgressFromCounts(
          completedLessons: completedLessons,
          claimedRewards: claimedRewards,
        ),
      );
    }

    lessonsSubscription = _completedLessonsQuery(parentUid, childUid)
        .snapshots()
        .listen((lessonsSnapshot) {
          completedLessons = lessonsSnapshot.docs.length;
          emitProgress();
        }, onError: controller.addError);
    rewardsSubscription = _childRewardsQuery(childUid).snapshots().listen((
      rewardsSnapshot,
    ) {
      claimedRewards = rewardsSnapshot.docs.fold<int>(
        0,
        (total, doc) => total + claimedRewardsFromData(doc.data()),
      );
      emitProgress();
    }, onError: controller.addError);

    controller.onCancel = () async {
      await lessonsSubscription.cancel();
      await rewardsSubscription.cancel();
    };

    return controller.stream.distinct();
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

  DocumentReference<Map<String, dynamic>> _childDoc(
    String parentUid,
    String childUid,
  ) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(parentUid)
        .collection(AppConstants.childrenCollection)
        .doc(childUid);
  }

  Query<Map<String, dynamic>> _childRewardsQuery(String childId) {
    return _firestore
        .collection(AppConstants.childRewardCollection)
        .where('childId', isEqualTo: childId);
  }

  Query<Map<String, dynamic>> _completedLessonsQuery(
    String parentUid,
    String childUid,
  ) {
    return _childDoc(parentUid, childUid)
        .collection(AppConstants.completedContentCollection)
        .where('content_type', isEqualTo: ActivityType.lesson.name);
  }
}
