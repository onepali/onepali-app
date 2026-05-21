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
      emit(
        state.copyWith(
          content: event.content,
          bgImageMb: event.content.preBgImageMb ?? event.content.bgImage,
          bgImageTb: event.content.preBgImageTb ?? event.content.bgImageTb,
          status: event.content.audioBeforeOptions != null
              ? TapToFillStatus.audioBeforeOptionsPlaying
              : TapToFillStatus.audioPlaying,
        ),
      );
      if (event.content.audioBeforeOptions != null) {
        await audioPlayerService.play(event.content.audioBeforeOptions!);
        _audioSub?.cancel();
        _audioSub = audioPlayerService.onPlayerComplete.listen((_) {
          add(const TapToFillEvent.audioBeforeOptionsCompleted());
        });
      } else if (event.content.instruction != null) {
        await audioPlayerService.play(event.content.instruction!);
        _audioSub?.cancel();
        _audioSub = audioPlayerService.onPlayerComplete.listen((_) {
          add(const TapToFillEvent.audioCompleted());
        });
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
      if (state.content?.instruction != null) {
        await audioPlayerService.play(state.content!.instruction!);
        _audioSub?.cancel();
        _audioSub = audioPlayerService.onPlayerComplete.listen((_) {
          add(const TapToFillEvent.audioCompleted());
        });
      } else {
        add(const TapToFillEvent.audioCompleted());
      }
    });
    on<_AudioCompleted>((event, emit) {
      emit(state.copyWith(status: TapToFillStatus.ideal));
    });
    on<_OptionTapped>((event, emit) async {
      final currentContent = state.content;
      if (currentContent == null) return;
      if (event.option.isCorrect) {
        emit(state.copyWith(status: TapToFillStatus.completed));
      } else {
        await audioPlayerService.playAsset(Assets.wrongSfx);
      }
    });
  }
  @override
  Future<void> close() {
    audioPlayerService.dispose();
    return super.close();
  }
}
