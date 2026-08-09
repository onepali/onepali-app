import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'option_slection_event.dart';
part 'option_slection_state.dart';
part 'option_slection_bloc.freezed.dart';

class OptionSlectionBloc
    extends Bloc<OptionSlectionEvent, OptionSlectionState> {
  final AudioPlayerService audioPlayerService = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;
  OptionSlectionBloc() : super(const _OptionSlectionState()) {
    on<_Started>((event, emit) async {
      emit(
        state.copyWith(
          content: event.content,
          status: OptionSelectionStatus.audioPlaying,
        ),
      );
      if (event.content.instruction != null) {
        await _playAudio(event.content.instruction!);
      } else {
        add(const OptionSlectionEvent.audioCompleted());
      }
    });
    on<_AudioCompleted>((event, emit) async {
      await _audioSub?.cancel();
      _audioSub = null;
      emit(state.copyWith(status: OptionSelectionStatus.ideal));
    });
    on<_OptionTapped>((event, emit) async {
      final currentContent = state.content;
      if (currentContent == null) return;
      if (event.option.isCorrect) {
        emit(state.copyWith(status: OptionSelectionStatus.completed));
      } else {
        try {
          await audioPlayerService.playAsset(Assets.wrongSfx);
        } catch (error, stackTrace) {
          logger.e(
            'Error playing option-selection wrong SFX: $error\n$stackTrace',
          );
        }
      }
    });
  }

  Future<void> _playAudio(String audioPath) async {
    await _audioSub?.cancel();
    _audioSub = audioPlayerService.onPlayerComplete.listen((_) {
      add(const OptionSlectionEvent.audioCompleted());
    });
    try {
      await audioPlayerService.play(audioPath);
    } catch (error, stackTrace) {
      logger.e('Error playing option-selection audio: $error\n$stackTrace');
      add(const OptionSlectionEvent.audioCompleted());
    }
  }

  @override
  Future<void> close() async {
    await _audioSub?.cancel();
    _audioSub = null;
    await audioPlayerService.dispose();
    return super.close();
  }
}
