part of 'tutorial_bloc.dart';

@freezed
class TutorialEvent with _$TutorialEvent {
  const factory TutorialEvent.started(TeaMakingLessonContent content) =
      _Started;
  const factory TutorialEvent.instructionAudioCompleted() =
      _InstructionAudioCompleted;
  const factory TutorialEvent.hunchaButtonPressed() = _HunchaButtonPressed;
  const factory TutorialEvent.hunchaAudioCompleted() = _HunchaAudioCompleted;
  const factory TutorialEvent.guideAudioCompleted() = _GuideAudioCompleted;
  const factory TutorialEvent.itemDropped(Item item) = _ItemDropped;
  const factory TutorialEvent.itemAudioCompleted() = _ItemAudioCompleted;
  const factory TutorialEvent.processInstructionOnlyStep() =
      _ProcessInstructionOnlyStep;
  const factory TutorialEvent.ideal(Item item) = _Ideal;
  const factory TutorialEvent.completed() = _Completed;
}
