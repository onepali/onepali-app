// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => _StoryModel(
  levelId: json['level_id'] as String? ?? '',
  nameEn: json['nameEn'] as String? ?? '',
  nameNp: json['nameNp'] as String? ?? '',
  thumbnail: json['thumbnail'] as String? ?? '',
  lottie: json['lottie'] as String? ?? '',
  audio: json['audio'] == null
      ? const <String>[]
      : _stringListFromJson(json['audio']),
  tooltip: json['tooltip'] as String? ?? '',
  description: json['description'] as String? ?? '',
  content:
      (json['content'] as List<dynamic>?)
          ?.map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Content>[],
  bgColor: json['bg_color'] as String?,
);

Map<String, dynamic> _$StoryModelToJson(_StoryModel instance) =>
    <String, dynamic>{
      'level_id': instance.levelId,
      'nameEn': instance.nameEn,
      'nameNp': instance.nameNp,
      'thumbnail': instance.thumbnail,
      'lottie': instance.lottie,
      'audio': instance.audio,
      'tooltip': instance.tooltip,
      'description': instance.description,
      'content': instance.content.map((e) => e.toJson()).toList(),
      'bg_color': instance.bgColor,
    };

_Content _$ContentFromJson(Map<String, dynamic> json) => _Content(
  image: json['image'] as String? ?? '',
  imageTb: json['image_tb'] as String?,
  imageSuccess: json['image_success'] as String?,
  imageSuccessTb: json['image_success_tb'] as String?,
  audio: json['audio'] == null
      ? const <String>[]
      : _stringListFromJson(json['audio']),
  lottie: json['lottie'] as String? ?? '',
  type: json['type'] as String? ?? '',
  conversation:
      (json['conversation'] as List<dynamic>?)
          ?.map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Conversation>[],
  characters: json['character'] == null
      ? const <String>[]
      : _stringListFromJson(json['character']),
  confetti: json['confetti'] as String? ?? '',
);

Map<String, dynamic> _$ContentToJson(_Content instance) => <String, dynamic>{
  'image': instance.image,
  'image_tb': instance.imageTb,
  'image_success': instance.imageSuccess,
  'image_success_tb': instance.imageSuccessTb,
  'audio': instance.audio,
  'lottie': instance.lottie,
  'type': instance.type,
  'conversation': instance.conversation.map((e) => e.toJson()).toList(),
  'character': instance.characters,
  'confetti': instance.confetti,
};

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      id: json['id'] == null ? '' : _idFromJson(json['id']),
      messageEn: json['messageEn'] as String? ?? '',
      messageNp: json['messageNp'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      correct: json['correct'] as bool? ?? false,
      question: json['question'] as String?,
      audioItem: json['audioItem'] as String?,
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messageEn': instance.messageEn,
      'messageNp': instance.messageNp,
      'icon': instance.icon,
      'correct': instance.correct,
      'question': instance.question,
      'audioItem': instance.audioItem,
    };
