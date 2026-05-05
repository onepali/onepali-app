part of 'choose_correct_lesson_content_bloc.dart';

@freezed
class ChooseCorrectLessonContentState with _$ChooseCorrectLessonContentState {
  const factory ChooseCorrectLessonContentState({
    ChooseCorrectLessonContent? lessonContent,
    Item? currentQuestion,
    @Default(false) bool isQuestionAudioPlaying,
    @Default(false) bool isQuestionAudioCompleted,
    Item? selectedItem,
    @Default(false) bool isCorrect,
    @Default(false) bool isAnswered,
    @Default(false) bool isAudioPlaying,
  }) = _ChooseCorrectLessonContentState;
  

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}