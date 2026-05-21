part of 'lesson_bloc.dart';

@freezed
class LessonEvent with _$LessonEvent {
  const factory LessonEvent.started(String lessonId) = _Started;
  // Info releted content events
  const factory LessonEvent.playInfo(int index) = _PlayInfo;
  const factory LessonEvent.playItemAudio() = _PlayItemAudio;

  // Choose correct related content events
  const factory LessonEvent.playChooseCorrectItem() = _PlayChooseCorrectItem;
  const factory LessonEvent.chooseItem(Item item) = _ChooseItem;

  //Common events
  const factory LessonEvent.nextContent() = _NextContent;
  const factory LessonEvent.previousContent() = _PreviousContent;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
