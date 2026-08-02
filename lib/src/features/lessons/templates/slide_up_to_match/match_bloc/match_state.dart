part of 'match_bloc.dart';

@freezed
abstract class MatchState with _$MatchState {
  const factory MatchState({
    SlideUpToMatchLessonContent? content,
    @Default([]) List<NepaliWord> nepaliWords,
    @Default(false) bool isAnsweredAll,
    @Default(false) bool completionFeedbackReady,
  }) = _MatchState;
}

@freezed
abstract class NepaliWord with _$NepaliWord {
  const factory NepaliWord({
    required String word,
    @Default(false) bool isMatched,
  }) = _NepaliWord;
  factory NepaliWord.fromJson(Map<String, dynamic> json) =>
      _$NepaliWordFromJson(json);
}
