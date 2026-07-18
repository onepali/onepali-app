import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tap_to_fill_event.dart';
part 'tap_to_fill_state.dart';
part 'tap_to_fill_bloc.freezed.dart';

class TapToFillBloc extends Bloc<TapToFillEvent, TapToFillState> {
  final AudioPlayerService audioPlayerService = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;
  TapToFillBloc() : super(_TapToFillState()) {
    on<_Started>((event, emit) async {
      final audioBeforeOptions = event.content.audioBeforeOptions;
      final hasAudioBeforeOptions =
          audioBeforeOptions != null && audioBeforeOptions.isNotEmpty;
      final instruction = event.content.instruction;
      final hasInstruction = instruction != null && instruction.isNotEmpty;
      emit(
        state.copyWith(
          content: event.content,
          bgImageMb: event.content.preBgImageMb ?? event.content.bgImage,
          bgImageTb: event.content.preBgImageTb ?? event.content.bgImageTb,
          status: hasAudioBeforeOptions
              ? TapToFillStatus.audioBeforeOptionsPlaying
              : TapToFillStatus.audioPlaying,
        ),
      );
      if (hasAudioBeforeOptions) {
        await _playAudio(
          audioPath: audioBeforeOptions,
          completedEvent: const TapToFillEvent.audioBeforeOptionsCompleted(),
        );
      } else if (hasInstruction) {
        await _playAudio(
          audioPath: instruction,
          completedEvent: const TapToFillEvent.audioCompleted(),
        );
      } else {
        add(const TapToFillEvent.audioCompleted());
      }
    });
    on<_AudioBeforeOptionsCompleted>((event, emit) async {
      emit(
        state.copyWith(
          status: TapToFillStatus.audioBeforeOptionsCompleted,
          bgImageMb: state.content?.bgImage,
          bgImageTb: state.content?.bgImageTb,
        ),
      );
      final instruction = state.content?.instruction;
      if (instruction != null && instruction.isNotEmpty) {
        await _playAudio(
          audioPath: instruction,
          completedEvent: const TapToFillEvent.audioCompleted(),
        );
      } else {
        add(const TapToFillEvent.audioCompleted());
      }
    });
    on<_AudioCompleted>((event, emit) async {
      await _audioSub?.cancel();
      _audioSub = null;
      emit(state.copyWith(status: TapToFillStatus.ideal));
    });
    on<_OptionTapped>((event, emit) async {
      final currentContent = state.content;
      if (currentContent == null) return;
      if (event.option.isCorrect) {
        emit(state.copyWith(status: TapToFillStatus.completed));
      } else {
        try {
          await audioPlayerService.playAsset(Assets.wrongSfx);
        } catch (error, stackTrace) {
          logger.e('Error playing TapToFill wrong SFX: $error\n$stackTrace');
        }
      }
    });
  }

  Future<void> _playAudio({
    required String audioPath,
    required TapToFillEvent completedEvent,
  }) async {
    await _audioSub?.cancel();
    _audioSub = audioPlayerService.onPlayerComplete.listen((_) {
      add(completedEvent);
    });
    try {
      await audioPlayerService.play(audioPath);
    } catch (error, stackTrace) {
      logger.e('Error playing TapToFill audio: $error\n$stackTrace');
      add(completedEvent);
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
