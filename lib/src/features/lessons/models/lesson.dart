import 'package:freezed_annotation/freezed_annotation.dart';
part 'lesson.freezed.dart';
part 'lesson.g.dart';

Object? _readBearTakingTeaTb(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['bear_taking_tea'];

Object? _readBearTakingTeaMb(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['bear_taking_tea'];

@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String name,
    String? image,
    @JsonKey(name: 'bg_image') String? bgImage,
    @Default(false) bool active,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}

abstract class LessonContentBase {
  String get id;
  int get index;
  String get type;
}

@Freezed(unionKey: "type", fallbackUnion: "unknown")
abstract class LessonContent with _$LessonContent implements LessonContentBase {
  @FreezedUnionValue('intro')
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LessonContent.intro({
    required String id,
    required int index,
    @Default('intro') String type,
    String? bgColor,
    String? image, // svg
    String? audio,
    String? bgImageMobile,
    String? bgImageTablet,
    String? message,
    String? messageSound,
  }) = IntroLessonContent;

  @FreezedUnionValue('info')
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LessonContent.info({
    required String id,
    required int index,
    @Default('info') String type,

    required String nameEn,
    required String nameNp,
    required String audioWord,
    String? audioBg,
    required String image,
    @Default(false) bool isImageSvg,
    String? video,
    String? bgImageColor,
  }) = InfoLessonContent;

  @FreezedUnionValue('choose_correct')
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.chooseCorrect({
    required String id,
    required int index,
    @Default('choose_correct') String type,

    @Default([]) List<Item> items,
  }) = ChooseCorrectLessonContent;

  @FreezedUnionValue('tap_to_reveal')
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.tapToReveal({
    required String id,
    required int index,
    String? bgImage, // Svg Image
    String? bgImageTb, // Svg Image
    @Default('tap_to_reveal') String type,
    @Default([]) List<Item> items,
  }) = TapToRevealLessonContent;

  @FreezedUnionValue('drag_to_match')
  const factory LessonContent.dragToMatch({
    required String id,
    required int index,
    @Default('drag_to_match') String type,
    @Default([]) List<Item> items,
  }) = DragToMatchLessonContent;

  @FreezedUnionValue('tap_to_pop')
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.tapToPop({
    required String id,
    required int index,
    String? bgImage,
    String? successImage,
    String? bgColor,
    String? audioWord,
    String? instructionAudio,
    @Default('tap_to_pop') String type,
    @Default([]) List<Item> items,
  }) = TapToPopLessonContent;

  @FreezedUnionValue('listen_and_repeat')
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.listenAndRepeat({
    required String id,
    required int index,
    @Default('listen_and_repeat') String type,
    required String nameEn,
    required String nameNp,
    String? bgImage,
    String? bgColor,
    required String audioWord,
    String? audioBg,
    String? image, // This is image of the word, eg a man doing namaste
    String? charImage, // This is the character image, eg 'न'
    @Default(false) bool isImageSvg,
  }) = ListenAndRepeatLessonContent;

  @FreezedUnionValue('char_tracing')
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.charTracing({
    @Default('') String nameEn,
    @Default('') String nameNp,
    required String id,
    required int index,
    String? bgImage,
    String? bgColor,
    String? audioBg,
    String? audioItem,
    @Default('char_tracing') String type,
  }) = CharTracingLessonContent;

  @FreezedUnionValue('tea_making')
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.teaMaking({
    required String id,
    required int index,
    @Default('tea_making') String type,
    required String audioInstruction,
    required String teapotVapour,
    required String stoveImage,
    required String abaPaniUmalaSound,
    required String teaReadySound,
    @JsonKey(readValue: _readBearTakingTeaTb) required String bearTakingTeaTb,
    @JsonKey(readValue: _readBearTakingTeaMb) required String bearTakingTeaMb,
    @Default([])
    List<Item>
    ingredients, // In this case, imageOutline is the placed image on top of stove
  }) = TeaMakingLessonContent;

  //--------------------Football lesson contents----------------
  @FreezedUnionValue('ball_slide') // football_slide_forward
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LessonContent.ballSlide({
    required String id,
    required int index,
    @Default('ball_slide') String type,
    String? bgImageMobile, // png
    String? bgImageTablet, // png
    String? player1, //png
    String? player2, //png
    String? ballImage, //png
    String? sliderColor, // Hex color
    @Default(true) bool rotateBall,

    /// This message is for display when the action is done.
    String? message,

    /// This message sound is for display when the action is done.
    String? messageSound,

    /// This image[PNG] replaces the ball image when the ball reaches the end
    String? ballImageEnd,
    @Default('ltr')
    String
    direction, // ltr, rtl, ltr_heading, rtl_heading, none(only play conversation audios)
    @Default([]) List<String> conversation, // List of audio urls
    @Default(0) num angle,
    @Default(1) num sliderLengthMb,
    @Default(1) num sliderLengthTb,
    @Default(0) int pDyMb,
    @Default(0) int pDyTb,
    String? goalLeftImageMb, //png
    String? goalLeftImageTb, //png
    String? goalRightImageMb, //png
    String? goalRightImageTb, //png
  }) = BallSlideLessonContent;

  @FreezedUnionValue('slide_up_to_match')
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LessonContent.slideUpToMatch({
    required String id,
    required int index,
    @Default('slide_up_to_match') String type,
    String? bgImage,
    @Default([]) List<Item> items,
  }) = SlideUpToMatchLessonContent;

  @FreezedUnionValue("flip_card")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.flipCard({
    required String id,
    required int index,
    @Default('flip_card') String type,
    String? bgImage,
    @Default([]) List<Item> items,
  }) = FlipCardLessonContent;

  //--------------------Holi lesson contents----------------
  @FreezedUnionValue("balloon_fill")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.balloonFill({
    required String id,
    required int index,
    String? audio,
    @Default('balloon_fill') String type,
    String? bgImage,
    String? bgImageTb,
    @Default([]) List<Item> items,
  }) = BalloonFillLessonContent;

  @FreezedUnionValue("gun_fill")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.gunFill({
    required String id,
    required int index,
    String? audio,
    @Default('gun_fill') String type,
    String? bgImage, // Svg Image
    String? bgImageTb, // Svg Image
    @Default([]) List<Item> items,
  }) = GunFillLessonContent;

  @FreezedUnionValue("holi_animate")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.holiAnimate({
    required String id,
    required int index,
    String? audio,
    @Default('holi_animate') String type,
    String? bgImage, // png Image
    String? bgImageTb, // png Image
    required String image, // Image to animate
    @Default([]) List<Item> items,
  }) = HoliAnimateLessonContent;

  @FreezedUnionValue("tap_to_change")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.tapToChange({
    required String id,
    required int index,
    String? audio,
    @Default('tap_to_change') String type,
    required String bgImage, // png Image
    required String afterBgImage,
    required String bgImageTb, // png Image
    required String afterBgImageTb,
    String? tapGesture, // Png image
    String? splashImage,
    @Default([]) List<Item> items,
  }) = TapToChangeLessonContent;

  ///--------------------Daily Conversation Lesson Content----------------
  @FreezedUnionValue("tap_to_fill")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.tapToFill({
    required String id,
    required int index,
    @Default('tap_to_fill') String type,
    String? audioBeforeOptions,
    String? instruction,
    String? preBgImageMb, // png Image
    String? preBgImageTb, // png Image
    String? bgImage, // png Image
    String? bgImageTb, // png Image
    @Default([]) List<Option> options,
  }) = TapToFillLessonContent;

  @FreezedUnionValue("option_selection")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.optionSelection({
    required String id,
    required int index,
    @Default('option_selection') String type,
    required String? image, // png Image
    String? instruction,
    String? bgImage, // png Image
    String? bgImageTb, // png Image
    @Default([]) List<Option> options,
  }) = OptionSelectionLessonContent;

  @FreezedUnionValue("put_in_bag")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.putInBag({
    required String id,
    required int index,
    @Default('put_in_bag') String type,

    /// If true, only one choice is allowed
    @Default(false) bool onlyOneChoice,
    String? instructionAudio,

    /// Bag in the background
    String? bagImage,
    String? bgColor,
    String? bgImage, // png Image
    String? bgImageTb, // png Image
    @Default([]) List<Item> items,
    // 0 to 1. This is used to add gap between top items and the bag. 0 means no gap, 1 means full height of the screen.
    @Default(0.0) num topBagPaddingRatio,
  }) = PutInBagLessonContent;

  @FreezedUnionValue("tap_the_button")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.tapTheButton({
    required String id,
    required int index,
    @Default('tap_the_button') String type,
    String? instruction,
    String? bgImage, // png Image
    String? bgImageTb, // png Image
    String? buttonImage, // png Image
    String? tapAudio, // Played when the button is tapped
  }) = TapTheButtonLessonContent;

  @FreezedUnionValue("lesson_recommendation")
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.lessonRecommendation({
    required String id,
    required int index,
    @Default('lesson_recommendation') String type,
    String? bgColor,
    @Default([])
    List<Map<String, dynamic>> lessons, // id and image of recommended lessons
  }) = LessonRecommendationLessonContent;

  @FreezedUnionValue("unknown")
  const factory LessonContent.unknown({
    @Default('') String id,
    @Default(-1) int index,
    @Default('unknown') String type,
  }) = UnknownLessonContent;

  factory LessonContent.fromJson(Map<String, dynamic> json) =>
      _$LessonContentFromJson(json);
}

@freezed
abstract class Item with _$Item {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Item({
    int? order,
    required String nameEn,
    required String nameNp,
    required String image,
    @Default(false) bool isImageSvg,
    String? bgColor,
    String? imageOutline,
    @Default(false) bool isImageOutlineSvg,
    String? outlineBgColor,
    String? question, // eg where is the cat
    String? audioItem, // Cat pronunciation
    String? audioBg, // eg cat sound meww, dog sound barking
    num? dxRatio,
    num? dyRatio,
    num? dxRatioMobile,
    num? dyRatioMobile,
    @Default(false) bool isCorrect,
    // Size of mb. This is used to scale the image in mb.
    @Default(1.0) num sizeMb,
    // Size of tb. This is used to scale the image in tb.
    @Default(1.0) num sizeTb,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
abstract class Option with _$Option {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Option({
    int? order,
    required String nameEn,
    required String nameNp,
    String? audio,
    @Default(false) bool isCorrect,
  }) = _Option;

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
}

class LessonDetail {
  final Lesson lesson;
  final List<LessonContent> contents;

  LessonDetail({required this.lesson, required this.contents});
}
