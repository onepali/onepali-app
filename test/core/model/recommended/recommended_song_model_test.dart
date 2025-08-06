// Tests for recommended_song_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onepali/src/src.dart';

void main() {
  group('RcmSongsModel', () {
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
      final json = {
        'childId': '2',
        'songId': 'song123',
        'progress': 0.5,
        'lastWatched': Timestamp.now(),
        'isCompleted': 1,
        'title': 'Song',
        'youtubeLink': 'https://youtube.com',
        'image': 'img.png',
      };
      final model = RcmSongsModel.fromJson(json);
      expect(model.childId, '2');
      expect(model.songId, 'song123');
      expect(model.progress, 0.5);
      expect(model.lastWatched, isA<Timestamp>());
      expect(model.isCompleted, 1);
      expect(model.title, 'Song');
      expect(model.youtubeLink, 'https://youtube.com');
      expect(model.image, 'img.png');

      final toJson = model.toJson();
      expect(toJson['songId'], 'song123');
      expect(toJson['progress'], 0.5);
      expect(toJson['lastWatched'], isA<Timestamp>());
      expect(toJson['isCompleted'], 1);
      expect(toJson['title'], 'Song');
      expect(toJson['youtubeLink'], 'https://youtube.com');
      expect(toJson['image'], 'img.png');
    });
  });
}
