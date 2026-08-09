part of 'ball_heading_bloc.dart';

@freezed
abstract class BallHeadingState with _$BallHeadingState {
  const factory BallHeadingState({
    BallSlideLessonContent? content,
    @Default(false) bool isAllAudioCompleted,
    @Default(false) bool isComplete,
  }) = _BallHeadingState;
}
