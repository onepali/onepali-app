part of 'tap_to_pop_bloc.dart';

@freezed
abstract class TapToPopState with _$TapToPopState {
  const factory TapToPopState({
    TapToPopLessonContent? content,
    @Default(0) int correctItemsCount,
    List<Item>? selectedItems,
    @Default(false) bool completed,
    @Default(false) bool instructionAudioPlayed,
  }) = _Initial;
}
