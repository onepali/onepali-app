part of 'put_in_bag_bloc.dart';

enum PutInBagStatus { initial, audioPlaying, idle, completed }

@freezed
abstract class PutInBagState with _$PutInBagState {
  const factory PutInBagState({
    @Default(PutInBagStatus.initial) PutInBagStatus status,
    PutInBagLessonContent? content,
    @Default([]) List<int> droppedItemIndexes,
    String? currentBagItemImage,
    int? currentPlayingItemIndex,
    @Default(false) bool showActionButton,
  }) = _PutInBagState;

  const PutInBagState._();

  bool get isAudioPlaying => status == PutInBagStatus.audioPlaying;
  bool get isIdle => status == PutInBagStatus.idle;
  bool get isCompleted => status == PutInBagStatus.completed;
  bool get showActionButton {
    if (content == null) return true;
    if (content!.onlyOneChoice) {
      return droppedItemIndexes.isNotEmpty;
    } else {
      return status == PutInBagStatus.completed;
    }
  }
}
