part of 'put_in_bag_bloc.dart';

@freezed
abstract class PutInBagEvent with _$PutInBagEvent {
  const factory PutInBagEvent.started(PutInBagLessonContent content) = _Started;
  const factory PutInBagEvent.itemDropped(int itemIndex) = _ItemDropped;
  const factory PutInBagEvent.audioCompleted(bool isCompleted) = _AudioCompleted;
}