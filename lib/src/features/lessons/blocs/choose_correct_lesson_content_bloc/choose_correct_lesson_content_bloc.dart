import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'choose_correct_lesson_content_event.dart';
part 'choose_correct_lesson_content_state.dart';
part 'choose_correct_lesson_content_bloc.freezed.dart';

class ChooseCorrectLessonContentBloc
    extends
        Bloc<ChooseCorrectLessonContentEvent, ChooseCorrectLessonContentState> {
  ChooseCorrectLessonContentBloc()
    : super(const ChooseCorrectLessonContentState()) {
    on<_Started>(_onStarted);
    on<_QuestionAudioCompleted>(_onQuestionAudioCompleted);
    on<_ItemTapped>(_onItemTapped);
    on<_CorrectAudioCompleted>(_onCorrectAudioCompleted);
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) async {
    final content = event.lessonContent;

    // Filter items that have question audio
    final itemsWithQuestion = content.items
        .where((item) => item.question != null && item.question!.isNotEmpty)
        .toList();

    if (itemsWithQuestion.isEmpty) {
      emit(
        state.copyWith(
          lessonContent: content,
          errorMessage: 'This lesson does not have a question yet.',
        ),
      );
      return;
    }

    // Select a random item with question
    final random = Random();
    final selectedQuestion =
        itemsWithQuestion[random.nextInt(itemsWithQuestion.length)];

    emit(
      state.copyWith(
        lessonContent: content,
        currentQuestion: selectedQuestion,
        isQuestionAudioPlaying: true,
        errorMessage: null,
      ),
    );
  }

  void _onQuestionAudioCompleted(
    _QuestionAudioCompleted event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) {
    emit(
      state.copyWith(
        isQuestionAudioPlaying: false,
        isQuestionAudioCompleted: true,
      ),
    );
  }

  void _onItemTapped(
    _ItemTapped event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) {
    // Don't allow tapping if already answered or question audio is still playing
    if (state.isQuestionAudioPlaying) {
      return;
    }

    final tappedItem = event.tappedItem;
    final isCorrect =
        tappedItem.nameEn == state.currentQuestion?.nameEn &&
        tappedItem.nameNp == state.currentQuestion?.nameNp;

    emit(
      state.copyWith(
        selectedItem: tappedItem,
        isCorrect: isCorrect,
        isAnswered: true,
        isAudioPlaying: true,
      ),
    );
  }

  void _onCorrectAudioCompleted(
    _CorrectAudioCompleted event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) {
    emit(state.copyWith(isAudioPlaying: false));
  }
}
