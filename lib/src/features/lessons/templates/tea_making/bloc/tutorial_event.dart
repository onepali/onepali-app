part of 'tutorial_bloc.dart';

@freezed
class TutorialEvent with _$TutorialEvent {
  const factory TutorialEvent.started(TeaMakingLessonContent content) =
      _Started;
  const factory TutorialEvent.hunchaButtonPressed() = _HunchaButtonPressed;

  const factory TutorialEvent.onDragAccept(int index) = _OnDragAccept;
}
