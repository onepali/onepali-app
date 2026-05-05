import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tap_the_button_event.dart';
part 'tap_the_button_state.dart';
part 'tap_the_button_bloc.freezed.dart';

class TapTheButtonBloc extends Bloc<TapTheButtonEvent, TapTheButtonState> {
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;
  TapTheButtonBloc() : super(const TapTheButtonState()) {
    on<TapTheButtonEvent>((event, emit) {
      event.map(
        started: (e) => _onStarted(e, emit),
        audioCompleted: (e) => _onAudioCompleted(emit, e.isCompleted),
        tapped: (e) => _onTapped(e, emit),
      );
    });
  }
  Future<void> _onStarted(
    _Started event,
    Emitter<TapTheButtonState> emit,
  ) async {
    emit(
      state.copyWith(
        content: event.content,
        status: TapTheButtonStatus.audioPlaying,
      ),
    );
    if (event.content.instruction != null) {
      emit(state.copyWith(status: TapTheButtonStatus.audioPlaying));
      await _audioPlayerService.play(event.content.instruction!);
      _audioSub?.cancel();
      _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
        add(const TapTheButtonEvent.audioCompleted(false));
      });
    } else {
      add(const TapTheButtonEvent.audioCompleted(false));
    }
  }

  void _onAudioCompleted(Emitter<TapTheButtonState> emit, bool isCompleted) {
    _audioSub?.cancel();
    _audioSub = null;
    emit(
      state.copyWith(
        status: isCompleted
            ? TapTheButtonStatus.completed
            : TapTheButtonStatus.idle,
      ),
    );
  }

  Future<void> _onTapped(_Tapped event, Emitter<TapTheButtonState> emit) async {
    emit(state.copyWith(status: TapTheButtonStatus.tapped));
    if (state.content?.tapAudio == null) return;
    await _audioPlayerService.stop();
    await _audioPlayerService.play(state.content!.tapAudio!);
    _audioSub?.cancel();
    _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
      add(const TapTheButtonEvent.audioCompleted(true));
    });
   
  }

  @override
  Future<void> close() async {
    await _audioSub?.cancel();
    _audioPlayerService.dispose();
    super.close();
  }
}
