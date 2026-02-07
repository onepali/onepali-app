part of 'letter_tracing_bloc.dart';

@freezed
abstract class LetterTracingState with _$LetterTracingState {
  const factory LetterTracingState({
    NepaliLetter? letter,
    @Default(Size.zero) Size letterSize,
    @Default(0) int numberOfStrokes,
    @Default(20) double strokeWidth,
    @Default(0) int currentStrokeIndex,
    @Default([]) List<Path> letterPaths,
    @Default([]) List<Path> completedPaths,
    @Default([]) List<List<Offset>> pathsPoints,
    @Default([]) List<Offset> userStrokes,
  }) = _LetterTracingState;
}
