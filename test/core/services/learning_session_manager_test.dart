// Tests for learning_session_manager.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:onepali/src/core/services/learning_session_manager.dart';

void main() {
  group('LearningSessionManager', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock SharedPreferences for session storage
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('plugins.flutter.io/shared_preferences', (
            message,
          ) async {
            return const StandardMessageCodec().encodeMessage(<String, dynamic>{
              'flutter.learning_session': '{}',
            });
          });
    });

    test('should create LearningSessionManager instance', () {
      final manager = LearningSessionManager();
      expect(manager, isA<LearningSessionManager>());
    });

    test('should handle learning session management', () {
      final manager = LearningSessionManager();
      expect(manager, isNotNull);
    });
  });
}
