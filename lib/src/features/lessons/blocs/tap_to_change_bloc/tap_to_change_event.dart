part of 'tap_to_change_bloc.dart';

@freezed
abstract class TapToChangeEvent with _$TapToChangeEvent {
  const factory TapToChangeEvent.started(TapToChangeLessonContent content) =
      _Started;
  const factory TapToChangeEvent.audioCompleted() = _AudioCompleted;

  const factory TapToChangeEvent.tapped(Offset point) = _Tapped;
}
