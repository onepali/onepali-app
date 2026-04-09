// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: json['id'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
  bgImage: json['bgImage'] as String?,
  active: json['active'] as bool? ?? false,
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
  'bgImage': instance.bgImage,
  'active': instance.active,
};

IntroLessonContent _$IntroLessonContentFromJson(Map<String, dynamic> json) =>
    IntroLessonContent(
      id: json['id'] as String,
      index: (json['index'] as num).toInt(),
      type: json['type'] as String? ?? 'intro',
      bgColor: json['bg_color'] as String?,
      image: json['image'] as String?,
      audio: json['audio'] as String?,
      bgImageMobile: json['bg_image_mobile'] as String?,
      bgImageTablet: json['bg_image_tablet'] as String?,
    );

Map<String, dynamic> _$IntroLessonContentToJson(IntroLessonContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'type': instance.type,
      'bg_color': instance.bgColor,
      'image': instance.image,
      'audio': instance.audio,
      'bg_image_mobile': instance.bgImageMobile,
      'bg_image_tablet': instance.bgImageTablet,
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
      isImageSvg: json['is_image_svg'] as bool? ?? false,
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
      'is_image_svg': instance.isImageSvg,
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

TapToPopLessonContent _$TapToPopLessonContentFromJson(
  Map<String, dynamic> json,
) => TapToPopLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  bgImage: json['bg_image'] as String?,
  successImage: json['success_image'] as String?,
  bgColor: json['bg_color'] as String?,
  audioWord: json['audio_word'] as String?,
  instructionAudio: json['instruction_audio'] as String?,
  type: json['type'] as String? ?? 'tap_to_pop',
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TapToPopLessonContentToJson(
  TapToPopLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'bg_image': instance.bgImage,
  'success_image': instance.successImage,
  'bg_color': instance.bgColor,
  'audio_word': instance.audioWord,
  'instruction_audio': instance.instructionAudio,
  'type': instance.type,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

ListenAndRepeatLessonContent _$ListenAndRepeatLessonContentFromJson(
  Map<String, dynamic> json,
) => ListenAndRepeatLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  type: json['type'] as String? ?? 'listen_and_repeat',
  nameEn: json['name_en'] as String,
  nameNp: json['name_np'] as String,
  bgImage: json['bg_image'] as String?,
  bgColor: json['bg_color'] as String?,
  audioWord: json['audio_word'] as String,
  audioBg: json['audio_bg'] as String?,
  image: json['image'] as String?,
  charImage: json['char_image'] as String?,
  isImageSvg: json['is_image_svg'] as bool? ?? false,
);

Map<String, dynamic> _$ListenAndRepeatLessonContentToJson(
  ListenAndRepeatLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'type': instance.type,
  'name_en': instance.nameEn,
  'name_np': instance.nameNp,
  'bg_image': instance.bgImage,
  'bg_color': instance.bgColor,
  'audio_word': instance.audioWord,
  'audio_bg': instance.audioBg,
  'image': instance.image,
  'char_image': instance.charImage,
  'is_image_svg': instance.isImageSvg,
};

CharTracingLessonContent _$CharTracingLessonContentFromJson(
  Map<String, dynamic> json,
) => CharTracingLessonContent(
  nameEn: json['name_en'] as String? ?? "",
  nameNp: json['name_np'] as String? ?? "",
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  bgImage: json['bg_image'] as String?,
  bgColor: json['bg_color'] as String?,
  audioBg: json['audio_bg'] as String?,
  audioItem: json['audio_item'] as String?,
  type: json['type'] as String? ?? 'char_tracing',
);

Map<String, dynamic> _$CharTracingLessonContentToJson(
  CharTracingLessonContent instance,
) => <String, dynamic>{
  'name_en': instance.nameEn,
  'name_np': instance.nameNp,
  'id': instance.id,
  'index': instance.index,
  'bg_image': instance.bgImage,
  'bg_color': instance.bgColor,
  'audio_bg': instance.audioBg,
  'audio_item': instance.audioItem,
  'type': instance.type,
};

TeaMakingLessonContent _$TeaMakingLessonContentFromJson(
  Map<String, dynamic> json,
) => TeaMakingLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  type: json['type'] as String? ?? 'tea_making',
  audioInstruction: json['audio_instruction'] as String,
  teapotVapour: json['teapot_vapour'] as String,
  stoveImage: json['stove_image'] as String,
  abaPaniUmalaSound: json['aba_pani_umala_sound'] as String,
  teaReadySound: json['tea_ready_sound'] as String,
  bearTakingTea: json['bear_taking_tea'] as String,
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TeaMakingLessonContentToJson(
  TeaMakingLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'type': instance.type,
  'audio_instruction': instance.audioInstruction,
  'teapot_vapour': instance.teapotVapour,
  'stove_image': instance.stoveImage,
  'aba_pani_umala_sound': instance.abaPaniUmalaSound,
  'tea_ready_sound': instance.teaReadySound,
  'bear_taking_tea': instance.bearTakingTea,
  'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
};

BallSlideLessonContent _$BallSlideLessonContentFromJson(
  Map<String, dynamic> json,
) => BallSlideLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  type: json['type'] as String? ?? 'ball_slide',
  bgImageMobile: json['bg_image_mobile'] as String?,
  bgImageTablet: json['bg_image_tablet'] as String?,
  player1: json['player1'] as String?,
  player2: json['player2'] as String?,
  ballImage: json['ball_image'] as String?,
  sliderColor: json['slider_color'] as String?,
  rotateBall: json['rotate_ball'] as bool? ?? true,
  ballImageEnd: json['ball_image_end'] as String?,
  direction: json['direction'] as String? ?? 'ltr',
  conversation:
      (json['conversation'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  angle: json['angle'] as num? ?? 0,
  sliderLengthMb: json['slider_length_mb'] as num? ?? 1,
  sliderLengthTb: json['slider_length_tb'] as num? ?? 1,
  pDyMb: (json['p_dy_mb'] as num?)?.toInt() ?? 0,
  pDyTb: (json['p_dy_tb'] as num?)?.toInt() ?? 0,
  goalLeftImageMb: json['goal_left_image_mb'] as String?,
  goalLeftImageTb: json['goal_left_image_tb'] as String?,
  goalRightImageMb: json['goal_right_image_mb'] as String?,
  goalRightImageTb: json['goal_right_image_tb'] as String?,
);

Map<String, dynamic> _$BallSlideLessonContentToJson(
  BallSlideLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'type': instance.type,
  'bg_image_mobile': instance.bgImageMobile,
  'bg_image_tablet': instance.bgImageTablet,
  'player1': instance.player1,
  'player2': instance.player2,
  'ball_image': instance.ballImage,
  'slider_color': instance.sliderColor,
  'rotate_ball': instance.rotateBall,
  'ball_image_end': instance.ballImageEnd,
  'direction': instance.direction,
  'conversation': instance.conversation,
  'angle': instance.angle,
  'slider_length_mb': instance.sliderLengthMb,
  'slider_length_tb': instance.sliderLengthTb,
  'p_dy_mb': instance.pDyMb,
  'p_dy_tb': instance.pDyTb,
  'goal_left_image_mb': instance.goalLeftImageMb,
  'goal_left_image_tb': instance.goalLeftImageTb,
  'goal_right_image_mb': instance.goalRightImageMb,
  'goal_right_image_tb': instance.goalRightImageTb,
};

SlideUpToMatchLessonContent _$SlideUpToMatchLessonContentFromJson(
  Map<String, dynamic> json,
) => SlideUpToMatchLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  type: json['type'] as String? ?? 'slide_up_to_match',
  bgImage: json['bg_image'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SlideUpToMatchLessonContentToJson(
  SlideUpToMatchLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'type': instance.type,
  'bg_image': instance.bgImage,
  'items': instance.items,
};

FlipCardLessonContent _$FlipCardLessonContentFromJson(
  Map<String, dynamic> json,
) => FlipCardLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  type: json['type'] as String? ?? 'flip_card',
  bgImage: json['bg_image'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$FlipCardLessonContentToJson(
  FlipCardLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'type': instance.type,
  'bg_image': instance.bgImage,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

BalloonFillLessonContent _$BalloonFillLessonContentFromJson(
  Map<String, dynamic> json,
) => BalloonFillLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  audio: json['audio'] as String?,
  type: json['type'] as String? ?? 'balloon_fill',
  bgImage: json['bg_image'] as String?,
  bgImageTb: json['bg_image_tb'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$BalloonFillLessonContentToJson(
  BalloonFillLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'audio': instance.audio,
  'type': instance.type,
  'bg_image': instance.bgImage,
  'bg_image_tb': instance.bgImageTb,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

GunFillLessonContent _$GunFillLessonContentFromJson(
  Map<String, dynamic> json,
) => GunFillLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  audio: json['audio'] as String?,
  type: json['type'] as String? ?? 'gun_fill',
  bgImage: json['bg_image'] as String?,
  bgImageTb: json['bg_image_tb'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$GunFillLessonContentToJson(
  GunFillLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'audio': instance.audio,
  'type': instance.type,
  'bg_image': instance.bgImage,
  'bg_image_tb': instance.bgImageTb,
  'items': instance.items.map((e) => e.toJson()).toList(),
};

HoliAnimateLessonContent _$HoliAnimateLessonContentFromJson(
  Map<String, dynamic> json,
) => HoliAnimateLessonContent(
  id: json['id'] as String,
  index: (json['index'] as num).toInt(),
  audio: json['audio'] as String?,
  type: json['type'] as String? ?? 'holi_animate',
  bgImage: json['bg_image'] as String?,
  bgImageTb: json['bg_image_tb'] as String?,
  image: json['image'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$HoliAnimateLessonContentToJson(
  HoliAnimateLessonContent instance,
) => <String, dynamic>{
  'id': instance.id,
  'index': instance.index,
  'audio': instance.audio,
  'type': instance.type,
  'bg_image': instance.bgImage,
  'bg_image_tb': instance.bgImageTb,
  'image': instance.image,
  'items': instance.items.map((e) => e.toJson()).toList(),
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
  order: (json['order'] as num?)?.toInt(),
  nameEn: json['name_en'] as String,
  nameNp: json['name_np'] as String,
  image: json['image'] as String,
  isImageSvg: json['is_image_svg'] as bool? ?? false,
  bgColor: json['bg_color'] as String?,
  imageOutline: json['image_outline'] as String?,
  isImageOutlineSvg: json['is_image_outline_svg'] as bool? ?? false,
  outlineBgColor: json['outline_bg_color'] as String?,
  question: json['question'] as String?,
  audioItem: json['audio_item'] as String?,
  audioBg: json['audio_bg'] as String?,
  dxRatio: json['dx_ratio'] as num?,
  dyRatio: json['dy_ratio'] as num?,
  dxRatioMobile: json['dx_ratio_mobile'] as num?,
  dyRatioMobile: json['dy_ratio_mobile'] as num?,
  isCorrect: json['is_correct'] as bool? ?? false,
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'order': instance.order,
  'name_en': instance.nameEn,
  'name_np': instance.nameNp,
  'image': instance.image,
  'is_image_svg': instance.isImageSvg,
  'bg_color': instance.bgColor,
  'image_outline': instance.imageOutline,
  'is_image_outline_svg': instance.isImageOutlineSvg,
  'outline_bg_color': instance.outlineBgColor,
  'question': instance.question,
  'audio_item': instance.audioItem,
  'audio_bg': instance.audioBg,
  'dx_ratio': instance.dxRatio,
  'dy_ratio': instance.dyRatio,
  'dx_ratio_mobile': instance.dxRatioMobile,
  'dy_ratio_mobile': instance.dyRatioMobile,
  'is_correct': instance.isCorrect,
};
