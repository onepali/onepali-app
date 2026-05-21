import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/services/audio_record_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'listen_and_repeat_event.dart';
part 'listen_and_repeat_state.dart';
part 'listen_and_repeat_bloc.freezed.dart';

class ListenAndRepeatBloc
    extends Bloc<ListenAndRepeatEvent, ListenAndRepeatState> {
  final AudioPlayerService _audioPlayerService;
  final AudioRecorderService _audioRecorderService;

  Timer? _recordingTimer;
  StreamSubscription? _playerSubscription;

  ListenAndRepeatBloc({
    required AudioPlayerService audioPlayerService,
    required AudioRecorderService audioRecorderService,
  }) : _audioPlayerService = audioPlayerService,
       _audioRecorderService = audioRecorderService,
       super(const ListenAndRepeatState()) {
    on<ListenAndRepeatEvent>(_onEvent);
  }

  Future<void> _onEvent(
    ListenAndRepeatEvent event,
    Emitter<ListenAndRepeatState> emit,
  ) async {
    await event.map(
      started: (e) => _onStarted(e, emit),
      audioFinished: (_) => _onAudioFinished(emit),
      recordingTimerTick: (e) => _onRecordingTimerTick(e, emit),
      recordingCompleted: (e) => _onRecordingCompleted(e, emit),
      recordingFailed: (e) => _onRecordingFailed(e, emit),
      retryRequested: (_) => _onRetryRequested(emit),
    );
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<ListenAndRepeatState> emit,
  ) async {
    emit(
      state.copyWith(
        content: event.content,
        phase: ListenAndRepeatPhase.playing,
      ),
    );

    try {
      if (state.content == null) {
        throw Exception('No content provided for Listen and Repeat');
      }
      await _playerSubscription?.cancel();
      _playerSubscription = _audioPlayerService.onPlayerComplete.listen((_) {
        add(const ListenAndRepeatEvent.audioFinished());
      });
      await _audioPlayerService.play(state.content!.audioWord);
    } catch (e) {
      await _playerSubscription?.cancel();
      _playerSubscription = null;
      add(ListenAndRepeatEvent.recordingFailed(e.toString()));
    }
  }

  Future<void> _onAudioFinished(Emitter<ListenAndRepeatState> emit) async {
    await _playerSubscription?.cancel();
    _playerSubscription = null;

    emit(state.copyWith(phase: ListenAndRepeatPhase.readyToRecord));

    // Small delay then autostart recording
    await Future.delayed(const Duration(milliseconds: 500));
    if (isClosed) return;
    await _startRecording(emit);
  }

  Future<void> _startRecording(Emitter<ListenAndRepeatState> emit) async {
    try {
      // await _audioRecorderService.startRecording();

      emit(
        state.copyWith(
          phase: ListenAndRepeatPhase.recording,
          recordingElapsed: 0,
        ),
      );

      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final elapsed = timer.tick;
        add(ListenAndRepeatEvent.recordingTimerTick(elapsed));

        if (elapsed >= state.recordingDuration) {
          timer.cancel();
          _stopRecording();
        }
      });
    } catch (e) {
      add(ListenAndRepeatEvent.recordingFailed(e.toString()));
    }
  }

  void _stopRecording() async {
    try {
      // final path = await _audioRecorderService.stopRecording();
      // if (path != null) {
      //Recording feature is not necessary for now, so we are adding a dummy path. If necessary, just uncomment the code of this bloc.
      add(ListenAndRepeatEvent.recordingCompleted('test.m4a'));
      // } else {
      //   add(const ListenAndRepeatEvent.recordingFailed('No audio recorded'));
      // }
    } catch (e) {
      // add(ListenAndRepeatEvent.recordingFailed(e.toString()));
      rethrow;
    }
  }

  Future<void> _onRecordingTimerTick(
    _RecordingTimerTick event,
    Emitter<ListenAndRepeatState> emit,
  ) async {
    emit(state.copyWith(recordingElapsed: event.elapsed));
  }

  Future<void> _onRecordingCompleted(
    _RecordingCompleted event,
    Emitter<ListenAndRepeatState> emit,
  ) async {
    emit(
      state.copyWith(
        phase: ListenAndRepeatPhase.recorded,
        recordedAudioPath: event.audioPath,
      ),
    );
  }

  Future<void> _onRecordingFailed(
    _RecordingFailed event,
    Emitter<ListenAndRepeatState> emit,
  ) async {
    emit(
      state.copyWith(
        phase: ListenAndRepeatPhase.error,
        errorMessage: event.error,
      ),
    );
  }

  Future<void> _onRetryRequested(Emitter<ListenAndRepeatState> emit) async {
    _recordingTimer?.cancel();
    await _playerSubscription?.cancel();
    _playerSubscription = null;
    await _audioPlayerService.stop();
    final content = state.content;

    emit(ListenAndRepeatState());
    if (content == null) return;
    add(ListenAndRepeatEvent.started(content));
  }

  @override
  Future<void> close() async {
    _recordingTimer?.cancel();
    await _playerSubscription?.cancel();
    _playerSubscription = null;
    await _audioPlayerService.dispose();
    await _audioRecorderService.dispose();
    await super.close();
  }
}
