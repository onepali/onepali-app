part of 'tap_to_fill_bloc.dart';

enum TapToFillStatus { initial, audioPlaying, ideal, completed }

@freezed
abstract class TapToFillState with _$TapToFillState {
  const factory TapToFillState({
    @Default(TapToFillStatus.initial) TapToFillStatus status,
    TapToFillLessonContent? content,
  }) = _TapToFillState;
}
