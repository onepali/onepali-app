import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/repository/lesson_repository.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';
part 'lesson_bloc.freezed.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  LessonBloc() : super(const LessonState()) {
    on<_Started>(_onStarted);
    on<_NextContent>(_onNextContent);
    on<_PreviousContent>(_onPreviousContent);
  }

  Future<void> _onStarted(_Started event, Emitter<LessonState> emit) async {
    emit(state.copyWith(lessonId: event.lessonId));

    await emit.forEach(
      LessonRepository().watchLessonWithContents(event.lessonId),
      onData: (lessonDetail) {
        lessonDetail.contents.sort((a, b) => a.index.compareTo(b.index));
        return state.copyWith(
          lessonDetails: lessonDetail,
          errorMessage: null,
          currentIndex: 0,
          currentContent: lessonDetail.contents.isNotEmpty
              ? lessonDetail.contents.first
              : null,
        );
      },
      onError: (error, _) {
        log(error.toString());
        return state.copyWith(errorMessage: error.toString());
      },
    );
  }

  void _onNextContent(_NextContent event, Emitter<LessonState> emit) {
    final lessonDetails = state.lessonDetails;
    if (lessonDetails == null) return;

    final nextIndex = state.currentIndex + 1;
    if (nextIndex < lessonDetails.contents.length) {
      emit(
        state.copyWith(
          currentIndex: nextIndex,
          currentContent: lessonDetails.contents[nextIndex],
        ),
      );
    }
  }

  void _onPreviousContent(_PreviousContent event, Emitter<LessonState> emit) {
    final lessonDetails = state.lessonDetails;
    if (lessonDetails == null) return;

    final previousIndex = state.currentIndex - 1;
    if (previousIndex >= 0) {
      emit(
        state.copyWith(
          currentIndex: previousIndex,
          currentContent: lessonDetails.contents[previousIndex],
        ),
      );
    }
  }
}
