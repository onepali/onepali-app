import 'package:freezed_annotation/freezed_annotation.dart';
part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String name,
    required String image,
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
    String? image,
    String? audio,
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
    String? bgColor,
    @Default('tap_to_pop') String type,
    @Default([]) List<Item> items,
  }) = TapToPopLessonContent;

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
    required String audioItem, // Cat pronunciation
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
