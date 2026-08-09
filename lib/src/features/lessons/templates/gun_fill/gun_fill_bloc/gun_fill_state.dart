part of 'gun_fill_bloc.dart';

enum GunFillStatus { initial, instructionPlaying, ideal, audioPlaying, failed }

@freezed
abstract class GunFillState with _$GunFillState {
  const factory GunFillState({
    @Default(GunFillStatus.initial) GunFillStatus status,
    GunFillLessonContent? content,
    @Default([]) List<GunPart> gunParts,
    @Default([]) List<GunLabel> labelPaths,
    @Default(false) bool isCompleted,
  }) = _GunFillState;
}

@freezed
abstract class GunPart with _$GunPart {
  const factory GunPart({
    /// Id of the part, also used as the color code, for example #ff0000.
    required String id,

    /// Path of the part in svg image
    required String path,

    /// Fill color of the part in svg image.
    String? color,

    /// Tracks whether the part has been filled.
    @Default(false) bool isFilled,
    Item? item,
  }) = _GunPart;
}

@freezed
abstract class GunLabel with _$GunLabel {
  const factory GunLabel({
    /// Path of the label in svg image
    required String path,

    /// Fill color of the label in svg image.
    String? color,

    /// Gun part id/color code that this label accepts when dropped on.
    String? gunPartId,
  }) = _GunLabel;
}
