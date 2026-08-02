import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/constants/assets.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tap_to_pop_event.dart';
part 'tap_to_pop_state.dart';
part 'tap_to_pop_bloc.freezed.dart';

class TapToPopBloc extends Bloc<TapToPopEvent, TapToPopState> {
  final _audioPlayer = AudioPlayer();
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  TapToPopBloc() : super(_Initial()) {
    on<_Started>((event, emit) {
      final items = event.content.items;
      final correctItems = items.where((item) => item.isCorrect).toList();
      emit(state.copyWith(content: event.content, correctItems: correctItems));
      unawaited(_playInstructionAudio(event.content));
    });
    on<_TapItem>((event, emit) async {
      final items = state.correctItems ?? [];
      final correctItems = List<Item>.from(items);
      if (event.item.isCorrect) {
        final tappedIndex = correctItems.indexWhere(
          (item) => identical(item, event.item),
        );
        if (tappedIndex == -1) {
          return;
        }
        correctItems.removeAt(tappedIndex);
        final isCompleted = correctItems.isEmpty;
        emit(
          state.copyWith(
            content: state.content,
            correctItems: correctItems,
            completed: false,
          ),
        );
        if (isCompleted) {
          await _playCorrectItemAudio(event.item, waitForCompletion: true);
          await _playCorrectFeedbackAudio();
          emit(
            state.copyWith(
              content: state.content,
              correctItems: correctItems,
              completed: true,
            ),
          );
        } else {
          unawaited(_playCorrectItemAudio(event.item));
        }
        return;
      } else {
        _audioPlayer.play(AssetSource('audio/sfx/wrong.mp3'));
      }
      log('correctItems: $correctItems');
      emit(
        state.copyWith(
          content: state.content,
          correctItems: correctItems,
          completed: correctItems.isEmpty,
        ),
      );
    });
  }

  Future<void> _playInstructionAudio(TapToPopLessonContent content) async {
    final audioSource = content.instructionAudio;
    if (audioSource == null || audioSource.isEmpty) return;

    try {
      await _audioPlayerService.play(audioSource);
    } catch (e) {
      log('Error playing tap to pop instruction audio: $e');
    }
  }

  Future<void> _playCorrectItemAudio(
    Item item, {
    bool waitForCompletion = false,
  }) async {
    final audioSource = state.content?.audioWord;
    if (audioSource == null || audioSource.isEmpty) return;

    try {
      await _audioPlayerService.stop();
      final completed = waitForCompletion
          ? _audioPlayerService.onPlayerComplete.first.timeout(
              const Duration(seconds: 3),
            )
          : null;
      await _audioPlayerService.play(audioSource);
      await completed;
    } catch (e) {
      log('Error playing tap to pop word audio: $e');
    }
  }

  Future<void> _playCorrectFeedbackAudio() async {
    try {
      await _audioPlayerService.playAsset(Assets.starBlast);
    } catch (e) {
      log('Error playing tap to pop completion feedback audio: $e');
    }
  }

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    await _audioPlayerService.dispose();
    return super.close();
  }
}
