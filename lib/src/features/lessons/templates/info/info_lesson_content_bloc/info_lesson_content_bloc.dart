import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'info_lesson_content_event.dart';
part 'info_lesson_content_state.dart';
part 'info_lesson_content_bloc.freezed.dart';

class InfoLessonContentBloc
    extends Bloc<InfoLessonContentEvent, InfoLessonContentState> {
  InfoLessonContentBloc() : super(_InfoLessonContentState()) {
    on<_Started>((event, emit) {
      emit(
        state.copyWith(
          lessonContent: null,
          isAudioPlaying: false,
          isVideoCompleted: false,
        ),
      );
      final content = event.lessonInformation;
      emit(
        state.copyWith(
          lessonContent: content,
          isVideoCompleted: content.video?.isNotEmpty != true,
        ),
      );
    });

    on<_VideoCompleted>((event, emit) {
      emit(state.copyWith(isVideoCompleted: true));
    });

    on<_AudioStarted>((event, emit) {
      emit(state.copyWith(isAudioPlaying: true));
    });
  }
}
