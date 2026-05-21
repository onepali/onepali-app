part of 'lesson_bloc.dart';

@freezed
abstract class LessonState with _$LessonState {
  const factory LessonState({
    @Default(LessonStatus.initial) LessonStatus status,
    String? lessonId,
    LessonDetail? lessonDetails,
    @Default(0) int currentIndex,
    LessonContent? currentContent,
    @Default(false) bool hasCompletedLesson,
  }) = _LessonState;
}

enum LessonStatus { initial, loading, success, failure }
