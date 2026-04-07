part of 'gun_fill_bloc.dart';


enum GunFillStatus {
  initial,
  instructionPlaying,
  ideal,
  audioPlaying,
}
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
    required String id,
    required String path,
    String? color,
    @Default(false) bool isFilled,
    Item? item,
  }) = _GunPart;
}

@freezed
abstract class GunLabel with _$GunLabel {
  const factory GunLabel({
    required String path,
    String? color,
  }) = _GunLabel;
}
