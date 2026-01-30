import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tap_to_reveal_lesson_content_event.dart';
part 'tap_to_reveal_lesson_content_state.dart';
part 'tap_to_reveal_lesson_content_bloc.freezed.dart';

class TapToRevealLessonContentBloc
    extends Bloc<TapToRevealLessonContentEvent, TapToRevealLessonContentState> {
  TapToRevealLessonContentBloc()
    : super(const TapToRevealLessonContentState()) {
    on<_Started>(_onStarted);
    on<_QuestionAudioCompleted>(_onQuestionAudioCompleted);
    on<_ItemTapped>(_onItemTapped);
    on<_CorrectAudioCompleted>(_onCorrectAudioCompleted);
  }

  void _onStarted(_Started event, Emitter<TapToRevealLessonContentState> emit) {
    final twoItems = _pickTwoRandomItems(event.content.items);

    if (twoItems.isEmpty) {
      emit(
        state.copyWith(
          content: event.content,
          errorMessage: 'This lesson needs at least two question items.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        content: event.content,
        selectedItems: twoItems,
        currentQuestionIndex: 0,
        currentQuestion: twoItems[0],
        isQuestionAudioPlaying: true,
        errorMessage: null,
      ),
    );
  }

  void _onQuestionAudioCompleted(
    _QuestionAudioCompleted event,
    Emitter<TapToRevealLessonContentState> emit,
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
    Emitter<TapToRevealLessonContentState> emit,
  ) {
    // Don't allow tapping if question audio is still playing or if correct audio is playing
    if (state.isQuestionAudioPlaying || state.isCorrectAudioPlaying) {
      return;
    }

    final tappedItem = event.tappedItem;
    final currentQuestion = state.currentQuestion;

    if (currentQuestion == null) return;

    // Check if the tapped item matches the current question
    final isCorrect =
        tappedItem.nameEn == currentQuestion.nameEn &&
        tappedItem.nameNp == currentQuestion.nameNp;

    emit(
      state.copyWith(
        tappedItem: tappedItem,
        isCorrect: isCorrect,
        isAnswered: true,
        isCorrectAudioPlaying: true, // Play audio for both correct and wrong
        showCorrectName: isCorrect,
      ),
    );
  }

  // void _onCorrectAudioCompleted(
  //   _CorrectAudioCompleted event,
  //   Emitter<TapToRevealLessonContentState> emit,
  // ) {
  // emit(state.copyWith(
  //   isCorrectAudioPlaying: false,
  // ));

  // // Automatically proceed to next question ONLY if answer was correct
  // if (state.isCorrect && state.isAnswered) {
  //   final nextIndex = state.currentQuestionIndex + 1;

  //   // Check if we've completed all questions
  //   if (nextIndex >= state.selectedItems.length) {
  //     emit(state.copyWith(
  //       allQuestionsCompleted: true,
  //       isAnswered: false,
  //     ));
  //     return;
  //   }

  //   // Move to next question automatically
  //   emit(state.copyWith(
  //     currentQuestionIndex: nextIndex,
  //     currentQuestion: state.selectedItems[nextIndex],
  //     isQuestionAudioPlaying: true,
  //     isQuestionAudioCompleted: false,
  //     tappedItem: null,
  //     isCorrect: false,
  //     isAnswered: false,
  //     isCorrectAudioPlaying: false,
  //   ));
  // } else if (!state.isCorrect) {
  //   // Reset state to allow another tap (wrong answer)
  //   emit(state.copyWith(
  //     tappedItem: null,
  //     isAnswered: false,
  //   ));
  // }}

  void _onCorrectAudioCompleted(
    _CorrectAudioCompleted event,
    Emitter<TapToRevealLessonContentState> emit,
  ) async {
    emit(state.copyWith(isCorrectAudioPlaying: false));

    // Hide the correct name after a delay
    if (state.isCorrect) {
      await Future.delayed(const Duration(milliseconds: 1500));

      emit(state.copyWith(showCorrectName: false));

      // Small delay before moving to next question
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Automatically proceed to next question ONLY if answer was correct
    if (state.isCorrect && state.isAnswered) {
      final nextIndex = state.currentQuestionIndex + 1;

      // Check if we've completed all questions
      if (nextIndex >= state.selectedItems.length) {
        emit(state.copyWith(allQuestionsCompleted: true, isAnswered: false));
        return;
      }

      // Move to next question automatically
      emit(
        state.copyWith(
          currentQuestionIndex: nextIndex,
          currentQuestion: state.selectedItems[nextIndex],
          isQuestionAudioPlaying: true,
          isQuestionAudioCompleted: false,
          tappedItem: null,
          isCorrect: false,
          isAnswered: false,
          isCorrectAudioPlaying: false,
          showCorrectName: false,
        ),
      );
    } else if (!state.isCorrect) {
      // Reset state to allow another tap (wrong answer)
      emit(state.copyWith(tappedItem: null, isAnswered: false));
    }
  }

  List<Item> _pickTwoRandomItems(List<Item> items) {
    // only items that have a question
    final validItems = items
        .where((e) => e.question != null && e.question!.isNotEmpty)
        .toList();

    if (validItems.length < 2) {
      return [];
    }

    validItems.shuffle();
    return validItems.take(2).toList();
  }
}
