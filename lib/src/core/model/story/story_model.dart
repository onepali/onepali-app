// ignore_for_file: invalid_annotation_target

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

List<StoryModel> storyModelFromJson(String str) => List<StoryModel>.from(
  (json.decode(str) as List<dynamic>).map(
    (x) => StoryModel.fromJson(x as Map<String, dynamic>),
  ),
);

String storyModelToJson(List<StoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<String> _stringListFromJson(Object? value) => value == null
    ? const <String>[]
    : List<String>.from((value as Iterable<dynamic>).map((x) => x.toString()));

@freezed
abstract class StoryModel with _$StoryModel {
  @JsonSerializable(explicitToJson: true)
  const factory StoryModel({
    @JsonKey(name: 'level_id') @Default('') String levelId,
    @Default('') String nameEn,
    @Default('') String nameNp,
    @Default('') String thumbnail,
    @Default('') String lottie,
    @JsonKey(fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> audio,
    @Default('') String tooltip,
    @Default('') String description,
    @Default(<Content>[]) List<Content> content,
    @JsonKey(name: 'bg_color') String? bgColor,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}

@freezed
abstract class Content with _$Content {
  @JsonSerializable(explicitToJson: true)
  const factory Content({
    @Default('') String image,
    @JsonKey(name: 'image_tb') String? imageTb, // for tablet
    @JsonKey(name: 'image_success') String? imageSuccess,
    @JsonKey(name: 'image_success_tb') String? imageSuccessTb,
    @JsonKey(fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> audio,
    @Default('') String lottie,
    @Default('') String type,
    @Default(<Conversation>[]) List<Conversation> conversation,
    @JsonKey(name: 'character', fromJson: _stringListFromJson)
    @Default(<String>[])
    List<String> characters,
    @Default('') String confetti,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

String _idFromJson(Object? value) => value?.toString() ?? '';

@freezed
abstract class Conversation with _$Conversation {
  @JsonSerializable(explicitToJson: true)
  const factory Conversation({
    @JsonKey(fromJson: _idFromJson) @Default('') String id,
    @Default('') String messageEn,
    @Default('') String messageNp,
    @Default('') String icon,
    @Default(false) bool correct,
    String? question, // Audio question
    String? audioItem,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
