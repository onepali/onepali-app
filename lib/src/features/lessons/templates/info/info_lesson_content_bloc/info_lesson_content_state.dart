part of 'info_lesson_content_bloc.dart';

@freezed
class InfoLessonContentState with _$InfoLessonContentState {
  const factory InfoLessonContentState({
    String? errorMsg,
    InfoLessonContent? lessonContent,
    @Default(false) bool isVideoCompleted,
    @Default(false) bool isAudioPlaying,
  }) = _InfoLessonContentState;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
