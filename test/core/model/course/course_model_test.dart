import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/course/course_model.dart';

void main() {
  group('CourseModel', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'courses': [
          {
            'id': '1',
            'name_en': 'Course',
            'name_np': 'पाठ्यक्रम',
            'thumbnail': 'thumb.png',
            'audio': 'audio.mp3',
            'age_group': '5-7',
            'categoryName': 'Test',
            'type': 'main',
            'tags': ['tag1', 'tag2'],
            'completion_criteria': 'all',
            'chapters': [],
            'lessons': [
              {
                'id': 'l1',
                'chapter_id': 'c1',
                'lesson_name': 'Lesson 1',
                'short_info': 'Short info',
                'type': 'type1',
                'progress': '0%',
                'completion_criteria': 'all',
                'thumbnail': 'lesson.png',
                'rank': 1,
                'prerequisites': [],
                'lesson_content': [
                  {
                    'name_en': 'Content EN',
                    'name_np': 'Content NP',
                    'image': 'img.png',
                    'lottie': 'anim.json',
                    'audio': 'audio.mp3',
                    'word_audio': 'word.mp3',
                    'tooltip': 'tip',
                  },
                ],
              },
            ],
            'level_unlock_criteria': {
              'type': 'score',
              'value': 10,
              'description': 'desc',
            },
          },
        ],
      };
      final model = CourseModel.fromJson(json);
      expect(model.courses.length, 1);
      final course = model.courses.first;
      expect(course.id, '1');
      expect(course.nameEn, 'Course');
      expect(course.lessons.length, 1);
      final lesson = course.lessons.first;
      expect(lesson.id, 'l1');
      expect(lesson.lessonName, 'Lesson 1');
      expect(lesson.lessonContent.length, 1);
      final content = lesson.lessonContent.first;
      expect(content.nameEn, 'Content EN');
      expect(content.tooltip, 'tip');
      final toJson = model.toJson();
      expect(toJson['courses'][0]['id'], '1');
      expect(toJson['courses'][0]['lessons'][0]['id'], 'l1');
      expect(
        toJson['courses'][0]['lessons'][0]['lesson_content'][0]['name_en'],
        'Content EN',
      );
    });
  });
}
