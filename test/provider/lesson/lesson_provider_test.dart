import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/constants/app_constants.dart';
import 'package:onepali/src/core/services/child_local_storage.dart';
import 'package:onepali/src/core/services/shared_pref_service.dart';
import 'package:onepali/src/provider/lesson/lesson_provider.dart';
import 'package:onepali/src/provider/user/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LessonProvider', () {
    const parentUid = 'parent-1';
    const childUid = 'child-1';
    const otherChildUid = 'child-2';

    late FakeFirebaseFirestore firestore;
    late LessonProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPreferencesService.init();
      await ChildLocalStorage.saveCurrentChildId(childUid);

      firestore = FakeFirebaseFirestore();
      provider = LessonProvider(firestore: firestore);

      await _childDoc(firestore, parentUid, childUid).set({'uid': childUid});
      await _childDoc(
        firestore,
        parentUid,
        otherChildUid,
      ).set({'uid': otherChildUid});
    });

    testWidgets('completed lesson summary is scoped to the selected child', (
      tester,
    ) async {
      final context = await _pumpProviderContext(
        tester,
        provider: provider,
        parentUid: parentUid,
      );

      await provider.incrementTotalLessonsCompleted(
        context,
        'lesson-1',
        'The Pets',
      );

      final childData = (await _childDoc(
        firestore,
        parentUid,
        childUid,
      ).get()).data();
      final otherChildData = (await _childDoc(
        firestore,
        parentUid,
        otherChildUid,
      ).get()).data();

      expect(childData?['completedLessons'], {
        'totalLessonsCompleted': 1,
        'lessons': [
          {'id': 'lesson-1', 'name': 'The Pets'},
        ],
      });
      expect(otherChildData?['completedLessons'], isNull);
    });

    testWidgets('duplicate lessons do not increase completed lesson summary', (
      tester,
    ) async {
      final context = await _pumpProviderContext(
        tester,
        provider: provider,
        parentUid: parentUid,
      );

      await provider.incrementTotalLessonsCompleted(
        context,
        'lesson-1',
        'The Pets',
      );
      await provider.incrementTotalLessonsCompleted(
        context,
        'lesson-1',
        'The Pets',
      );
      await provider.incrementTotalLessonsCompleted(
        context,
        'lesson-2',
        'Alphabet',
      );

      final childData = (await _childDoc(
        firestore,
        parentUid,
        childUid,
      ).get()).data();

      expect(childData?['completedLessons']['totalLessonsCompleted'], 2);
      expect(childData?['completedLessons']['lessons'], [
        {'id': 'lesson-1', 'name': 'The Pets'},
        {'id': 'lesson-2', 'name': 'Alphabet'},
      ]);
    });
  });
}

Future<BuildContext> _pumpProviderContext(
  WidgetTester tester, {
  required LessonProvider provider,
  required String parentUid,
}) async {
  BuildContext? testContext;
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(
          value: _MockUserProvider(parentUid),
        ),
        ChangeNotifierProvider<LessonProvider>.value(value: provider),
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

  return testContext!;
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
