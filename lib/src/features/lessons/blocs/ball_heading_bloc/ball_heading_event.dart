part of 'ball_heading_bloc.dart';

@freezed
abstract class BallHeadingEvent with _$BallHeadingEvent {
  const factory BallHeadingEvent.started(BallSlideLessonContent content) =
      _Started;
}
