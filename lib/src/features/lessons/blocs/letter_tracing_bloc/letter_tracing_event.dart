part of 'letter_tracing_bloc.dart';

@freezed
abstract class LetterTracingEvent with _$LetterTracingEvent {
  const factory LetterTracingEvent.started(
    CharTracingLessonContent content,
    bool isMobile,
  ) = _Started;
  const factory LetterTracingEvent.onPanStart(Offset position) = _OnPanStart;
  const factory LetterTracingEvent.onPanUpdate(Offset position) = _OnPanUpdate;
  const factory LetterTracingEvent.onPanEnd(Offset position) = _OnPanEnd;
  const factory LetterTracingEvent.reset() = _Reset;
}
