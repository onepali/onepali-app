// Tests for recommended_song_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/src.dart';

void main() {
  group('RcmSongsModel', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'id': 1,
        'childId': 2,
        'songId': 'song123',
        'progress': 0.5,
        'lastWatched': '2025-06-08T12:00:00.000',
        'isCompleted': 1,
        'title': 'Song',
        'youtubeLink': 'https://youtube.com',
        'image': 'img.png',
      };
      final model = RcmSongsModel.fromJson(json);
      expect(model.id, 1);
      expect(model.childId, 2);
      expect(model.songId, 'song123');
      expect(model.progress, 0.5);
      expect(model.lastWatched, '2025-06-08T12:00:00.000');
      expect(model.isCompleted, 1);
      expect(model.title, 'Song');
      expect(model.youtubeLink, 'https://youtube.com');
      expect(model.image, 'img.png');
      final toJson = model.toJson();
      expect(toJson['id'], 1);
      expect(toJson['childId'], 2);
      expect(toJson['songId'], 'song123');
      expect(toJson['progress'], 0.5);
      expect(toJson['lastWatched'], '2025-06-08T12:00:00.000');
      expect(toJson['isCompleted'], 1);
      expect(toJson['title'], 'Song');
      expect(toJson['youtubeLink'], 'https://youtube.com');
      expect(toJson['image'], 'img.png');
    });
  });
}
