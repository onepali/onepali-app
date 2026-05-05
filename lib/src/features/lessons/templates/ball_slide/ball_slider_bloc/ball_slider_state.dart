part of 'ball_slider_bloc.dart';

@freezed
abstract class BallSliderState with _$BallSliderState {
  const factory BallSliderState({
    BallSlideLessonContent? content,
    @Default(0.0) double value,
    @Default(0.0) double rotationAngle,
    @Default(false) bool isComplete,
    @Default(false) bool isAnimating,
    @Default(false) bool isAllAudioCompleted,
  }) = _BallSliderState;
}
