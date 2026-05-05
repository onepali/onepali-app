part of 'option_slection_bloc.dart';

@freezed
class OptionSlectionEvent with _$OptionSlectionEvent {
  const factory OptionSlectionEvent.started(OptionSelectionLessonContent content) = _Started;
  const factory OptionSlectionEvent.audioCompleted() = _AudioCompleted;
  const factory OptionSlectionEvent.optionTapped(Option option) = _OptionTapped;
}