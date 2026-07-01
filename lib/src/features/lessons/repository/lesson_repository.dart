import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:rxdart/rxdart.dart';

class LessonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<LessonDetail> watchLessonWithContents(String lessonId) {
    final lessonStream = _firestore
        .collection('lessons')
        .doc(lessonId)
        .snapshots()
        .map((doc) => Lesson.fromJson(doc.data()!));

    final contentsStream = _firestore
        .collection('lessons')
        .doc(lessonId)
        .collection('contents')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LessonContent.fromJson(doc.data()))
              .toList(),
        );

    return Rx.combineLatest2<Lesson, List<LessonContent>, LessonDetail>(
      lessonStream,
      contentsStream,
      (lesson, contents) => LessonDetail(lesson: lesson, contents: contents),
    );
  }
}
