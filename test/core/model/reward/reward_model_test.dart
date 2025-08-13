// Tests for reward_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/reward/reward_model.dart';

void main() {
  group('RewardModel', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'id': 'reward123',
        'title_np': 'इनाम',
        'title_en': 'Reward',
        'description_np': 'यो एक परीक्षण इनाम हो',
        'description_en': 'This is a test reward',
        's_audio': 'reward_audio.mp3',
        'image': 'reward_image.png',
        'image_outline': 'reward_outline.png',
      };

      final model = RewardModel.fromJson(json);
      expect(model.id, 'reward123');
      expect(model.titleNp, 'इनाम');
      expect(model.titleEn, 'Reward');
      expect(model.descriptionNp, 'यो एक परीक्षण इनाम हो');
      expect(model.descriptionEn, 'This is a test reward');
      expect(model.sAudio, 'reward_audio.mp3');
      expect(model.image, 'reward_image.png');
      expect(model.imageOutline, 'reward_outline.png');

      final toJson = model.toJson();
      expect(toJson['id'], 'reward123');
      expect(toJson['title_np'], 'इनाम');
      expect(toJson['title_en'], 'Reward');
      expect(toJson['description_np'], 'यो एक परीक्षण इनाम हो');
      expect(toJson['description_en'], 'This is a test reward');
      expect(toJson['s_audio'], 'reward_audio.mp3');
      expect(toJson['image'], 'reward_image.png');
      expect(toJson['image_outline'], 'reward_outline.png');
    });

    test('should handle null and empty fields gracefully', () {
      final json = {'id': 'minimal_reward', 'title_en': 'Minimal Reward'};

      final model = RewardModel.fromJson(json);
      expect(model.id, 'minimal_reward');
      expect(model.titleEn, 'Minimal Reward');
      expect(model.titleNp, '');
      expect(model.descriptionNp, '');
      expect(model.descriptionEn, '');
      expect(model.sAudio, '');
      expect(model.image, '');
      expect(model.imageOutline, '');
    });

    test('should handle missing imageOutline field', () {
      final json = {
        'id': 'reward_no_outline',
        'title_np': 'इनाम',
        'title_en': 'Reward',
        'description_np': 'विवरण',
        'description_en': 'Description',
        's_audio': 'audio.mp3',
        'image': 'image.png',
      };

      final model = RewardModel.fromJson(json);
      expect(model.imageOutline, '');
    });
  });

  group('Helper functions', () {
    test('rewardModelFromJson should parse JSON string', () {
      const jsonString = '''
      [
        {
          "id": "1",
          "title_np": "इनाम १",
          "title_en": "Reward 1",
          "description_np": "विवरण १",
          "description_en": "Description 1",
          "s_audio": "audio1.mp3",
          "image": "image1.png"
        },
        {
          "id": "2",
          "title_np": "इनाम २",
          "title_en": "Reward 2",
          "description_np": "विवरण २",
          "description_en": "Description 2",
          "s_audio": "audio2.mp3",
          "image": "image2.png"
        }
      ]
      ''';

      final rewards = rewardModelFromJson(jsonString);
      expect(rewards.length, 2);
      expect(rewards.first.id, '1');
      expect(rewards.first.titleEn, 'Reward 1');
      expect(rewards.last.id, '2');
      expect(rewards.last.titleEn, 'Reward 2');
    });

    test('rewardModelToJson should convert to JSON string', () {
      final rewards = [
        RewardModel(
          id: '1',
          titleNp: 'इनाम',
          titleEn: 'Reward',
          descriptionNp: 'विवरण',
          descriptionEn: 'Description',
          sAudio: 'audio.mp3',
          image: 'image.png',
          imageOutline: 'outline.png',
        ),
      ];

      final jsonString = rewardModelToJson(rewards);
      expect(jsonString, isA<String>());
      expect(jsonString, contains('Reward'));
      expect(jsonString, contains('इनाम'));
      expect(jsonString, contains('image.png'));
    });
  });
}
