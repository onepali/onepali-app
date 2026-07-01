part of 'tap_to_pop_bloc.dart';

@freezed
abstract class TapToPopEvent with _$TapToPopEvent {
  const factory TapToPopEvent.started(TapToPopLessonContent content) = _Started;
  const factory TapToPopEvent.instructionAudioCompleted() =
      _InstructionAudioCompleted;
  const factory TapToPopEvent.tapItem(Item item) = _TapItem;
}
