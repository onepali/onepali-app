import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'put_in_bag_event.dart';
part 'put_in_bag_state.dart';
part 'put_in_bag_bloc.freezed.dart';

class PutInBagBloc extends Bloc<PutInBagEvent, PutInBagState> {
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;
  PutInBagBloc() : super(PutInBagState()) {
    on<PutInBagEvent>((event, emit) async {
      event.when(
        started: (content) async {
          emit(
            state.copyWith(
              content: content,
              currentBagItemImage: content.bagImage,
              droppedItemIndexes: [],
              currentPlayingItemIndex: null,
              status: PutInBagStatus.initial,
            ),
          );
          if (content.instructionAudio != null &&
              content.instructionAudio!.isNotEmpty) {
            emit(state.copyWith(status: PutInBagStatus.audioPlaying));
            await _audioPlayerService.play(content.instructionAudio!);
            _audioSub?.cancel();
            _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
              add(const PutInBagEvent.audioCompleted(false));
            });
          } else {
            emit(state.copyWith(status: PutInBagStatus.idle));
          }
        },
        itemDropped: (itemIndex) async {
          if (state.content == null) return;
          final content = state.content;
          final isCompleted =
              !content!.onlyOneChoice && state.status == PutInBagStatus.completed;
          if (itemIndex < 0 ||
              itemIndex >= content.items.length ||
              state.droppedItemIndexes.contains(itemIndex) ||
              isCompleted ||
              state.isAudioPlaying) {
            return;
          }

          final item = content.items[itemIndex];
          final updatedDropped = List<int>.from(state.droppedItemIndexes)
            ..add(itemIndex);
          // If Only one choice is allowed, remove the other items from the dropped list
          if (content.onlyOneChoice) {
            updatedDropped.removeWhere((index) => index != itemIndex);
          }

          emit(
            state.copyWith(
              droppedItemIndexes: updatedDropped,
              currentBagItemImage: item.imageOutline ?? content.bagImage,
              status: PutInBagStatus.audioPlaying,
              currentPlayingItemIndex: itemIndex,
            ),
          );

          if (item.audioItem != null && item.audioItem!.isNotEmpty) {
            await _audioPlayerService.play(item.audioItem!);
            _audioSub?.cancel();
            _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
              add(const PutInBagEvent.audioCompleted(false));
            });
          } else {
            // onlyOneChoice: complete when any one item is dropped
            if (content.onlyOneChoice) {
              emit(
                state.copyWith(
                  status: PutInBagStatus.completed,
                  currentPlayingItemIndex: null,
                ),
              );
            } else {
              final isCompleted = updatedDropped.length == content.items.length;
              if (isCompleted) {
                emit(
                  state.copyWith(
                    status: PutInBagStatus.completed,
                    currentPlayingItemIndex: null,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    status: PutInBagStatus.idle,
                    currentPlayingItemIndex: null,
                  ),
                );
              }
            }
          }
        },
        audioCompleted: (isCompleted) {
          _audioSub?.cancel();
          _audioSub = null;
          if (state.content == null) return;
          final droppedItemCount = state.droppedItemIndexes.length;
          if (state.content!.onlyOneChoice && droppedItemCount > 0) {
            emit(
              state.copyWith(
                status: PutInBagStatus.completed,
                currentPlayingItemIndex: null,
              ),
            );
          } else {
            final isCompleted =
                state.droppedItemIndexes.length == state.content!.items.length;
            if (isCompleted) {
              emit(
                state.copyWith(
                  status: PutInBagStatus.completed,
                  currentPlayingItemIndex: null,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  status: PutInBagStatus.idle,
                  currentPlayingItemIndex: null,
                ),
              );
            }
          }
        },
      );
    });
  }

  @override
  Future<void> close() async {
    await _audioSub?.cancel();
    _audioPlayerService.dispose();
    super.close();
  }
}
