// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: json['id'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
};

InfoLessonContent _$InfoLessonContentFromJson(Map<String, dynamic> json) =>
    InfoLessonContent(
      id: json['id'] as String,
      index: (json['index'] as num).toInt(),
      type: json['type'] as String? ?? 'info',
      nameEn: json['name_en'] as String,
      nameNp: json['name_np'] as String,
      audioWord: json['audio_word'] as String,
      audioBg: json['audio_bg'] as String,
      image: json['image'] as String,
      video: json['video'] as String,
      bgImageColor: json['bg_image_color'] as String?,
    );

Map<String, dynamic> _$InfoLessonContentToJson(InfoLessonContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'type': instance.type,
      'name_en': instance.nameEn,
      'name_np': instance.nameNp,
      'audio_word': instance.audioWord,
      'audio_bg': instance.audioBg,
      'image': instance.image,
      'video': instance.video,
      'bg_image_color': instance.bgImageColor,
    };

ChooseCorrectLessonContent _$ChooseCorrectLessonContentFromJson(
  Map<String, dynamic> json,
) => ChooseCorrectLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  type: json['type'] as String? ?? 'choose_correct',
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ChooseCorrectLessonContentToJson(
  ChooseCorrectLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'type': instance.type,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

TapToRevealLessonContent _$TapToRevealLessonContentFromJson(
  Map<String, dynamic> json,
) => TapToRevealLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  type: json['type'] as String? ?? 'tap_to_reveal',
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TapToRevealLessonContentToJson(
  TapToRevealLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'type': instance.type,
  'items': instance.items,
};

UnknownLessonContent _$UnknownLessonContentFromJson(
  Map<String, dynamic> json,
) => UnknownLessonContent(
  id: json['id'] as String? ?? '',
  index: (json['index'] as num?)?.toInt() ?? -1,
  type: json['type'] as String? ?? 'unknown',
);

Map<String, dynamic> _$UnknownLessonContentToJson(
  UnknownLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'type': instance.type,
};

_Item _$ItemFromJson(Map<String, dynamic> json) => _Item(
  nameEn: json['name_en'] as String,
  nameNp: json['name_np'] as String,
  image: json['image'] as String,
  question: json['question'] as String,
  audioItem: json['audio_item'] as String,
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'name_en': instance.nameEn,
  'name_np': instance.nameNp,
  'image': instance.image,
  'question': instance.question,
  'audio_item': instance.audioItem,
};
