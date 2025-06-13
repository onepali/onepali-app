// Tests for song_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/song/song_model.dart';

void main() {
  group('SongModel', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'id': '1',
        'title_en': 'Song',
        'title_ne': 'गीत',
        'youtube_title_en': 'YouTube Song',
        'youtube_title_ne': 'युट्युब गीत',
        'age_group': '5-7',
        'type': 'music',
        'language': ['en', 'ne'],
        'media': {'youtube_link': 'https://youtube.com'},
        'rank': 1,
        'tags': ['tag1', 'tag2'],
        'categoryName': 'Songs',
      };
      final model = SongModel.fromJson(json);
      expect(model.id, '1');
      expect(model.titleEn, 'Song');
      expect(model.titleNe, 'गीत');
      expect(model.youtubeTitleEn, 'YouTube Song');
      expect(model.youtubeTitleNe, 'युट्युब गीत');
      expect(model.ageGroup, '5-7');
      expect(model.type, 'music');
      expect(model.language, ['en', 'ne']);
      expect(model.media.youtubeLink, 'https://youtube.com');
      expect(model.rank, 1);
      expect(model.tags, ['tag1', 'tag2']);
      expect(model.categoryName, 'Songs');
      final toJson = model.toJson();
      expect(toJson['id'], '1');
      expect(toJson['title_en'], 'Song');
      expect(toJson['media']['youtube_link'], 'https://youtube.com');
    });
  });
}
