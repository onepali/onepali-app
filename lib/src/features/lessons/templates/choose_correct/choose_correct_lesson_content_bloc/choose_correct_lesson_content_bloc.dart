import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/src.dart';

part 'choose_correct_lesson_content_event.dart';
part 'choose_correct_lesson_content_state.dart';
part 'choose_correct_lesson_content_bloc.freezed.dart';

class ChooseCorrectLessonContentBloc
    extends
        Bloc<ChooseCorrectLessonContentEvent, ChooseCorrectLessonContentState> {
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;
  ChooseCorrectLessonContentBloc()
    : super(const ChooseCorrectLessonContentState()) {
    on<_Started>(_onStarted);
    on<_QuestionAudioCompleted>(_onQuestionAudioCompleted);
    on<_ItemTapped>(_onItemTapped);
    on<_ItemAudioCompleted>(_onItemAudioCompleted);
    on<_ConfettiFeedback>(_onConfettiFeedback);
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
      // No items with questions, emit error state or handle accordingly
      emit(state.copyWith(lessonContent: content));
      return;
    }

    // Select a random item with question
    final random = Random();
    final selectedQuestion =
        itemsWithQuestion[random.nextInt(itemsWithQuestion.length)];
    emit(
      state.copyWith(lessonContent: content, currentQuestion: selectedQuestion),
    );
    if (selectedQuestion.question != null) {
      emit(
        state.copyWith(
          status: ChooseCorrectLessonContentStatus.questionAudioPlaying,
        ),
      );
      await _audioPlayerService.play(selectedQuestion.question!);
      _audioSub?.cancel();
      _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
        add(const ChooseCorrectLessonContentEvent.questionAudioCompleted());
      });
    }
  }

  void _onQuestionAudioCompleted(
    _QuestionAudioCompleted event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) {
    emit(state.copyWith(status: ChooseCorrectLessonContentStatus.ideal));
  }

  void _onItemTapped(
    _ItemTapped event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) async {
    // Don't allow tapping if already answered or question audio is still playing
    if (state.status != ChooseCorrectLessonContentStatus.ideal) {
      return;
    }

    final tappedItem = event.tappedItem;
    final isCorrect =
        tappedItem.nameEn == state.currentQuestion?.nameEn &&
        tappedItem.nameNp == state.currentQuestion?.nameNp;

    await _audioPlayerService.playAsset(
      isCorrect ? Assets.starBlast : Assets.wrongSfx,
    );
    emit(
      state.copyWith(
        selectedItem: tappedItem,
        status: ChooseCorrectLessonContentStatus.itemAudioPlaying,
        isCorrect: isCorrect,
        isAnswered: true,
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    if (tappedItem.audioItem != null) {
      await _audioPlayerService.play(tappedItem.audioItem!);
      _audioSub?.cancel();
      _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
        add(const ChooseCorrectLessonContentEvent.itemAudioCompleted());
      });
    }
  }

  void _onItemAudioCompleted(
    _ItemAudioCompleted event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) {
    emit(
      state.copyWith(
        isCorrect:
            state.selectedItem?.nameEn == state.currentQuestion?.nameEn &&
            state.selectedItem?.nameNp == state.currentQuestion?.nameNp,
        status: state.isCorrect
            ? ChooseCorrectLessonContentStatus.completed
            : ChooseCorrectLessonContentStatus.ideal,
        isAnswered: true,
      ),
    );
  }

  void _onConfettiFeedback(
    _ConfettiFeedback event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) async {
    await _audioPlayerService.playAsset(Assets.confettiFeedback);
  }

  @override
  Future<void> close() {
    _audioPlayerService.dispose();
    _audioSub?.cancel();
    _audioSub = null;
    return super.close();
  }
}
