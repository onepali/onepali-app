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
        .map((doc) {
          final data = doc.data();
          if (!doc.exists || data == null) {
            throw StateError('Lesson $lessonId not found');
          }

          return Lesson.fromJson({...data, 'id': data['id'] ?? doc.id});
        });

    final contentsStream = _firestore
        .collection('lessons')
        .doc(lessonId)
        .collection('contents')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return LessonContent.fromJson({
              ...data,
              'id': data['id'] ?? doc.id,
            });
          }).toList(),
        );

    return Rx.combineLatest2<Lesson, List<LessonContent>, LessonDetail>(
      lessonStream,
      contentsStream,
      (lesson, contents) => LessonDetail(lesson: lesson, contents: contents),
    );
  }
}
