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
        errorMessage: null,
      ),
    );
    final questionAudio = selectedQuestion.question;
    if (questionAudio != null && questionAudio.isNotEmpty) {
      emit(
        state.copyWith(
          status: ChooseCorrectLessonContentStatus.questionAudioPlaying,
          errorMessage: null,
        ),
      );
      await _audioSub?.cancel();
      _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
        add(const ChooseCorrectLessonContentEvent.questionAudioCompleted());
      });
      try {
        await _audioPlayerService.play(questionAudio);
      } catch (error, stackTrace) {
        logger.e(
          'Error playing choose-correct question audio: $error\n$stackTrace',
        );
        add(const ChooseCorrectLessonContentEvent.questionAudioCompleted());
      }
    }
  }

  Future<void> _onQuestionAudioCompleted(
    _QuestionAudioCompleted event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) async {
    await _audioSub?.cancel();
    _audioSub = null;
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

    try {
      await _audioPlayerService.playAsset(
        isCorrect ? Assets.starBlast : Assets.wrongSfx,
      );
    } catch (error, stackTrace) {
      logger.e(
        'Error playing choose-correct feedback audio: $error\n$stackTrace',
      );
    }
    emit(
      state.copyWith(
        selectedItem: tappedItem,
        status: ChooseCorrectLessonContentStatus.itemAudioPlaying,
        isCorrect: isCorrect,
        isAnswered: true,
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    final itemAudio = tappedItem.audioItem;
    if (itemAudio == null || itemAudio.isEmpty) {
      add(const ChooseCorrectLessonContentEvent.itemAudioCompleted());
      return;
    }

    await _audioSub?.cancel();
    _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
      add(const ChooseCorrectLessonContentEvent.itemAudioCompleted());
    });
    try {
      await _audioPlayerService.play(itemAudio);
    } catch (error, stackTrace) {
      logger.e('Error playing choose-correct item audio: $error\n$stackTrace');
      add(const ChooseCorrectLessonContentEvent.itemAudioCompleted());
    }
  }

  Future<void> _onItemAudioCompleted(
    _ItemAudioCompleted event,
    Emitter<ChooseCorrectLessonContentState> emit,
  ) async {
    await _audioSub?.cancel();
    _audioSub = null;
    final isCorrect =
        state.selectedItem?.nameEn == state.currentQuestion?.nameEn &&
        state.selectedItem?.nameNp == state.currentQuestion?.nameNp;
    emit(
      state.copyWith(
        isCorrect: isCorrect,
        status: isCorrect
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
  Future<void> close() async {
    await _audioSub?.cancel();
    _audioSub = null;
    await _audioPlayerService.dispose();
    await super.close();
  }
}
