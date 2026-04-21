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
        await audioPlayerService.play(event.content.instruction!);
        _audioSub?.cancel();
        _audioSub = audioPlayerService.onPlayerComplete.listen((_) {
          add(const OptionSlectionEvent.audioCompleted());
        });
      } else {
        add(const OptionSlectionEvent.audioCompleted());
      }
    });
    on<_AudioCompleted>((event, emit) {
      emit(state.copyWith(status: OptionSelectionStatus.ideal));
    });
    on<_OptionTapped>((event, emit) async {
      final currentContent = state.content;
      if (currentContent == null) return;
      if (event.option.isCorrect) {
        emit(state.copyWith(status: OptionSelectionStatus.completed));
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
