// Tests for story_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/story/story_model.dart';

void main() {
  group('StoryModel', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'nameEn': 'Test Story',
        'nameNp': 'परीक्षण कथा',
        'thumbnail': 'thumbnail.png',
        'bg_image_mobile': 'intro-mobile.png',
        'bg_image_tablet': 'intro-tablet.png',
        'lottie': 'lottie.json',
        'audio': ['audio1.mp3', 'audio2.mp3'],
        'tooltip': 'Test tooltip',
        'description': 'Test description',
        'content': [
          {
            'image': 'image1.png',
            'audio': ['content_audio.mp3'],
            'lottie': 'content_lottie.json',
            'type': 'slide',
            'conversation': [
              {
                'id': 'conv1',
                'messageEn': 'Hello',
                'messageNp': 'नमस्ते',
                'icon': 'icon.png',
                'correct': true,
              },
            ],
            'character': ['character1'],
            'confetti': 'confetti.json',
          },
        ],
      };

      final model = StoryModel.fromJson(json);
      expect(model.nameEn, 'Test Story');
      expect(model.nameNp, 'परीक्षण कथा');
      expect(model.thumbnail, 'thumbnail.png');
      expect(model.bgImageMobile, 'intro-mobile.png');
      expect(model.bgImageTablet, 'intro-tablet.png');
      expect(model.lottie, 'lottie.json');
      expect(model.audio, ['audio1.mp3', 'audio2.mp3']);
      expect(model.tooltip, 'Test tooltip');
      expect(model.description, 'Test description');
      expect(model.content.length, 1);

      final toJson = model.toJson();
      expect(toJson['nameEn'], 'Test Story');
      expect(toJson['nameNp'], 'परीक्षण कथा');
      expect(toJson['thumbnail'], 'thumbnail.png');
      expect(toJson['bg_image_mobile'], 'intro-mobile.png');
      expect(toJson['bg_image_tablet'], 'intro-tablet.png');
      expect(toJson['content'], isA<List>());
    });

    test('should handle null and empty fields gracefully', () {
      final json = {'nameEn': 'Minimal Story', 'nameNp': 'न्यूनतम कथा'};

      final model = StoryModel.fromJson(json);
      expect(model.nameEn, 'Minimal Story');
      expect(model.nameNp, 'न्यूनतम कथा');
      expect(model.thumbnail, '');
      expect(model.bgImageMobile, isNull);
      expect(model.bgImageTablet, isNull);
      expect(model.lottie, '');
      expect(model.audio, []);
      expect(model.tooltip, '');
      expect(model.description, '');
      expect(model.content, []);
    });

    test('should coerce audio values to strings', () {
      final model = StoryModel.fromJson({
        'audio': [1, 'audio2.mp3'],
      });

      expect(model.audio, ['1', 'audio2.mp3']);
    });
  });

  group('Content', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'image': 'content_image.png',
        'audio': ['content_audio.mp3'],
        'lottie': 'content_lottie.json',
        'type': 'interactive',
        'conversation': [
          {
            'id': 'conv1',
            'messageEn': 'Hello',
            'messageNp': 'नमस्ते',
            'icon': 'icon.png',
            'correct': true,
          },
        ],
        'character': ['character1', 'character2'],
        'confetti': 'confetti.json',
      };

      final content = Content.fromJson(json);
      expect(content.image, 'content_image.png');
      expect(content.audio, ['content_audio.mp3']);
      expect(content.lottie, 'content_lottie.json');
      expect(content.type, 'interactive');
      expect(content.conversation.length, 1);
      expect(content.characters, ['character1', 'character2']);
      expect(content.confetti, 'confetti.json');

      final toJson = content.toJson();
      expect(toJson['image'], 'content_image.png');
      expect(toJson['type'], 'interactive');
      expect(toJson['conversation'], isA<List>());
    });

    test('should handle empty conversation list', () {
      final json = {'image': 'test.png', 'type': 'simple', 'confetti': ''};

      final content = Content.fromJson(json);
      expect(content.conversation, []);
      expect(content.characters, []);
      expect(content.audio, []);
    });

    test('should coerce audio and character values to strings', () {
      final content = Content.fromJson({
        'audio': [1, 'audio2.mp3'],
        'character': [2, 'character2'],
      });

      expect(content.audio, ['1', 'audio2.mp3']);
      expect(content.characters, ['2', 'character2']);
    });
  });

  group('Conversation', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        'id': 'conv123',
        'messageEn': 'Test message',
        'messageNp': 'परीक्षण सन्देश',
        'icon': 'test_icon.png',
        'correct': true,
      };

      final conversation = Conversation.fromJson(json);
      expect(conversation.id, 'conv123');
      expect(conversation.messageEn, 'Test message');
      expect(conversation.messageNp, 'परीक्षण सन्देश');
      expect(conversation.icon, 'test_icon.png');
      expect(conversation.correct, true);

      final toJson = conversation.toJson();
      expect(toJson['id'], 'conv123');
      expect(toJson['messageEn'], 'Test message');
      expect(toJson['messageNp'], 'परीक्षण सन्देश');
      expect(toJson['correct'], true);
    });

    test('should handle default values', () {
      final json = {'id': '1', 'messageEn': 'Hello'};

      final conversation = Conversation.fromJson(json);
      expect(conversation.id, '1');
      expect(conversation.messageEn, 'Hello');
      expect(conversation.messageNp, '');
      expect(conversation.icon, '');
      expect(conversation.correct, false);
    });
  });

  group('Helper functions', () {
    test('storyModelFromJson should parse JSON string', () {
      const jsonString = '''
      [
        {
          "nameEn": "Story 1",
          "nameNp": "कथा १",
          "thumbnail": "thumb1.png",
          "lottie": "lottie1.json",
          "audio": [],
          "tooltip": "tooltip1",
          "description": "desc1",
          "content": []
        }
      ]
      ''';

      final stories = storyModelFromJson(jsonString);
      expect(stories.length, 1);
      expect(stories.first.nameEn, 'Story 1');
      expect(stories.first.nameNp, 'कथा १');
    });

    test('storyModelToJson should convert to JSON string', () {
      final stories = [
        StoryModel(
          levelId: 'level1',
          nameEn: 'Story 1',
          nameNp: 'कथा १',
          thumbnail: 'thumb1.png',
          lottie: 'lottie1.json',
          audio: [],
          tooltip: 'tooltip1',
          description: 'desc1',
          content: [],
        ),
      ];

      final jsonString = storyModelToJson(stories);
      expect(jsonString, isA<String>());
      expect(jsonString, contains('Story 1'));
      expect(jsonString, contains('कथा १'));
    });
  });
}
