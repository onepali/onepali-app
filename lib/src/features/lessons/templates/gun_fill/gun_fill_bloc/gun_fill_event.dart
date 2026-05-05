part of 'gun_fill_bloc.dart';

@freezed
abstract class GunFillEvent with _$GunFillEvent {
  const factory GunFillEvent.started(
    GunFillLessonContent content,
    bool isMobile,
  ) = _Started;
  const factory GunFillEvent.instructionComplete() = _InstructionComplete;
  const factory GunFillEvent.colorFilled(String partId) = _ColorFilled;
  const factory GunFillEvent.starBlustCompleted(GunPart part) =
      _StarBlustCompleted;
  const factory GunFillEvent.audioComplete() = _AudioComplete;
}
