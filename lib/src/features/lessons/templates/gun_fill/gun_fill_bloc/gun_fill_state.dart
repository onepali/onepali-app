part of 'gun_fill_bloc.dart';

enum GunFillStatus { initial, instructionPlaying, ideal, audioPlaying }

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
    /// This is the id of the part. It is also used as the color code eg: #ff0000
    required String id,

    /// Path of the part in svg image
    required String path,

    /// This is the fill color of the part in svg image.
    String? color,

    /// To track the part is filled or not with color
    @Default(false) bool isFilled,
    Item? item,
  }) = _GunPart;
}

@freezed
abstract class GunLabel with _$GunLabel {
  const factory GunLabel({
    /// Path of the label in svg image
    required String path,

    /// Color of the label. Make sure to replace the color name with color code in the path
    String? color,

    /// This is the gun part color code like #ff0000 used to drage and drop the color over the lable so that the gun part is filled.
    String? gunPartId,
  }) = _GunLabel;
}
