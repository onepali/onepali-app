part of 'match_bloc.dart';

@freezed
abstract class MatchEvent with _$MatchEvent {
  const factory MatchEvent.started(SlideUpToMatchLessonContent content) =
      _Started;
  const factory MatchEvent.onAccept(String nepaliWord) = _OnAccept;
}
