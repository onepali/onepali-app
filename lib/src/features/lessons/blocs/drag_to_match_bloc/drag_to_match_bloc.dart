import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
part 'drag_to_match_state.dart';
part 'drag_to_match_event.dart';
part 'drag_to_match_bloc.freezed.dart';

class DragToMatchBloc extends Bloc<DragToMatchEvent, DragToMatchState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _bgAudioPlayer = AudioPlayer();
  List<Item> _items = [];
  Timer? _hintTimer;

  DragToMatchBloc() : super(const DragToMatchState()) {
    on<_Initialize>(_onInitialize);
    on<_StartHintSequence>(_onStartHintSequence);
    on<_PlayNextHint>(_onPlayNextHint);
    on<_StartDrag>(_onStartDrag);
    on<_UpdateDragPosition>(_onUpdateDragPosition);
    on<_EndDrag>(_onEndDrag);
    on<_PlayItemAudio>(_onPlayItemAudio);
    on<_AudioPlaybackComplete>(_onAudioPlaybackComplete);
    on<_ResetGame>(_onResetGame);

    // Listen to audio player completion
    _audioPlayer.onPlayerComplete.listen((_) {
      add(const DragToMatchEvent.audioPlaybackComplete());
    });
  }

  Future<void> _onInitialize(
    _Initialize event,
    Emitter<DragToMatchState> emit,
  ) async {
    _items = event.items;

    // Shuffle items for random placement
    final shuffledItems = List<Item>.from(_items)..shuffle();
    final shuffledOutlines = List<Item>.from(_items)..shuffle();

    // Generate random positions for items (left side)
    final itemPositions = shuffledItems.asMap().entries.map((entry) {
      return ItemPosition(
        id: 'item_${entry.key}',
        itemId: entry.value.nameEn, // Using nameEn as unique identifier
        x: 0.1 + (Random().nextDouble() * 0.2), // 10-30% from left
        y: 0.1 + (entry.key * 0.2) + (Random().nextDouble() * 0.1),
        isMatched: false,
      );
    }).toList();

    // Generate random positions for outlines (right side)
    final outlinePositions = shuffledOutlines.asMap().entries.map((entry) {
      return ItemPosition(
        id: 'outline_${entry.key}',
        itemId: entry.value.nameEn,
        x: 0.6 + (Random().nextDouble() * 0.2), // 60-80% from left
        y: 0.1 + (entry.key * 0.2) + (Random().nextDouble() * 0.1),
        isMatched: false,
      );
    }).toList();

    emit(
      state.copyWith(
        itemPositions: itemPositions,
        outlinePositions: outlinePositions,
        matchedItemIds: [],
        currentHintIndex: 0,
      ),
    );

    // Start hint sequence automatically
    add(const DragToMatchEvent.startHintSequence());
  }

  Future<void> _onStartHintSequence(
    _StartHintSequence event,
    Emitter<DragToMatchState> emit,
  ) async {
    if (_items.isEmpty) return;

    emit(state.copyWith(isPlayingHint: true, currentHintIndex: 0));
    add(const DragToMatchEvent.playNextHint());
  }

  Future<void> _onPlayNextHint(
    _PlayNextHint event,
    Emitter<DragToMatchState> emit,
  ) async {
    if (state.currentHintIndex >= _items.length) {
      // All hints played, reset to beginning
      emit(state.copyWith(isPlayingHint: false, currentHintIndex: 0));

      // Wait a bit and restart hints
      _hintTimer = Timer(const Duration(seconds: 3), () {
        add(const DragToMatchEvent.startHintSequence());
      });
      return;
    }

    final currentItem = _items[state.currentHintIndex];

    // Skip if already matched
    if (state.matchedItemIds.contains(currentItem.nameEn)) {
      emit(state.copyWith(currentHintIndex: state.currentHintIndex + 1));
      add(const DragToMatchEvent.playNextHint());
      return;
    }

    // Play background audio hint
    if (currentItem.audioBg != null) {
      emit(
        state.copyWith(
          isPlayingAudio: true,
          currentPlayingAudioId: currentItem.nameEn,
        ),
      );

      try {
        await _bgAudioPlayer.play(AssetSource(currentItem.audioBg!));

        // Wait for audio to complete then play next hint
        _bgAudioPlayer.onPlayerComplete.first.then((_) {
          emit(
            state.copyWith(
              isPlayingAudio: false,
              currentPlayingAudioId: null,
              currentHintIndex: state.currentHintIndex + 1,
            ),
          );

          // Small delay before next hint
          Future.delayed(const Duration(milliseconds: 800), () {
            add(const DragToMatchEvent.playNextHint());
          });
        });
      } catch (e) {
        log('Error playing background audio: $e');
        emit(
          state.copyWith(
            isPlayingAudio: false,
            currentPlayingAudioId: null,
            currentHintIndex: state.currentHintIndex + 1,
          ),
        );
        add(const DragToMatchEvent.playNextHint());
      }
    }
  }

  void _onStartDrag(_StartDrag event, Emitter<DragToMatchState> emit) {
    // Cancel hint sequence when user starts dragging
    _hintTimer?.cancel();
    emit(
      state.copyWith(
        dragStatus: DragStatus.dragging,
        draggedItemId: event.itemId,
        isPlayingHint: false,
      ),
    );
  }

  void _onUpdateDragPosition(
    _UpdateDragPosition event,
    Emitter<DragToMatchState> emit,
  ) {
    final updatedPositions = state.itemPositions.map((pos) {
      if (pos.itemId == event.itemId) {
        return pos.copyWith(x: event.x, y: event.y);
      }
      return pos;
    }).toList();

    emit(state.copyWith(itemPositions: updatedPositions));
  }

  Future<void> _onEndDrag(
    _EndDrag event,
    Emitter<DragToMatchState> emit,
  ) async {
    if (event.targetOutlineId == null) {
      // No target, return to original position or reset
      emit(state.copyWith(dragStatus: DragStatus.idle, draggedItemId: null));
      return;
    }

    // Find the outline position
    final outlinePosition = state.outlinePositions.firstWhere(
      (pos) => pos.id == event.targetOutlineId,
    );

    // Check if it's a correct match
    final isCorrectMatch = outlinePosition.itemId == event.itemId;

    if (isCorrectMatch) {
      // Correct match!
      emit(
        state.copyWith(
          dragStatus: DragStatus.correctMatch,
          matchedItemIds: [...state.matchedItemIds, event.itemId],
        ),
      );

      // Find and play the item's audio
      final item = _items.firstWhere((i) => i.nameEn == event.itemId);

      try {
        await _audioPlayer.play(AssetSource(item.audioItem));
      } catch (e) {
        log('Error playing item audio: $e');
      }

      // Update positions to show matched state
      final updatedItemPositions = state.itemPositions.map((pos) {
        if (pos.itemId == event.itemId) {
          return pos.copyWith(isMatched: true);
        }
        return pos;
      }).toList();

      final updatedOutlinePositions = state.outlinePositions.map((pos) {
        if (pos.itemId == event.itemId) {
          return pos.copyWith(isMatched: true);
        }
        return pos;
      }).toList();

      emit(
        state.copyWith(
          itemPositions: updatedItemPositions,
          outlinePositions: updatedOutlinePositions,
        ),
      );

      // Reset drag status after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(dragStatus: DragStatus.idle, draggedItemId: null));

      // Check if all items are matched
      if (state.matchedItemIds.length == _items.length) {
        // Game complete!
        log('All items matched! Game complete!');
      }
    } else {
      // Wrong match - play try again sound
      emit(state.copyWith(dragStatus: DragStatus.wrongMatch));

      try {
        await _audioPlayer.play(AssetSource('sounds/try_again.mp3'));
      } catch (e) {
        log('Error playing try again sound: $e');
      }

      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(dragStatus: DragStatus.idle, draggedItemId: null));
    }
  }

  Future<void> _onPlayItemAudio(
    _PlayItemAudio event,
    Emitter<DragToMatchState> emit,
  ) async {
    final item = _items.firstWhere((i) => i.nameEn == event.itemId);

    if (item.audioBg != null) {
      emit(
        state.copyWith(
          isPlayingAudio: true,
          currentPlayingAudioId: event.itemId,
        ),
      );

      try {
        await _audioPlayer.play(AssetSource(item.audioBg!));
      } catch (e) {
        log('Error playing audio: $e');
        emit(
          state.copyWith(isPlayingAudio: false, currentPlayingAudioId: null),
        );
      }
    }
  }

  void _onAudioPlaybackComplete(
    _AudioPlaybackComplete event,
    Emitter<DragToMatchState> emit,
  ) {
    emit(state.copyWith(isPlayingAudio: false, currentPlayingAudioId: null));
  }

  void _onResetGame(_ResetGame event, Emitter<DragToMatchState> emit) {
    _hintTimer?.cancel();
    emit(const DragToMatchState());
    if (_items.isNotEmpty) {
      add(DragToMatchEvent.initialize(items: _items));
    }
  }

  @override
  Future<void> close() {
    _hintTimer?.cancel();
    _audioPlayer.dispose();
    _bgAudioPlayer.dispose();
    return super.close();
  }
}
