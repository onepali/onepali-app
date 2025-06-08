// Tests for lesson_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/lesson/lesson_provider.dart';

void main() {
  group('LessonProvider', () {
    test('should create LessonProvider instance', () {
      final provider = LessonProvider();
      expect(provider, isA<LessonProvider>());
    });
  });
}
