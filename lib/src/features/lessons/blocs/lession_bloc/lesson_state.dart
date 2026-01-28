part of 'lesson_bloc.dart';

@freezed
class LessonState with _$LessonState {
  const factory LessonState({
    String? lessonId,
    LessonDetail? lessonDetails,
    @Default(0) int currentIndex,
    LessonContent? currentContent,
    // Choose correct related content state
    Item? itemQuestioned,
    Item? userSelectedItem,
    bool? isAnswerCorrect,
    // Tap to reveal related content state
    List<Item>? tapToRevealItems,
    Item? selectedTapToRevealItem,
    @Default([]) List<Item> completedTapToRevealItems,
    @Default(false)bool? isTapToRevealCompleted,

  }) = _LessonState;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
