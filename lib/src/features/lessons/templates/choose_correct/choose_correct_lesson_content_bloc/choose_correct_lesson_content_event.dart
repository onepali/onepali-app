part of 'choose_correct_lesson_content_bloc.dart';

@freezed
class ChooseCorrectLessonContentEvent with _$ChooseCorrectLessonContentEvent {
  const factory ChooseCorrectLessonContentEvent.started(
    ChooseCorrectLessonContent lessonContent,
  ) = _Started;
  
  const factory ChooseCorrectLessonContentEvent.questionAudioCompleted() = _QuestionAudioCompleted;
  
  const factory ChooseCorrectLessonContentEvent.itemTapped(Item tappedItem) = _ItemTapped;
  
  const factory ChooseCorrectLessonContentEvent.correctAudioCompleted() = _CorrectAudioCompleted;
  
}