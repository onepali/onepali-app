part of 'tap_the_button_bloc.dart';

@freezed
abstract class TapTheButtonEvent with _$TapTheButtonEvent {
  const factory TapTheButtonEvent.started(TapTheButtonLessonContent content) =
      _Started;
  const factory TapTheButtonEvent.audioCompleted(bool isCompleted) =
      _AudioCompleted;
  const factory TapTheButtonEvent.tapped() = _Tapped;
}
