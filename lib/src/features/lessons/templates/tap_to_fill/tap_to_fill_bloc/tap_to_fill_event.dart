part of 'tap_to_fill_bloc.dart';

@freezed
class TapToFillEvent with _$TapToFillEvent {
  const factory TapToFillEvent.started(TapToFillLessonContent content) =
      _Started;

  const factory TapToFillEvent.audioBeforeOptionsCompleted() =
      _AudioBeforeOptionsCompleted;

  const factory TapToFillEvent.audioCompleted() = _AudioCompleted;
  const factory TapToFillEvent.optionTapped(Option option) = _OptionTapped;
}
