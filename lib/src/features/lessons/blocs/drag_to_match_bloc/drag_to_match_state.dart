part of 'drag_to_match_bloc.dart';

@freezed
abstract class DragToMatchState with _$DragToMatchState {
  const factory DragToMatchState({
    @Default([]) List<ItemPosition> itemPositions,
    @Default([]) List<ItemPosition> outlinePositions,
    @Default([]) List<String> matchedItemIds,
    @Default(0) int currentHintIndex,
    @Default(false) bool isPlayingHint,
    @Default(false) bool isPlayingAudio,
    @Default(false) bool showNepaliword,
    String? currentPlayingAudioId,
    @Default(DragStatus.idle) DragStatus dragStatus,
    String? draggedItemId,
    String? targetOutlineId,
    String? currentTargetItemId,
  }) = _DragToMatchState;
}

@freezed
abstract class ItemPosition with _$ItemPosition {
  const factory ItemPosition({
    required String id,
    required String itemId,
    required String nameNp,
    required double x,
    required double y,
    required bool isMatched,
  }) = _ItemPosition;
}

enum DragStatus { idle, dragging, correctMatch, wrongMatch }
