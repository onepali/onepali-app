import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/constants/app_constants.dart';
import 'package:onepali/src/core/model/pzone/pz_home/pz_home_metrics_model.dart';
import 'package:onepali/src/core/services/child_local_storage.dart';
import 'package:onepali/src/core/services/shared_pref_service.dart';
import 'package:onepali/src/core/utils/guest_util.dart';
import 'package:onepali/src/core/utils/metrics_tracking_helper.dart';
import 'package:onepali/src/provider/lesson/lesson_provider.dart';
import 'package:onepali/src/provider/pzone/pz_home/pz_metrics_provider.dart';
import 'package:onepali/src/provider/song/song_provider.dart';
import 'package:onepali/src/provider/story/story_provider.dart';
import 'package:onepali/src/provider/user/user_provider.dart';
import 'package:onepali/src/repo/story/story_repo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PzMetricsProvider', () {
    const parentUid = 'mock-parent';
    const childUid = 'mock-child';
    const otherChildUid = 'other-child';

    late FakeFirebaseFirestore firestore;
    late PzMetricsProvider provider;

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      provider = PzMetricsProvider(firestore: firestore);

      await _childDoc(
        firestore,
        parentUid,
        childUid,
      ).set({'metrics': PzHomeMetricsModel.fromJson(null).toJson()});
      await _childDoc(
        firestore,
        parentUid,
        otherChildUid,
      ).set({'metrics': PzHomeMetricsModel.fromJson(null).toJson()});
    });

    test('records unique completed content and derives top topics', () async {
      await provider.trackActivityCompletion(
        parentUid: parentUid,
        childUid: childUid,
        topicName: 'Alphabet',
        activityType: ActivityType.lesson,
        contentId: 'lesson-1',
        contentName: 'Find Na',
      );

      await provider.trackActivityCompletion(
        parentUid: parentUid,
        childUid: childUid,
        topicName: 'Alphabet',
        activityType: ActivityType.lesson,
        contentId: 'lesson-1',
        contentName: 'Find Na',
      );

      await provider.trackActivityCompletion(
        parentUid: parentUid,
        childUid: childUid,
        topicName: 'Music',
        activityType: ActivityType.song,
        contentId: 'song-1',
        contentName: 'Song One',
      );

      final lessonCompletion = await _childDoc(firestore, parentUid, childUid)
          .collection(AppConstants.completedContentCollection)
          .doc('lesson_lesson-1')
          .get();

      expect(lessonCompletion.data()?['parent_id'], parentUid);
      expect(lessonCompletion.data()?['child_id'], childUid);
      expect(lessonCompletion.data()?['content_name'], 'Find Na');
      expect(lessonCompletion.data()?['completed_count'], 2);

      expect(provider.currentScope?.parentUid, parentUid);
      expect(provider.currentScope?.childUid, childUid);
      expect(provider.completedContents, hasLength(2));
      expect(provider.metrics?.completedActivities, 2);
      expect(provider.metrics?.mostPracticedTopics.first, 'Find Na');
      expect(provider.metrics?.topicCounts['Find Na'], 2);
      expect(provider.metrics?.dayStreak, 1);
      expect(provider.metrics?.lastActiveDate, isNotEmpty);
    });

    test(
      'records answer counters per child without cross-child reuse',
      () async {
        await provider.fetchMetrics(parentUid: parentUid, childUid: childUid);

        await provider.trackAnswerAttempt(
          parentUid: parentUid,
          childUid: childUid,
          isCorrect: true,
        );
        await provider.trackAnswerAttempt(
          parentUid: parentUid,
          childUid: childUid,
          isCorrect: false,
        );
        await provider.trackAnswerAttempt(
          parentUid: parentUid,
          childUid: otherChildUid,
          isCorrect: true,
        );

        final firstChild = await _childDoc(
          firestore,
          parentUid,
          childUid,
        ).get();
        final secondChild = await _childDoc(
          firestore,
          parentUid,
          otherChildUid,
        ).get();

        expect(firstChild.data()?['right_answers_count'], 1);
        expect(firstChild.data()?['wrong_answers_count'], 1);
        expect(firstChild.data()?['metrics']['answerSuccessRate'], 0.5);
        expect(secondChild.data()?['right_answers_count'], 1);
        expect(secondChild.data()?['wrong_answers_count'], isNull);
        expect(secondChild.data()?['metrics']['answerSuccessRate'], 1.0);

        expect(provider.currentScope?.childUid, childUid);
        expect(provider.metrics?.answerSuccessRate, 0.5);

        await provider.fetchMetrics(
          parentUid: parentUid,
          childUid: otherChildUid,
        );

        expect(provider.currentScope?.childUid, otherChildUid);
        expect(provider.metrics?.answerSuccessRate, 1.0);
      },
    );

    test('fetches metrics from mock child profile data', () async {
      await _childDoc(firestore, parentUid, childUid).set({
        'right_answers_count': 3,
        'wrong_answers_count': 1,
        'metrics': PzHomeMetricsModel.fromJson(
          null,
        ).copyWith(answerSuccessRate: 0.25).toJson(),
      });
      await _childDoc(firestore, parentUid, childUid)
          .collection(AppConstants.completedContentCollection)
          .doc('story_story-1')
          .set({
            'id': 'story_story-1',
            'parent_id': parentUid,
            'child_id': childUid,
            'content_id': 'story-1',
            'content_name': 'Story One',
            'content_type': ActivityType.story.name,
            'created_at': '2026-01-01T00:00:00.000',
            'updated_at': '2026-01-01T00:00:00.000',
            'completed_count': 4,
          });
      await _childDoc(firestore, parentUid, childUid)
          .collection(AppConstants.completedContentCollection)
          .doc('song_song-1')
          .set({
            'id': 'song_song-1',
            'parent_id': parentUid,
            'child_id': childUid,
            'content_id': 'song-1',
            'content_name': 'Song One',
            'content_type': ActivityType.song.name,
            'created_at': '2026-01-01T00:00:00.000',
            'updated_at': '2026-01-01T00:00:00.000',
            'completed_count': 2,
          });

      await provider.fetchMetrics(parentUid: parentUid, childUid: childUid);

      expect(provider.completedContents, hasLength(2));
      expect(provider.metrics?.completedActivities, 2);
      expect(provider.metrics?.answerSuccessRate, 0.75);
      expect(provider.metrics?.mostPracticedTopics, ['Story One', 'Song One']);
      expect(provider.metrics?.topicCounts, {'Story One': 4, 'Song One': 2});
    });

    test('marks active days using the injected local date', () async {
      var currentDate = DateTime(2026, 7, 15);
      provider = PzMetricsProvider(
        firestore: firestore,
        now: () => currentDate,
      );

      await provider.trackActivityCompletion(
        parentUid: parentUid,
        childUid: childUid,
        topicName: 'Alphabet',
        activityType: ActivityType.lesson,
        contentId: 'lesson-1',
        contentName: 'Find Na',
      );

      expect(provider.metrics?.dayStreak, 1);
      expect(provider.metrics?.lastActiveDate, '2026-07-15');
      expect(provider.metrics?.weeklyStreak, [
        false,
        false,
        false,
        true,
        false,
        false,
        false,
      ]);

      await provider.trackActivityCompletion(
        parentUid: parentUid,
        childUid: childUid,
        topicName: 'Music',
        activityType: ActivityType.song,
        contentId: 'song-1',
        contentName: 'Song One',
      );

      expect(provider.metrics?.dayStreak, 1);
      expect(provider.metrics?.lastActiveDate, '2026-07-15');

      currentDate = DateTime(2026, 7, 16);
      await provider.trackActivityCompletion(
        parentUid: parentUid,
        childUid: childUid,
        topicName: 'Story',
        activityType: ActivityType.story,
        contentId: 'story-1',
        contentName: 'Story One',
      );

      expect(provider.metrics?.dayStreak, 2);
      expect(provider.metrics?.lastActiveDate, '2026-07-16');
      expect(provider.metrics?.weeklyStreak, [
        false,
        false,
        false,
        true,
        true,
        false,
        false,
      ]);

      currentDate = DateTime(2026, 7, 18);
      await provider.trackActivityCompletion(
        parentUid: parentUid,
        childUid: childUid,
        topicName: 'Alphabet',
        activityType: ActivityType.lesson,
        contentId: 'lesson-2',
        contentName: 'Trace Na',
      );

      expect(provider.metrics?.dayStreak, 1);
      expect(provider.metrics?.lastActiveDate, '2026-07-18');
      expect(provider.metrics?.weeklyStreak, [
        false,
        false,
        false,
        true,
        true,
        false,
        true,
      ]);
    });

    testWidgets('helper routes lesson, song, and story completions', (
      tester,
    ) async {
      BuildContext? testContext;
      SharedPreferences.setMockInitialValues({});
      await SharedPreferencesService.init();
      await ChildLocalStorage.saveCurrentChildId(childUid);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserProvider>.value(
              value: _MockUserProvider(parentUid),
            ),
            ChangeNotifierProvider<PzMetricsProvider>.value(value: provider),
            ChangeNotifierProvider<LessonProvider>(
              create: (_) => LessonProvider(firestore: firestore),
            ),
            ChangeNotifierProvider<SongProvider>(
              create: (_) => SongProvider(firestore: firestore),
            ),
            ChangeNotifierProvider<StoryProvider>(
              create: (_) =>
                  StoryProvider(repo: StoryRepo(firestore: firestore)),
            ),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      final context = testContext!;
      expect(context.mounted, isTrue);
      expect(context.read<UserProvider>().userId, parentUid);
      expect(context.read<LessonProvider>(), isA<LessonProvider>());
      expect(context.read<SongProvider>(), isA<SongProvider>());
      expect(context.read<StoryProvider>(), isA<StoryProvider>());
      expect(context.read<PzMetricsProvider>(), same(provider));
      expect(await ChildLocalStorage.getCurrentChildId(), childUid);
      await MetricsTrackingHelper.trackLessonCompletion(
        context: context,
        lessonId: 'lesson-1',
        topicName: 'Alphabet Lesson',
      );
      await MetricsTrackingHelper.trackSongCompletion(
        context: context,
        songId: 'song-1',
        songTitle: 'Song One',
        categoryName: 'Songs',
      );
      await MetricsTrackingHelper.trackStoryCompletion(
        context: context,
        storyId: 'Ant and the Bird',
        storyTitle: 'Story One',
      );

      final completions = await _childDoc(
        firestore,
        parentUid,
        childUid,
      ).collection(AppConstants.completedContentCollection).get();
      final completionData = {
        for (final doc in completions.docs) doc.id: doc.data(),
      };

      expect(completionData.keys, {
        'lesson_lesson-1',
        'song_song-1',
        'story_Ant and the Bird',
      });
      expect(completionData['lesson_lesson-1']?['content_type'], 'lesson');
      expect(
        completionData['lesson_lesson-1']?['content_name'],
        'Alphabet Lesson',
      );
      expect(completionData['song_song-1']?['content_type'], 'song');
      expect(completionData['song_song-1']?['content_name'], 'Song One');
      expect(
        completionData['story_Ant and the Bird']?['content_type'],
        'story',
      );
      expect(
        completionData['story_Ant and the Bird']?['content_name'],
        'Story One',
      );
      expect(provider.metrics?.completedActivities, 3);
    });

    testWidgets('helper skips metrics and completed state for guest users', (
      tester,
    ) async {
      BuildContext? testContext;
      SharedPreferences.setMockInitialValues({});
      await SharedPreferencesService.init();
      await ChildLocalStorage.saveCurrentChildId(childUid);
      await GuestUtil.setGuestUser(true);
      addTearDown(() async {
        await GuestUtil.setGuestUser(false);
      });

      await _childDoc(firestore, parentUid, childUid)
          .collection(AppConstants.completedContentCollection)
          .doc('lesson_lesson-1')
          .set({
            'id': 'lesson_lesson-1',
            'parent_id': parentUid,
            'child_id': childUid,
            'content_id': 'lesson-1',
            'content_name': 'Find Na',
            'content_type': ActivityType.lesson.name,
            'created_at': '2026-01-01T00:00:00.000',
            'updated_at': '2026-01-01T00:00:00.000',
            'completed_count': 5,
          });

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserProvider>.value(
              value: _MockUserProvider(parentUid),
            ),
            ChangeNotifierProvider<PzMetricsProvider>.value(value: provider),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      final context = testContext!;
      final completedLessonIds =
          await MetricsTrackingHelper.fetchCompletedContentIds(
            context: context,
            activityType: ActivityType.lesson,
          );
      await MetricsTrackingHelper.trackLessonCompletion(
        context: context,
        lessonId: 'lesson-2',
        topicName: 'Trace Na',
      );
      await MetricsTrackingHelper.trackAnswerAttempt(
        context: context,
        isCorrect: true,
      );

      final completions = await _childDoc(
        firestore,
        parentUid,
        childUid,
      ).collection(AppConstants.completedContentCollection).get();
      final childDoc = await _childDoc(firestore, parentUid, childUid).get();

      expect(completedLessonIds, isEmpty);
      expect(completions.docs.map((doc) => doc.id), ['lesson_lesson-1']);
      expect(childDoc.data()?['right_answers_count'], isNull);
      expect(childDoc.data()?['wrong_answers_count'], isNull);
    });
  });
}

class _MockUserProvider extends UserProvider {
  _MockUserProvider(this._userId);

  final String _userId;

  @override
  String? get userId => _userId;
}

DocumentReference<Map<String, dynamic>> _childDoc(
  FakeFirebaseFirestore firestore,
  String parentUid,
  String childUid,
) {
  return firestore
      .collection(AppConstants.usersCollection)
      .doc(parentUid)
      .collection(AppConstants.childrenCollection)
      .doc(childUid);
}
