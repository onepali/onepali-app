import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tutorial_event.dart';
part 'tutorial_state.dart';
part 'tutorial_bloc.freezed.dart';

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  final player = AudioPlayer();
  List<String> ingridents = [
    'assets/svg/teapot.svg',
    'assets/svg/water_glass.svg',
    'assets/svg/milk.svg',
    'assets/svg/ginger.svg',
    'assets/svg/tea.svg',
    'assets/svg/spoon.svg',
  ];
  List<String> onDraggedItems = [
    'assets/svg/teapot1.svg',
    'assets/svg/teapot_water.svg',
    'assets/svg/teapot_milk.svg',
    'assets/svg/teapot_ginger.svg',
    'assets/svg/teapot_tea.svg',
    'assets/svg/teapot_spoon.svg',
  ];
  List<String> audioFiles = [
    'music/making-tea-3.mp3', // paani hala
    'music/making-tea-4.mp3', // dudh hala

    'music/making-tea-6.mp3', // aduwa hala
    'music/making-tea-7.mp3', // chiya patti rakha
    'music/making-tea-8.mp3', // chamcha le chalau
  ];
  // 'music/making-tea-5.mp3',// aba umala
  TutorialBloc() : super(TutorialState()) {
    //1: Started
    on<_Started>((event, emit) async {
      emit(state.copyWith(ingredients: ingridents));

      await player.play(AssetSource('music/making-tea-1.mp3'));
      emit(state.copyWith(showBearWithTea: true));
      // after player is completed hide the bear and show the huncha
      await player.onPlayerComplete.first;
      emit(state.copyWith(showBearWithTea: false, showHunchButton: true));
    });
    on<_HunchaButtonPressed>((event, emit) async {
      emit(state.copyWith(showHunchButton: false));
      await player.play(AssetSource('music/making-tea-ok.mp3'));
      await player.onPlayerComplete.first;
      emit(state.copyWith(showDragIndicator: true));
      await player.play(AssetSource('music/making-tea-2.mp3'));
      await player.onPlayerComplete.first;
      emit(state.copyWith(index: 0));
    });
    on<_OnDragAccept>((event, emit) async {
      if (event.index != state.index) return;
      // also if player is playing don't do anything
      if (player.state == PlayerState.playing) return;
      droppedItemText(event.index, emit);
      unawaited(player.play(AssetSource('music/correct.mp3')));
      emit(
        state.copyWith(
          index: state.index + 1,
          draggedItemPath: onDraggedItems[event.index],
          showDragIndicator: false,
        ),
      );
      if (event.index == 2) {
        // aba paani umala
        await Future.delayed(const Duration(seconds: 2));
        await player.play(AssetSource('music/making-tea-5.mp3'));
        await player.onPlayerComplete.first;
        emit(
          state.copyWith(
            draggedItemPath: 'assets/svg/teapot_vapour.svg',
            droppedItem: 'उमाल',
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        await playNextAudio(event.index, audioFiles[event.index]);
      } else if (event.index == 5) {
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(teaReady: true));
        await player.play(AssetSource('music/making-tea-9.mp3'));
        await player.onPlayerComplete.first;
      } else {
        await playNextAudio(event.index, audioFiles[event.index]);
      }
    });
  }
  Future<void> playNextAudio(int index, audioFile) async {
    await Future.delayed(const Duration(seconds: 2));
    await player.play(AssetSource(audioFiles[index]));
    await player.onPlayerComplete.first;
  }

  Future<void> droppedItemText(int index, Emitter<TutorialState> emit) async {
    switch (index) {
      case 0:
        emit(state.copyWith(droppedItem: 'कित्ली'));
        break;
      case 1:
        emit(state.copyWith(droppedItem: 'पानी'));
        break;
      case 2:
        emit(state.copyWith(droppedItem: 'दुध'));
      case 3:
        emit(state.copyWith(droppedItem: 'अदुवा'));
        break;
      case 4:
        emit(state.copyWith(droppedItem: 'चियापति'));
        break;
      case 5:
        emit(state.copyWith(droppedItem: 'चम्चा'));
        break;
    }
  }

  @override
  Future<void> close() {
    player.dispose();
    return super.close();
  }
}
