part of 'info_lesson_content_bloc.dart';

@freezed
class InfoLessonContentEvent with _$InfoLessonContentEvent {
  const factory InfoLessonContentEvent.started(
    InfoLessonContent lessonInformation,
  ) = _Started;
  const factory InfoLessonContentEvent.videoCompleted() = _VideoCompleted;
  const factory InfoLessonContentEvent.audioStarted() = _AudioStarted;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
