part of 'letter_tracing_bloc.dart';

@freezed
abstract class LetterTracingState with _$LetterTracingState {
  const factory LetterTracingState({
    NepaliLetter? letter,
    @Default(Size(300, 300)) Size letterSize,
    @Default(20.0) double strokeWidth,
    @Default(0) int numberOfStrokes,
    @Default([]) List<Path> letterPaths,
    Path? outlinePath,
    @Default([]) List<List<Offset>> pathsPoints,
    @Default([]) List<Offset> userStrokes,
    @Default([]) List<Path> completedPaths,
    @Default(0) int currentStrokeIndex,
    @Default([]) List<Rect> strokeBoundingBoxes,

    // New properties for improved features
    @Default(0.0) double currentStrokeProgress,
    @Default(false) bool isTracingOutsideBounds,
    @Default(false) bool showStartHint,
    @Default(true) bool showPointer,
    Offset? pointerPosition,
    String? feedbackMessage,
    @Default(false) bool isLetterComplete,
    @Default(true) bool showGuideDots,
    @Default(false) bool showStrokeDirection,
  }) = _LetterTracingState;
}
