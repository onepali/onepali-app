part of 'listen_and_repeat_bloc.dart';

enum ListenAndRepeatPhase {
  idle,
  playing,
  readyToRecord,
  recording,
  recorded,
  error,
}

@freezed
abstract class ListenAndRepeatState with _$ListenAndRepeatState {
  const factory ListenAndRepeatState({
    ListenAndRepeatLessonContent? content,
    @Default(ListenAndRepeatPhase.idle) ListenAndRepeatPhase phase,
    @Default(0) int recordingElapsed,
    @Default(3) int recordingDuration, // seconds
    String? recordedAudioPath,
    String? errorMessage,
  }) = _ListenAndRepeatState;

  const ListenAndRepeatState._();

  double get recordingProgress =>
      recordingElapsed / recordingDuration;

  bool get isPlaying => phase == ListenAndRepeatPhase.playing;
  bool get isRecording => phase == ListenAndRepeatPhase.recording;
  bool get isReadyToRecord => phase == ListenAndRepeatPhase.readyToRecord;
  bool get isRecorded => phase == ListenAndRepeatPhase.recorded;
  bool get hasError => phase == ListenAndRepeatPhase.error;
}