import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tap_to_pop_event.dart';
part 'tap_to_pop_state.dart';
part 'tap_to_pop_bloc.freezed.dart';

class TapToPopBloc extends Bloc<TapToPopEvent, TapToPopState> {
  final _audioPlayer = AudioPlayer();
  StreamSubscription<void>? audioPlayerSubscription;
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  TapToPopBloc() : super(_Initial()) {
    on<_Started>((event, emit) async {
      final items = event.content.items;
      final correctItems = items.where((item) => item.isCorrect).toList();
      final correctItemsCount = correctItems.length;
      emit(
        state.copyWith(
          content: event.content,
          correctItemsCount: correctItemsCount,
        ),
      );
      if (event.content.instructionAudio != null) {
        await _audioPlayerService.play(event.content.instructionAudio!);
        audioPlayerSubscription = _audioPlayerService.onPlayerComplete.listen((
          _,
        ) async {
          add(_InstructionAudioCompleted());
        });
      }
    });
    on<_InstructionAudioCompleted>((event, emit) {
      emit(state.copyWith(instructionAudioPlayed: true));
    });
    on<_TapItem>((event, emit) async {
      final allItems = List<Item>.from(state.content!.items);
      final selectedItems = List<Item>.from(state.selectedItems ?? []);

      // remove from correctItems
      if (event.item.isCorrect) {
        allItems.remove(event.item);
        selectedItems.add(event.item);
        emit(state.copyWith(selectedItems: selectedItems));
      } else {
        // Play incorrect sound
        _audioPlayer.play(AssetSource('audio/sfx/wrong.mp3'));
      }
      emit(state.copyWith(content: state.content?.copyWith(items: allItems)));
      final isCompleted =
          state.correctItemsCount == state.selectedItems?.length;
      if (isCompleted && state.content?.audioWord != null) {
        await _audioPlayerService.play(state.content!.audioWord!);
      }
      emit(
        state.copyWith(
          completed: state.selectedItems?.length == state.correctItemsCount,
        ),
      );
    });
  }
}
