
part of 'drag_to_match_bloc.dart';

@freezed
class DragToMatchEvent with _$DragToMatchEvent {
  const factory DragToMatchEvent.initialize({
    required List<Item> items,
  }) = _Initialize;

  const factory DragToMatchEvent.startHintSequence() = _StartHintSequence;

  const factory DragToMatchEvent.playNextHint() = _PlayNextHint;

  const factory DragToMatchEvent.startDrag({
    required String itemId,
  }) = _StartDrag;

  const factory DragToMatchEvent.updateDragPosition({
    required String itemId,
    required double x,
    required double y,
  }) = _UpdateDragPosition;

  const factory DragToMatchEvent.endDrag({
    required String itemId,
    String? targetOutlineId,
  }) = _EndDrag;

  const factory DragToMatchEvent.playItemAudio({
    required String itemId,
  }) = _PlayItemAudio;

  const factory DragToMatchEvent.audioPlaybackComplete() = _AudioPlaybackComplete;

  const factory DragToMatchEvent.resetGame() = _ResetGame;
}