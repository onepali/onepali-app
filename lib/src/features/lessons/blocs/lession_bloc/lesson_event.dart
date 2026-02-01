part of 'lesson_bloc.dart';

@freezed
class LessonEvent with _$LessonEvent {
  const factory LessonEvent.started(String lessonId) = _Started;
  const factory LessonEvent.nextContent() = _NextContent;
  const factory LessonEvent.previousContent() = _PreviousContent;
}
