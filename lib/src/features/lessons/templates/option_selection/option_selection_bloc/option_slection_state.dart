part of 'option_slection_bloc.dart';

enum OptionSelectionStatus { initial, audioPlaying, ideal, completed }

@freezed
abstract class OptionSlectionState with _$OptionSlectionState {
  const factory OptionSlectionState({
    OptionSelectionLessonContent? content,
    @Default(OptionSelectionStatus.initial) OptionSelectionStatus status,
  }) = _OptionSlectionState;
}
