import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

    final shuffledItems = List<Item>.from(_items)..shuffle();
    final shuffledOutlines = List<Item>.from(_items)..shuffle();

    final itemPositions = shuffledItems.asMap().entries.map((entry) {
      return ItemPosition(
        id: 'item_${entry.key}',
        itemId: entry.value.nameEn,
        x: 0.1 + (Random().nextDouble() * 0.2),
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
    var nextIndex = state.currentHintIndex;
    while (nextIndex < _items.length &&
        state.matchedItemIds.contains(_items[nextIndex].nameEn)) {
      nextIndex++;
    }

    if (nextIndex >= _items.length) {
      emit(state.copyWith(isPlayingHint: false, currentTargetItemId: null));
      log('All items matched');
      return;
    }

    final currentItem = _items[nextIndex];
    emit(
      state.copyWith(
        currentHintIndex: nextIndex,
        currentTargetItemId: currentItem.nameEn,
      ),
    );

    final audioBg = currentItem.audioBg;
    if (audioBg != null && audioBg.isNotEmpty) {
      emit(
        state.copyWith(
          isPlayingAudio: true,
          currentPlayingAudioId: currentItem.nameEn,
        ),
      );

      try {
        final audioFile = await MediaCacheManager.instance.getSingleFile(
          audioBg,
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
    final targetOutlineId = event.targetOutlineId;
    if (targetOutlineId == null) {
      emit(state.copyWith(dragStatus: DragStatus.idle, draggedItemId: null));
      return;
    }

    final outlinePosition = state.outlinePositions.firstWhere(
      (pos) => pos.id == targetOutlineId,
    );

    final isCorrectOutline = outlinePosition.itemId == event.itemId;
    final isCurrentTarget = event.itemId == state.currentTargetItemId;

    if (isCorrectOutline && isCurrentTarget) {
      emit(
        state.copyWith(
          showNepaliword: true,
          dragStatus: DragStatus.correctMatch,
          matchedItemIds: [...state.matchedItemIds, event.itemId],
        ),
      );

      final item = _items.firstWhere((i) => i.nameEn == event.itemId);
      try {
        final audioFile = await MediaCacheManager.instance.getSingleFile(
          item.audioItem,
        );
        await _audioPlayer.play(DeviceFileSource(audioFile.path));
      } catch (e) {
        log('Error playing item audio: $e');
      }

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

      await Future.delayed(const Duration(seconds: 2));
      if (emit.isDone) return;
      emit(
        state.copyWith(
          showNepaliword: false,
          dragStatus: DragStatus.idle,
          draggedItemId: null,
        ),
      );

      if (state.matchedItemIds.length == _items.length) {
        log('All items matched');
      } else {
        await Future.delayed(const Duration(seconds: 2));
        if (emit.isDone) return;
        add(const DragToMatchEvent.playNextHint());
      }
    } else if (!isCurrentTarget) {
      emit(state.copyWith(dragStatus: DragStatus.wrongMatch));

      try {
        await _audioPlayer.play(AssetSource('audio/sfx/wrong.mp3'));
      } catch (e) {
        log('Error playing wrong match sound: $e');
      }

      log('Not the current target. Expected: ${state.currentTargetItemId}');

      await Future.delayed(const Duration(milliseconds: 500));
      if (emit.isDone) return;
      emit(state.copyWith(dragStatus: DragStatus.idle, draggedItemId: null));

      if (state.currentTargetItemId != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (emit.isDone) return;
        add(const DragToMatchEvent.playNextHint());
      }
    } else {
      emit(state.copyWith(dragStatus: DragStatus.wrongMatch));

      try {
        await _audioPlayer.play(AssetSource('audio/sfx/wrong.mp3'));
      } catch (e) {
        log('Error playing wrong match sound: $e');
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
    final audioBg = item.audioBg;

    if (audioBg != null && audioBg.isNotEmpty) {
      emit(
        state.copyWith(
          isPlayingAudio: true,
          currentPlayingAudioId: event.itemId,
        ),
      );

      try {
        final audioFile = await MediaCacheManager.instance.getSingleFile(
          audioBg,
        );
        await _audioPlayer.play(DeviceFileSource(audioFile.path));
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
  Future<void> close() async {
    _hintTimer?.cancel();
    await _audioPlayer.dispose();
    await _bgAudioPlayer.dispose();
    return super.close();
  }
}
