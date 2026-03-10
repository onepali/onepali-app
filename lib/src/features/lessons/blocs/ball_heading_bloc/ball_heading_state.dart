part of 'ball_heading_bloc.dart';

@freezed
abstract class BallHeadingState with _$BallHeadingState {
  const factory BallHeadingState({
    BallSlideLessonContent? content,
  }) = _BallHeadingState;
}
