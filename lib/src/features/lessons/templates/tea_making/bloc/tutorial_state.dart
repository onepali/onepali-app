part of 'tutorial_bloc.dart';

enum TutorialStatus {
  initial,
  instructionPlaying,
  instructionCompleted,
  hunchaPressed,
  hunchaAudioPlaying,
  hunchaAudioCompleted,
  // Item repeat
  guidePlaying,
  guideCompleted,
  itemDropped,
  itemAudioPlaying,
  itemAudioCompleted,
  ideal, // where the item is dropped in the ideal position
  completed,
}

@freezed
abstract class TutorialState with _$TutorialState {
  const TutorialState._();
  const factory TutorialState({
    @Default(TutorialStatus.initial) TutorialStatus status,
    TeaMakingLessonContent? content,
    Item? lastDroppedItem,
    Item? currentItem,
    @Default(0) int currentIndex,
    @Default(<int>{}) Set<int> completedIngredientIndices,
    @Default(false) bool showHunchButton,
  }) = _TutorialState;
}
