import 'package:freezed_annotation/freezed_annotation.dart';
part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String name,
    required String image,
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
    String? bgImage,
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
    required String bearTakingTea,
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
