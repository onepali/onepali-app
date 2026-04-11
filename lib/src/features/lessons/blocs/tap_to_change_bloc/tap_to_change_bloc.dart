import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tap_to_change_event.dart';
part 'tap_to_change_state.dart';
part 'tap_to_change_bloc.freezed.dart';

class TapToChangeBloc extends Bloc<TapToChangeEvent, TapToChangeState> {
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;
  TapToChangeBloc() : super(_Initial()) {
    on<TapToChangeEvent>((event, emit) async {
      event.map(
        started: (e) => _onStarted(e, emit),
        audioCompleted: (e) => _onAudioCompleted(emit),
        tapped: (e) => _onTapped(e, emit),
      );
    });
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<TapToChangeState> emit,
  ) async {
    emit(
      state.copyWith(content: event.content, status: TapToChangeStatus.initial),
    );
    if (event.content.audio != null) {
      emit(state.copyWith(status: TapToChangeStatus.audioPlaying));
      await _audioPlayerService.play(event.content.audio!);
      _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
        add(const TapToChangeEvent.audioCompleted());
      });
    } else {
      // No audio — go straight to idle
      emit(state.copyWith(status: TapToChangeStatus.idle));
    }
  }

  void _onAudioCompleted(Emitter<TapToChangeState> emit) {
    _audioSub?.cancel();
    _audioSub = null;
    emit(state.copyWith(status: TapToChangeStatus.idle));
  }

  void _onTapped(_Tapped event, Emitter<TapToChangeState> emit) {
    _audioPlayerService.playAsset(Assets.starBlast);
    emit(
      state.copyWith(
        status: TapToChangeStatus.tapped,
        tapPosition: event.point,
      ),
    );
  }

  @override
  Future<void> close() {
    _audioSub?.cancel();
    _audioPlayerService.dispose();
    return super.close();
  }
}
