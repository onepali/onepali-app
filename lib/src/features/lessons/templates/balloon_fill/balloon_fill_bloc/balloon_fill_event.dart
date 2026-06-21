part of 'balloon_fill_bloc.dart';

@freezed
class BalloonFillEvent with _$BalloonFillEvent {
  const factory BalloonFillEvent.started(BalloonFillLessonContent content) =
      _Started;
  const factory BalloonFillEvent.audioCompleted() = _AudioCompleted;
  const factory BalloonFillEvent.balloonTapped(int index) = _BalloonTapped;
  const factory BalloonFillEvent.fillAnimationCompleted() =
      _FillAnimationCompleted; // called by UI after 800ms
  const factory BalloonFillEvent.labelHidden() =
      _LabelHidden; // called by UI or timer
  const factory BalloonFillEvent.filledBalloonTapped(int index) =
      _FilledBalloonTapped;
  const factory BalloonFillEvent.reset() = _Reset;
}
