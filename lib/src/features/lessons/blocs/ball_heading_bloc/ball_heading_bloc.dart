import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'ball_heading_event.dart';
part 'ball_heading_state.dart';
part 'ball_heading_bloc.freezed.dart';

class BallHeadingBloc extends Bloc<BallHeadingEvent, BallHeadingState> {
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();

  BallHeadingBloc() : super(_BallHeadingState()) {
    on<_Started>((event, emit) async {
      emit(state.copyWith(content: event.content));
      final conversationAudios = event.content.conversation;
      if (conversationAudios.isNotEmpty) {
        // play all audios in conversation sequentially
        for (final audio in conversationAudios) {
          _audioPlayerService.play(audio);
          await _audioPlayerService.onPlayerComplete.first;
        }
        emit(state.copyWith(isAllAudioCompleted: true));
      } else {
        emit(state.copyWith(isAllAudioCompleted: true));
      }
    });
  }

  @override
  Future<void> close() {
    _audioPlayerService.dispose();
    return super.close();
  }
}
