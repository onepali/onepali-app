part of 'tap_to_change_bloc.dart';

enum TapToChangeStatus { initial, audioPlaying, idle, tapped }

@freezed
abstract class TapToChangeState with _$TapToChangeState {
  const factory TapToChangeState({
    @Default(TapToChangeStatus.initial) TapToChangeStatus status,
    TapToChangeLessonContent? content,
    Offset? tapPosition,
  }) = _Initial;
}
