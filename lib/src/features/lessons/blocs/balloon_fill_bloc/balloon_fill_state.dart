part of 'balloon_fill_bloc.dart';

enum BalloonFillStatus {
  initial,
  audioPlaying,
  idle,          // audio done, user can tap
  filling,       // balloon animation running (others disabled)
  showingLabel,  // color name visible, still locked
}

@freezed
abstract class BalloonFillState with _$BalloonFillState {
  const factory BalloonFillState({
    BalloonFillLessonContent? content,
    @Default(BalloonFillStatus.initial) BalloonFillStatus status,
    @Default({}) Set<int> filledIndexes,
    int? fillingIndex,        // which balloon is currently animating
    String? colorLabelNp,     // shown during showingLabel status
  }) = _BalloonFillState;

  const BalloonFillState._();

  bool get isLocked =>
      status == BalloonFillStatus.audioPlaying ||
      status == BalloonFillStatus.filling ||
      status == BalloonFillStatus.showingLabel ||
      status == BalloonFillStatus.initial;

  bool isFilled(int index) => filledIndexes.contains(index);
}