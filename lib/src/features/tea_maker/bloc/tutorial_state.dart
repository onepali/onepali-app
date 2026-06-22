part of 'tutorial_bloc.dart';

@freezed
abstract class TutorialState with _$TutorialState {
  const factory TutorialState({
    @Default(false) bool showLoading,
    @Default(-1) int index,
    @Default(0) int draggedIndex,
    @Default([]) List<String> ingredients,
    @Default(false) bool showBearWithTea,
    @Default(false) bool showHunchButton,
    @Default(false) bool showDragIndicator,
    String? draggedItemPath,
    String? droppedItem,
    String? stoveImage,
    String? bearTakingTeaTb,
    String? bearTakingTeaMb,
    @Default(false) bool teaReady,
  }) = _TutorialState;
}
