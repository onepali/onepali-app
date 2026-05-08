import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'match_event.dart';
part 'match_state.dart';
part 'match_bloc.freezed.dart';
part 'match_bloc.g.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final _audioPlayerService = AudioPlayerServiceImpl();
  MatchBloc() : super(MatchState()) {
    on<_Started>(_onStarted);
    on<_OnAccept>(_onAccept);
  }

  Future<void> _onStarted(_Started event, Emitter<MatchState> emit) async {
    final nepaliWords = event.content.items.map((item) => item.nameNp).toList();

    nepaliWords.shuffle();
    final nepaliWordsList = nepaliWords
        .map((word) => NepaliWord(word: word))
        .toList();
    emit(state.copyWith(content: event.content, nepaliWords: nepaliWordsList));
  }

  void _onAccept(_OnAccept event, Emitter<MatchState> emit) async {
    var updatedNepaliWords = List<NepaliWord>.from(state.nepaliWords);

    // update the isMatche to truen in NepaliWord. and keep other words as is
    updatedNepaliWords = updatedNepaliWords
        .map(
          (word) => word.word == event.nepaliWord
              ? word.copyWith(isMatched: true)
              : word,
        )
        .toList();
    // update the state.content.items with the updatedNepaliWords to isCorrect true if the word is matched
    final updatedItems = state.content!.items
        .map(
          (e) => e.nameNp == event.nepaliWord ? e.copyWith(isCorrect: true) : e,
        )
        .toList();
    final selectedItem = state.content!.items.firstWhere(
      (e) => e.nameNp == event.nepaliWord,
    );
    emit(
      state.copyWith(
        nepaliWords: updatedNepaliWords,
        content: state.content!.copyWith(items: updatedItems),
        isAnsweredAll: updatedNepaliWords.every((word) => word.isMatched),
      ),
    );
    if (selectedItem.audioItem != null) {
      _audioPlayerService.play(selectedItem.audioItem!);
    } else {
      _audioPlayerService.playAsset(Assets.starBlast);
    }
  }

  @override
  Future<void> close() {
    _audioPlayerService.dispose();
    return super.close();
  }
}
