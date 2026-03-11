import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'match_event.dart';
part 'match_state.dart';
part 'match_bloc.freezed.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final _audioPlayerService = AudioPlayerServiceImpl();
  MatchBloc() : super(MatchState()) {
    on<_Started>(_onStarted);
    on<_OnAccept>(_onAccept);
  }

  Future<void> _onStarted(_Started event, Emitter<MatchState> emit) async {
    final nepaliWords = event.content.items.map((item) => item.nameNp).toList();
    nepaliWords.shuffle();
    emit(state.copyWith(content: event.content, nepaliWords: nepaliWords));
  }

  Future<void> _onAccept(_OnAccept event, Emitter<MatchState> emit) async {
    final nepaliWords = List<String>.from(state.nepaliWords);
    nepaliWords.remove(event.nepaliWord);
    // make selected item correct
    final updatedItems = state.content!.items
        .map(
          (e) => e.nameNp == event.nepaliWord ? e.copyWith(isCorrect: true) : e,
        )
        .toList();
    emit(
      state.copyWith(
        content: state.content!.copyWith(items: updatedItems),
        nepaliWords: nepaliWords,
        isAnsweredAll: nepaliWords.isEmpty,
      ),
    );
    await _audioPlayerService.playAsset(Assets.starBlast);
  }

  @override
  Future<void> close() async {
    await _audioPlayerService.dispose();
    return super.close();
  }
}
