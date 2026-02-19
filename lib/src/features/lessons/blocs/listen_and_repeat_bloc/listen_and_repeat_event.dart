part of 'listen_and_repeat_bloc.dart';

@freezed
class ListenAndRepeatEvent with _$ListenAndRepeatEvent {
  const factory ListenAndRepeatEvent.started(
    ListenAndRepeatLessonContent content,
  ) = _Started;
  const factory ListenAndRepeatEvent.audioFinished() = _AudioFinished;
  const factory ListenAndRepeatEvent.recordingTimerTick(int elapsed) =
      _RecordingTimerTick;
  const factory ListenAndRepeatEvent.recordingCompleted(String audioPath) =
      _RecordingCompleted;
  const factory ListenAndRepeatEvent.recordingFailed(String error) =
      _RecordingFailed;
  const factory ListenAndRepeatEvent.retryRequested() = _RetryRequested;
}
