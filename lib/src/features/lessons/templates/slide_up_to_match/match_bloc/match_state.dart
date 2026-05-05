part of 'match_bloc.dart';

@freezed
abstract class MatchState with _$MatchState {
  const factory MatchState({
    SlideUpToMatchLessonContent? content,
    @Default([]) List<String> nepaliWords,
    @Default(false) bool isAnsweredAll,
  }) = _MatchState;
}
