import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/info_lesson_view.dart';
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
      if (isClosed) return;
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
        nameNp: entry.value.nameNp,
      );
    }).toList();
    final outlinePositions = shuffledOutlines.asMap().entries.map((entry) {
      return ItemPosition(
        id: 'outline_${entry.key}',
        itemId: entry.value.nameEn,
        x: 0.6 + (Random().nextDouble() * 0.2),
        y: 0.1 + (entry.key * 0.2) + (Random().nextDouble() * 0.1),
        isMatched: false,
        nameNp: entry.value.nameNp,
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
    await _audioPlayer.play(AssetSource('audio/sounds/match_instruction.mp3'));
    await Future.delayed(const Duration(seconds: 4));
    if (emit.isDone) return;
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
    // Find next unmatched item
    int nextIndex = state.currentHintIndex;
    while (nextIndex < _items.length &&
        state.matchedItemIds.contains(_items[nextIndex].nameEn)) {
      nextIndex++;
    }

    // All items matched - game complete!
    if (nextIndex >= _items.length) {
      emit(state.copyWith(isPlayingHint: false, currentTargetItemId: null));
      log('🎉 All items matched! Game complete!');
      return;
    }

    final currentItem = _items[nextIndex];

    // Set this item as the current target
    emit(
      state.copyWith(
        currentHintIndex: nextIndex,
        currentTargetItemId: currentItem.nameEn,
      ),
    );

    // Play background audio hint
    if (currentItem.audioBg != null) {
      emit(
        state.copyWith(
          isPlayingAudio: true,
          currentPlayingAudioId: currentItem.nameEn,
        ),
      );

      try {
        // await _bgAudioPlayer.play(AssetSource(currentItem.audioBg!));

        final audioFile = await MediaCacheManager.instance.getSingleFile(
          currentItem.audioBg ?? '',
        );
        await _bgAudioPlayer.play(DeviceFileSource(audioFile.path));
        await _bgAudioPlayer.onPlayerComplete.first;
        if (emit.isDone) return;
        emit(
          state.copyWith(isPlayingAudio: false, currentPlayingAudioId: null),
        );
        log('Hint played for: ${currentItem.nameEn}. Waiting for match.');
      } catch (e) {
        log('Error playing background audio: $e');
        if (emit.isDone) return;
        emit(
          state.copyWith(isPlayingAudio: false, currentPlayingAudioId: null),
        );
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

    // Check if it's the correct outline for this item
    final isCorrectOutline = outlinePosition.itemId == event.itemId;

    // Check if this is the current target item (the one that was hinted)
    final isCurrentTarget = event.itemId == state.currentTargetItemId;

    if (isCorrectOutline && isCurrentTarget) {
      // ✅ Correct match for the current target!
      emit(
        state.copyWith(
          showNepaliword: true,
          dragStatus: DragStatus.correctMatch,
          matchedItemIds: [...state.matchedItemIds, event.itemId],
        ),
      );

      // Play star blast
      // await _audioPlayer.play(AssetSource('audio/sfx/star_blast.mp3'));
      // await Future.delayed(const Duration(seconds: 1));

      // Find and play the item's audio
      final item = _items.firstWhere((i) => i.nameEn == event.itemId);

      try {
        // await _audioPlayer.play(AssetSource(item.audioItem));

        final audioFile = await MediaCacheManager.instance.getSingleFile(
          item.audioItem,
        );
        await _audioPlayer.play(DeviceFileSource(audioFile.path));
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
      await Future.delayed(const Duration(seconds: 2));
      if (emit.isDone) return;
      emit(
        state.copyWith(
          showNepaliword: false,
          dragStatus: DragStatus.idle,
          draggedItemId: null,
        ),
      );

      // Check if all items are matched
      if (state.matchedItemIds.length == _items.length) {
        // Game complete!
        log('🎉 All items matched! Game complete!');
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(showCat: true));
        _audioPlayer.play(AssetSource(Assets.goodFeedback));
      } else {
        // Play next hint after successful match
        await Future.delayed(const Duration(seconds: 2));
        if (emit.isDone) return;
        add(const DragToMatchEvent.playNextHint());
      }
    } else if (!isCurrentTarget) {
      // ❌ Wrong item - not the current target
      // Don't allow matching items that haven't been hinted yet
      emit(state.copyWith(dragStatus: DragStatus.wrongMatch));

      try {
        await _audioPlayer.play(AssetSource('audio/sfx/wrong.mp3'));
      } catch (e) {
        log('Error playing try again sound: $e');
      }

      log(
        '⚠️ Not the current target! Please match: ${state.currentTargetItemId}',
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (emit.isDone) return;
      emit(state.copyWith(dragStatus: DragStatus.idle, draggedItemId: null));

      // Replay the current hint to remind the kid
      if (state.currentTargetItemId != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (emit.isDone) return;
        add(const DragToMatchEvent.playNextHint());
      }
    } else {
      // ❌ Wrong outline - correct item but wrong position
      emit(state.copyWith(dragStatus: DragStatus.wrongMatch));

      try {
        await _audioPlayer.play(AssetSource('audio/sfx/wrong.mp3'));
      } catch (e) {
        log('Error playing try again sound: $e');
      }

      await Future.delayed(const Duration(milliseconds: 500));
      if (emit.isDone) return;
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
        if (emit.isDone) return;
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
    if (_items.isNotEmpty && !isClosed) {
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
