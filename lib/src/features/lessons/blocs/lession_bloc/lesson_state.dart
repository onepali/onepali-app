part of 'lesson_bloc.dart';

@freezed
abstract class LessonState with _$LessonState {
  const factory LessonState({
    String? lessonId,
    LessonDetail? lessonDetails,
    @Default(0) int currentIndex,
    LessonContent? currentContent,
  }) = _LessonState;
}
 