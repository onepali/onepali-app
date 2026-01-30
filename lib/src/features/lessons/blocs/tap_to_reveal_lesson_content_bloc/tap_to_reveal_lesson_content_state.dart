part of 'tap_to_reveal_lesson_content_bloc.dart';

@freezed
class TapToRevealLessonContentState with _$TapToRevealLessonContentState {
  const factory TapToRevealLessonContentState({
    TapToRevealLessonContent? content,
    @Default([]) List<Item> selectedItems,
    @Default(0) int currentQuestionIndex,
    Item? currentQuestion,
    @Default(false) bool isQuestionAudioPlaying,
    @Default(false) bool isQuestionAudioCompleted,
    Item? tappedItem,
    @Default(false) bool isCorrect,
    @Default(false) bool isAnswered,
    @Default(false) bool isCorrectAudioPlaying,
    @Default(false) bool allQuestionsCompleted,
    @Default(false) bool showCorrectName,
    String? errorMessage,
  }) = _TapToRevealLessonContentState;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
