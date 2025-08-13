// Tests for recommended_story_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onepali/src/core/model/recommended/recommended_story_model.dart';

void main() {
  group('RecommendedStoryModel', () {
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
        'storyId': 'story456',
        'progress': 3,
        'lastWatched': timestamp,
        'title': 'Test Story',
        'image': 'story_image.png',
      };

      final model = RecommendedStoryModel.fromJson(json);
      expect(model.childId, 'child123');
      expect(model.storyId, 'story456');
      expect(model.progress, 3);
      expect(model.lastWatched, timestamp);
      expect(model.title, 'Test Story');
      expect(model.image, 'story_image.png');

      final toJson = model.toJson();
      expect(toJson['childId'], 'child123');
      expect(toJson['storyId'], 'story456');
      expect(toJson['progress'], 3);
      expect(toJson['lastWatched'], timestamp);
      expect(toJson['title'], 'Test Story');
      expect(toJson['image'], 'story_image.png');
    });

    test('should handle null and empty fields gracefully', () {
      final json = {'childId': 'child123', 'storyId': 'story456'};

      final model = RecommendedStoryModel.fromJson(json);
      expect(model.childId, 'child123');
      expect(model.storyId, 'story456');
      expect(model.progress, 0);
      expect(model.lastWatched, isA<Timestamp>());
      expect(model.title, '');
      expect(model.image, '');
    });

    test('should create model with all required parameters', () {
      final timestamp = Timestamp.now();
      final model = RecommendedStoryModel(
        childId: 'child789',
        storyId: 'story101',
        progress: 5,
        lastWatched: timestamp,
        title: 'Adventure Story',
        image: 'adventure.png',
      );

      expect(model.childId, 'child789');
      expect(model.storyId, 'story101');
      expect(model.progress, 5);
      expect(model.lastWatched, timestamp);
      expect(model.title, 'Adventure Story');
      expect(model.image, 'adventure.png');
    });

    test('should handle zero progress correctly', () {
      final json = {
        'childId': 'child123',
        'storyId': 'story456',
        'progress': 0,
        'lastWatched': Timestamp.now(),
        'title': 'New Story',
        'image': 'new_story.png',
      };

      final model = RecommendedStoryModel.fromJson(json);
      expect(model.progress, 0);
      expect(model.title, 'New Story');
    });
  });
}
