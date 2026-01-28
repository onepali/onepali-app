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

  @FreezedUnionValue("tap_to_reveal")
  const factory LessonContent.tapToReveal({
    required String id,
    required int index,
    @Default('tap_to_reveal') String type,
    @Default([]) List<Item> items,
  }) = TapToRevealLessonContent;

  @FreezedUnionValue("drag_to_match")
  const factory LessonContent.dragToMatch({
    required String id,
    required int index,
    @Default('drag_to_match') String type,
  }) = DragToMatchLessonContent;

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
    required String nameEn,
    required String nameNp,
    required String image,
    required String question,
    required String audioItem,
    num? dxRatio,
    num? dyRatio,
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
