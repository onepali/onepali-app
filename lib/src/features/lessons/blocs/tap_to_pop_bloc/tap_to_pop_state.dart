part of 'tap_to_pop_bloc.dart';

@freezed
abstract class TapToPopState with _$TapToPopState {
  const factory TapToPopState({
    TapToPopLessonContent? content,
    List<Item>? correctItems,
    List<Item>? selectedItems,
    @Default(false) bool completed,
  }) = _Initial;
}
