// Tests for laudio_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/lesson/laudio_provider.dart';

void main() {
  group('LessonAudioProvider', () {
    test('should create LessonAudioProvider instance', () {
      final provider = LessonAudioProvider();
      expect(provider, isA<LessonAudioProvider>());
    });
  });
}
