import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tap_to_pop_event.dart';
part 'tap_to_pop_state.dart';
part 'tap_to_pop_bloc.freezed.dart';

class TapToPopBloc extends Bloc<TapToPopEvent, TapToPopState> {
  final _audioPlayer = AudioPlayer();
  TapToPopBloc() : super(_Initial()) {
    on<_Started>((event, emit) {
      final items = event.content.items;
      final correctItems = items.where((item) => item.isCorrect).toList();
      emit(state.copyWith(content: event.content, correctItems: correctItems));
    });
    on<_TapItem>((event, emit) {
      final items = state.correctItems ?? [];
      final correctItems = List<Item>.from(items);
      // final allItems = List<Item>.from(state.content!.items);
      // remove from correctItems
      if (correctItems.contains(event.item)) {
        correctItems.remove(event.item);
        // allItems.remove(event.item);
      } else {
        // Play incorrect sound
        _audioPlayer.play(AssetSource('audio/sfx/wrong.mp3'));
      }
      print('correctItems: $correctItems');
      emit(
        state.copyWith(
          content: state.content,
          correctItems: correctItems,
          completed: correctItems.isEmpty,
        ),
      );
    });
  }
}
