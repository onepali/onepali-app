part of 'choose_correct_lesson_content_bloc.dart';

enum ChooseCorrectLessonContentStatus {
  initial,
  questionAudioPlaying,
  questionAudioCompleted,
  ideal,
  itemAudioPlaying,
  itemAudioCompleted,
  completed,
}

@freezed
class ChooseCorrectLessonContentState with _$ChooseCorrectLessonContentState {
  const factory ChooseCorrectLessonContentState({
    ChooseCorrectLessonContent? lessonContent,
    @Default(ChooseCorrectLessonContentStatus.initial)
    ChooseCorrectLessonContentStatus status,
    Item? currentQuestion,
    Item? selectedItem,
    @Default(false) bool isCorrect,
    @Default(false) bool isAnswered,
    String? errorMessage,
  }) = _ChooseCorrectLessonContentState;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
