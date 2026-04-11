import 'package:freezed_annotation/freezed_annotation.dart';
part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String name,
    String? image,
    String? bgImage,
    @Default(false) bool active,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

abstract class LessonContentBase {
  String get id;
  int get index;
  String get type;
}

@Freezed(unionKey: "type")
class LessonContent with _$LessonContent implements LessonContentBase {
  @FreezedUnionValue('intro')
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
  }) = IntroLessonContent;

  @FreezedUnionValue('info')
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
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.chooseCorrect({
    required String id,
    required int index,
    @Default('choose_correct') String type,

    @Default([]) List<Item> items,
  }) = ChooseCorrectLessonContent;

  @FreezedUnionValue("tap_to_reveal")
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.tapToReveal({
    required String id,
    required int index,
    String? bgImage,
    @Default('tap_to_reveal') String type,
    @Default([]) List<Item> items,
  }) = TapToRevealLessonContent;

  @FreezedUnionValue("drag_to_match")
  const factory LessonContent.dragToMatch({
    required String id,
    required int index,
    @Default('drag_to_match') String type,
    @Default([]) List<Item> items,
  }) = DragToMatchLessonContent;

  @FreezedUnionValue("tap_to_pop")
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

  @FreezedUnionValue("listen_and_repeat")
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

  @FreezedUnionValue("char_tracing")
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LessonContent.charTracing({
    @Default("") String nameEn,
    @Default("") String nameNp,
    required String id,
    required int index,
    String? bgImage,
    String? bgColor,
    String? audioBg,
    String? audioItem,
    @Default('char_tracing') String type,
  }) = CharTracingLessonContent;

  @FreezedUnionValue("tea_making")
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
    required String bearTakingTea,
    @Default([])
    List<Item>
    ingredients, // In this case, imageOutline is the placed image on top of stove
  }) = TeaMakingLessonContent;

  //--------------------Football lesson contents----------------
  @FreezedUnionValue('ball_slide') // football_slide_forward
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
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LessonContent.slideUpToMatch({
    required String id,
    required int index,
    @Default('slide_up_to_match') String type,
    String? bgImage,
    @Default([]) List<Item> items,
  }) = SlideUpToMatchLessonContent;

  @FreezedUnionValue("flip_card")
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

  const factory LessonContent.unknown({
    @Default('') String id,
    @Default(-1) int index,
    @Default('unknown') String type,
  }) = UnknownLessonContent;

  factory LessonContent.fromJson(Map<String, dynamic> json) =>
      _$LessonContentFromJson(json);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

@freezed
class Item with _$Item {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Item({
    int? order,
    required String nameEn,
    required String nameNp,
    // Image
    required String image,
    @Default(false) bool isImageSvg,
    String? bgColor,
    // Outline
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
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class LessonDetail {
  final Lesson lesson;
  final List<LessonContent> contents;

  LessonDetail({required this.lesson, required this.contents});
}
