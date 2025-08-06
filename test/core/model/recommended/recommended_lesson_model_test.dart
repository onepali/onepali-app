// Tests for recommended_lesson_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onepali/src/core/model/recommended/recommended_lesson_model.dart';

void main() {
  group('RecommendedLessonModel', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock Firestore
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('plugins.flutter.io/cloud_firestore', (
            message,
          ) async {
            return null;
          });
    });

    test('fromJson and toJson should work correctly', () {
      final timestamp = Timestamp.now();
      final json = {
        'childId': 'child123',
        'lessonId': 'lesson456',
        'progress': 7,
        'lastWatched': timestamp,
        'title': 'Math Lesson',
        'image': 'math_lesson.png',
      };

      final model = RecommendedLessonModel.fromJson(json);
      expect(model.childId, 'child123');
      expect(model.lessonId, 'lesson456');
      expect(model.progress, 7);
      expect(model.lastWatched, timestamp);
      expect(model.title, 'Math Lesson');
      expect(model.image, 'math_lesson.png');

      final toJson = model.toJson();
      expect(toJson['childId'], 'child123');
      expect(toJson['lessonId'], 'lesson456');
      expect(toJson['progress'], 7);
      expect(toJson['lastWatched'], timestamp);
      expect(toJson['title'], 'Math Lesson');
      expect(toJson['image'], 'math_lesson.png');
    });

    test('should handle null and empty fields gracefully', () {
      final json = {'childId': 'child123', 'lessonId': 'lesson456'};

      final model = RecommendedLessonModel.fromJson(json);
      expect(model.childId, 'child123');
      expect(model.lessonId, 'lesson456');
      expect(model.progress, 0);
      expect(model.lastWatched, isA<Timestamp>());
      expect(model.title, '');
      expect(model.image, '');
    });

    test('should create model with all required parameters', () {
      final timestamp = Timestamp.now();
      final model = RecommendedLessonModel(
        childId: 'child789',
        lessonId: 'lesson101',
        progress: 10,
        lastWatched: timestamp,
        title: 'Science Lesson',
        image: 'science.png',
      );

      expect(model.childId, 'child789');
      expect(model.lessonId, 'lesson101');
      expect(model.progress, 10);
      expect(model.lastWatched, timestamp);
      expect(model.title, 'Science Lesson');
      expect(model.image, 'science.png');
    });

    test('should handle high progress values', () {
      final json = {
        'childId': 'child123',
        'lessonId': 'lesson456',
        'progress': 100,
        'lastWatched': Timestamp.now(),
        'title': 'Completed Lesson',
        'image': 'completed.png',
      };

      final model = RecommendedLessonModel.fromJson(json);
      expect(model.progress, 100);
      expect(model.title, 'Completed Lesson');
    });

    test('should maintain lesson vs story distinction', () {
      final model = RecommendedLessonModel(
        childId: 'child1',
        lessonId: 'lesson1',
        progress: 5,
        lastWatched: Timestamp.now(),
        title: 'Alphabet Lesson',
        image: 'alphabet.png',
      );

      // Verify it's specifically for lessons, not stories or songs
      expect(model.lessonId, isNotEmpty);
      expect(model.lessonId, startsWith('lesson'));
    });
  });
}
