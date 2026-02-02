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

IntroLessonContent _$IntroLessonContentFromJson(Map<String, dynamic> json) =>
    IntroLessonContent(
      id: json['id'] as String,
      index: (json['index'] as num).toInt(),
      type: json['type'] as String? ?? 'intro',
      bgColor: json['bg_color'] as String?,
      image: json['image'] as String?,
      audio: json['audio'] as String?,
    );

Map<String, dynamic> _$IntroLessonContentToJson(IntroLessonContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'type': instance.type,
      'bg_color': instance.bgColor,
      'image': instance.image,
      'audio': instance.audio,
    };

InfoLessonContent _$InfoLessonContentFromJson(Map<String, dynamic> json) =>
    InfoLessonContent(
      id: json['id'] as String,
      index: (json['index'] as num).toInt(),
      type: json['type'] as String? ?? 'info',
      nameEn: json['name_en'] as String,
      nameNp: json['name_np'] as String,
      audioWord: json['audio_word'] as String,
      audioBg: json['audio_bg'] as String?,
      image: json['image'] as String,
      video: json['video'] as String?,
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
  bgImage: json['bg_image'] as String?,
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
  'bg_image': instance.bgImage,
  'type': instance.type,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

DragToMatchLessonContent _$DragToMatchLessonContentFromJson(
  Map<String, dynamic> json,
) => DragToMatchLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  type: json['type'] as String? ?? 'drag_to_match',
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DragToMatchLessonContentToJson(
  DragToMatchLessonContent instance,
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
  imageOutline: json['image_outline'] as String?,
  question: json['question'] as String?,
  audioItem: json['audio_item'] as String,
  audioBg: json['audio_bg'] as String?,
  dxRatio: json['dx_ratio'] as num?,
  dyRatio: json['dy_ratio'] as num?,
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'name_en': instance.nameEn,
  'name_np': instance.nameNp,
  'image': instance.image,
  'image_outline': instance.imageOutline,
  'question': instance.question,
  'audio_item': instance.audioItem,
  'audio_bg': instance.audioBg,
  'dx_ratio': instance.dxRatio,
  'dy_ratio': instance.dyRatio,
};
