part of 'tap_the_button_bloc.dart';

enum TapTheButtonStatus { initial, audioPlaying, idle, tapped, completed }

@freezed
abstract class TapTheButtonState with _$TapTheButtonState {
  const factory TapTheButtonState({
    TapTheButtonLessonContent? content,
    @Default(TapTheButtonStatus.initial) TapTheButtonStatus status,
  }) = _TapTheButtonState;
  const TapTheButtonState._();
  bool get isAudioPlaying => status == TapTheButtonStatus.audioPlaying;
  bool get isIdle => status == TapTheButtonStatus.idle;
  bool get isTapped => status == TapTheButtonStatus.tapped;
  bool get isCompleted => status == TapTheButtonStatus.completed;
}
