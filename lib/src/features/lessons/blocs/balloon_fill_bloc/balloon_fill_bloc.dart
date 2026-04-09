import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'balloon_fill_event.dart';
part 'balloon_fill_state.dart';
part 'balloon_fill_bloc.freezed.dart';

class BalloonFillBloc extends Bloc<BalloonFillEvent, BalloonFillState> {
  BalloonFillBloc() : super(const BalloonFillState()) {
    on<_Started>(_onStarted);
    on<_AudioCompleted>(_onAudioCompleted);
    on<_BalloonTapped>(_onBalloonTapped);
    on<_FillAnimationCompleted>(_onFillAnimationCompleted);
    on<_LabelHidden>(_onLabelHidden);
    on<_FilledBalloonTapped>(_onFilledBalloonTapped);
    on<_Reset>(_onReset);
  }

  final AudioPlayerService _audioPlayer = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;

  Future<void> _onStarted(
    _Started event,
    Emitter<BalloonFillState> emit,
  ) async {
    emit(
      state.copyWith(content: event.content, status: BalloonFillStatus.initial),
    );

    if (event.content.audio != null) {
      emit(state.copyWith(status: BalloonFillStatus.audioPlaying));
      await _audioPlayer.play(event.content.audio!);

      // Cancel any previous subscription before creating a new one
      await _audioSub?.cancel();
      _audioSub = _audioPlayer.onPlayerComplete.listen((_) {
        add(const BalloonFillEvent.audioCompleted());
      });
    } else {
      // No audio — go straight to idle
      emit(state.copyWith(status: BalloonFillStatus.idle));
    }
  }

  void _onAudioCompleted(
    _AudioCompleted event,
    Emitter<BalloonFillState> emit,
  ) {
    _audioSub?.cancel();
    _audioSub = null;
    emit(state.copyWith(status: BalloonFillStatus.idle));
  }

  void _onBalloonTapped(_BalloonTapped event, Emitter<BalloonFillState> emit) {
    if (state.isLocked) return;
    if (state.isFilled(event.index)) return;

    emit(
      state.copyWith(
        status: BalloonFillStatus.filling,
        fillingIndex: event.index,
      ),
    );
  }

  Future<void> _onFillAnimationCompleted(
    _FillAnimationCompleted event,
    Emitter<BalloonFillState> emit,
  ) async {
    final index = state.fillingIndex;
    if (index == null) return;
    final item = state.content?.items[index];
    if (item == null) return;
    final label = item.nameNp;
    final updatedFilled = {...state.filledIndexes, index};

    emit(
      state.copyWith(
        status: BalloonFillStatus.showingLabel,
        filledIndexes: updatedFilled,
        fillingIndex: null,
        colorLabelNp: label,
      ),
    );
    if (item.audioItem != null) {
      _audioPlayer.play(state.content?.items[index].audioItem ?? '');

      // BLoC owns the label timer — not the UI
      await Future.delayed(const Duration(seconds: 2));
    }
    add(const BalloonFillEvent.labelHidden());
  }

  void _onLabelHidden(_LabelHidden event, Emitter<BalloonFillState> emit) {
    emit(state.copyWith(status: BalloonFillStatus.idle, colorLabelNp: null));
  }

  void _onFilledBalloonTapped(
    _FilledBalloonTapped event,
    Emitter<BalloonFillState> emit,
  ) async {
    final item = state.content?.items[event.index];
    if (item == null) return;
    emit(state.copyWith(status: BalloonFillStatus.showingLabel));
    if (item.audioItem != null) {
      _audioPlayer.play(item.audioItem ?? '');
    }
    add(const BalloonFillEvent.labelHidden());
  }

  void _onReset(_Reset event, Emitter<BalloonFillState> emit) {
    emit(
      state.copyWith(
        status: BalloonFillStatus.idle,
        filledIndexes: {},
        fillingIndex: null,
        colorLabelNp: null,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _audioSub?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
