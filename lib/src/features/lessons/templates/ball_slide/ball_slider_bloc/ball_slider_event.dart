part of 'ball_slider_bloc.dart';

@freezed
class BallSliderEvent with _$BallSliderEvent {
  const factory BallSliderEvent.started(BallSlideLessonContent content) =
      _Started;
  const factory BallSliderEvent.ballDragged({
    required double delta,
    required double usableWidth,
  }) = _BallDragged;
  const factory BallSliderEvent.ballDragEnded({
    required double velocityPx,
    required double usableWidth,
  }) = _BallDragEnded;
  const factory BallSliderEvent.ballTapped({
    required double tapX,
    required double trackWidth,
  }) = _BallTapped;
  const factory BallSliderEvent.physicsTick() = _PhysicsTick;
  const factory BallSliderEvent.ballReset() = _BallReset;
}
