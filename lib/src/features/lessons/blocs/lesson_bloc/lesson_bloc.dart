import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/repository/lesson_repository.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';
part 'lesson_bloc.freezed.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  StreamSubscription? _subscription;
  LessonBloc() : super(LessonState()) {
    on<_Started>(_onStarted);
    on<_NextContent>(_onNextContent);
    on<_PreviousContent>(_onPreviousContent);
  }

  Future<void> _onStarted(_Started event, Emitter<LessonState> emit) async {
    emit(
      state.copyWith(status: LessonStatus.loading, lessonId: event.lessonId),
    );
    await emit.forEach(
      LessonRepository().watchLessonWithContents(event.lessonId),
      onData: (lessonDetail) {
        lessonDetail.contents.sort((a, b) => a.index.compareTo(b.index));
        return state.copyWith(
          lessonDetails: lessonDetail,
          currentIndex: 0,
          currentContent: lessonDetail.contents.isNotEmpty
              ? lessonDetail.contents[0]
              : null,
          status: LessonStatus.success,
        );
      },
      onError: (error, _) {
        log(error.toString());
        return state.copyWith(status: LessonStatus.failure);
      },
    );
  }

  void _onNextContent(_NextContent event, Emitter<LessonState> emit) {
    final lessonDetails = state.lessonDetails;
    if (lessonDetails == null) return;

    final nextIndex = state.currentIndex + 1;
    if (nextIndex < lessonDetails.contents.length) {
      final nextContent = lessonDetails.contents[nextIndex];
      emit(
        state.copyWith(
          currentIndex: nextIndex,
          currentContent: nextContent,
          status: LessonStatus.success,
        ),
      );
    } else {
      emit(state.copyWith(status: LessonStatus.completed));
    }
  }

  void _onPreviousContent(_PreviousContent event, Emitter<LessonState> emit) {
    final lessonDetails = state.lessonDetails;
    if (lessonDetails == null) return;

    final prevIndex = state.currentIndex - 1;
    if (prevIndex >= 0) {
      final prevContent = lessonDetails.contents[prevIndex];
      emit(
        state.copyWith(
          currentIndex: prevIndex,
          currentContent: prevContent,
          status: LessonStatus.success,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
