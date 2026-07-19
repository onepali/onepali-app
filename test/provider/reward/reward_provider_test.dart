import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/src.dart';

void main() {
  group('RewardProvider', () {
    const parentUid = 'parent-1';
    const childUid = 'child-1';

    late FakeFirebaseFirestore firestore;
    late RewardProvider provider;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      provider = RewardProvider(firestore: firestore);
    });

    test('reward progress counts unique lesson completions only', () async {
      await _seedChild(firestore, parentUid: parentUid, childUid: childUid);
      await _seedCompletion(
        firestore,
        parentUid: parentUid,
        childUid: childUid,
        type: ActivityType.lesson,
        contentId: 'lesson-1',
        completedCount: 3,
      );
      await _seedCompletion(
        firestore,
        parentUid: parentUid,
        childUid: childUid,
        type: ActivityType.lesson,
        contentId: 'lesson-2',
      );
      await _seedCompletion(
        firestore,
        parentUid: parentUid,
        childUid: childUid,
        type: ActivityType.song,
        contentId: 'song-1',
      );
      await _seedCompletion(
        firestore,
        parentUid: parentUid,
        childUid: childUid,
        type: ActivityType.story,
        contentId: 'story-1',
      );

      final progress = await provider.fetchRewardProgress(
        parentUid: parentUid,
        childUid: childUid,
      );

      expect(progress, 2);
      expect(provider.rewardProgressCount, 2);
      expect(provider.canClaimReward, isFalse);
    });

    test('claiming reward consumes five unique lesson completions', () async {
      await _seedChild(firestore, parentUid: parentUid, childUid: childUid);
      for (var i = 1; i <= 6; i++) {
        await _seedCompletion(
          firestore,
          parentUid: parentUid,
          childUid: childUid,
          type: ActivityType.lesson,
          contentId: 'lesson-$i',
        );
      }

      final saved = await provider.saveRewardForChild(
        _reward('reward-1'),
        parentUid: parentUid,
        childId: childUid,
      );
      final secondSaved = await provider.saveRewardForChild(
        _reward('reward-2'),
        parentUid: parentUid,
        childId: childUid,
      );
      final progress = await provider.fetchRewardProgress(
        parentUid: parentUid,
        childUid: childUid,
      );

      expect(saved, isTrue);
      expect(secondSaved, isFalse);
      expect(progress, 1);
      expect(provider.canClaimReward, isFalse);
      expect(provider.childRewards.map((reward) => reward.id), ['reward-1']);
    });

    test('claimable rewards exclude already claimed rewards', () async {
      await firestore
          .collection(AppConstants.rewardCollection)
          .doc('reward-1')
          .set(_reward('reward-1').toJson());
      await firestore
          .collection(AppConstants.rewardCollection)
          .doc('reward-2')
          .set(_reward('reward-2').toJson());
      await firestore.collection(AppConstants.childRewardCollection).add({
        'childId': childUid,
        'rewards': [_reward('reward-1').toJson()],
      });

      await provider.fetchClaimableRewards(childId: childUid);

      expect(provider.claimableRewards.map((reward) => reward.id), [
        'reward-2',
      ]);
    });
  });
}

Future<void> _seedChild(
  FakeFirebaseFirestore firestore, {
  required String parentUid,
  required String childUid,
}) {
  return firestore
      .collection(AppConstants.usersCollection)
      .doc(parentUid)
      .collection(AppConstants.childrenCollection)
      .doc(childUid)
      .set({'uid': childUid});
}

Future<void> _seedCompletion(
  FakeFirebaseFirestore firestore, {
  required String parentUid,
  required String childUid,
  required ActivityType type,
  required String contentId,
  int completedCount = 1,
}) {
  return firestore
      .collection(AppConstants.usersCollection)
      .doc(parentUid)
      .collection(AppConstants.childrenCollection)
      .doc(childUid)
      .collection(AppConstants.completedContentCollection)
      .doc('${type.name}_$contentId')
      .set({
        'id': '${type.name}_$contentId',
        'parent_id': parentUid,
        'child_id': childUid,
        'content_id': contentId,
        'content_name': contentId,
        'content_type': type.name,
        'completed_count': completedCount,
      });
}

RewardModel _reward(String id) {
  return RewardModel(
    id: id,
    titleNp: 'Sticker',
    titleEn: 'Sticker',
    descriptionNp: 'Description',
    descriptionEn: 'Description',
    sAudio: '',
    image: 'https://example.com/$id.svg',
  );
}
