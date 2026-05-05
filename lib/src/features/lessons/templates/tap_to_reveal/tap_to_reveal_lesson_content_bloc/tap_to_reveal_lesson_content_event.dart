part of 'tap_to_reveal_lesson_content_bloc.dart';

@freezed
class TapToRevealLessonContentEvent with _$TapToRevealLessonContentEvent {
  const factory TapToRevealLessonContentEvent.started(
    TapToRevealLessonContent content,
  ) = _Started;

  const factory TapToRevealLessonContentEvent.questionAudioCompleted() =
      _QuestionAudioCompleted;

  const factory TapToRevealLessonContentEvent.itemTapped(Item tappedItem) =
      _ItemTapped;

  const factory TapToRevealLessonContentEvent.correctAudioCompleted() =
      _CorrectAudioCompleted;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
