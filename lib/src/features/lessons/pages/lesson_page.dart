import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/services/audio_record_service.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';
import 'package:onepali/src/features/lessons/templates/choose_correct/choose_correct_lesson_content_bloc/choose_correct_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/templates/info/info_lesson_content_bloc/info_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/templates/listen_and_repeat/listen_and_repeat_bloc/listen_and_repeat_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_pop/tap_to_pop_bloc/tap_to_pop_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_reveal/tap_to_reveal_lesson_content_bloc/tap_to_reveal_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/templates/slide_up_to_match/ball_match_view.dart';
import 'package:onepali/src/features/lessons/templates/balloon_fill/balloon_fill_view.dart';
import 'package:onepali/src/features/lessons/templates/choose_correct/choose_correct_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/drag_to_match/drag_to_match_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/ball_slide/ball_slide_view.dart';
import 'package:onepali/src/features/lessons/templates/flip_card/flip_card_view.dart';
import 'package:onepali/src/features/lessons/templates/gun_fill/gun_fill_view.dart';
import 'package:onepali/src/features/lessons/templates/holi_animate/holi_animate_view.dart';
import 'package:onepali/src/features/lessons/templates/info/info_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/intro/intro_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/lesson_recommendation/lesson_recommendation_view.dart';
import 'package:onepali/src/features/lessons/templates/listen_and_repeat/listen_and_repeat_view.dart';
import 'package:onepali/src/features/lessons/templates/char_tracing/new_letter_tracing_page.dart';
import 'package:onepali/src/features/lessons/templates/option_selection/option_selection_view.dart';
import 'package:onepali/src/features/lessons/templates/put_in_bag/put_in_bag_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_the_button/tap_the_button_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_change/tap_to_change_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_fill/tap_to_fill_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_pop/tap_to_pop_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_reveal/tap_to_reveal_lesson_view.dart';
import 'package:onepali/src/features/lessons/widgets/unknown_lesson_type.dart';
import 'package:onepali/src/features/tea_maker/pages/kitchen_page.dart';
import 'package:onepali/src/src.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.lessonId});
  final String lessonId;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LessonBloc()..add(LessonEvent.started(widget.lessonId)),
      child: Scaffold(
        body: BlocListener<LessonBloc, LessonState>(
          listenWhen: (previous, current) =>
              previous.lessonDetails == null && current.lessonDetails != null,
          listener: (context, state) {
            MediaCacheManager().cacheLessonMedia(
              state.lessonDetails!.contents,
              context,
            );
          },
          child: BlocListener<LessonBloc, LessonState>(
            listenWhen: (previous, current) =>
                !previous.hasCompletedLesson && current.hasCompletedLesson,
            listener: (context, state) {
              log('Tracking lesson completion');
              if (state.lessonDetails?.contents != null &&
                  state.lessonDetails!.contents.length > 2) {
                // Because the tea making lesson has only 2 content, we track the lesson completion only if the lesson has more than 2 contents.
                // For tea making like lesson we track if the activity is completed.
                MetricsTrackingHelper.trackLessonCompletion(
                  context: context,
                  lessonId: widget.lessonId,
                  topicName: state.lessonDetails?.lesson.name ?? '',
                );
              }
            },
            child: BlocBuilder<LessonBloc, LessonState>(
              builder: (context, state) {
                if (state.lessonDetails == null) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state.currentContent == null) {
                  return Center(child: Text('No content found'));
                }
                final lessonContent = state.currentContent!;
                final isLastContent =
                    state.currentIndex ==
                    state.lessonDetails!.contents.length - 1;
                final isFirstContent = state.currentIndex == 0;
                return switch (lessonContent) {
                  IntroLessonContent() => IntroLessonView(
                    key: ValueKey('intro_${state.currentIndex}'),
                    content: lessonContent,
                    isLast: isLastContent,
                    isFirst: isFirstContent,
                  ),
                  InfoLessonContent() => BlocProvider(
                    key: ValueKey('info_${state.currentIndex}'),
                    create: (context) => InfoLessonContentBloc(),
                    child: InfoLessonView(content: lessonContent),
                  ),
                  ChooseCorrectLessonContent() => BlocProvider(
                    create: (context) => ChooseCorrectLessonContentBloc(),
                    child: ChooseCorrectLessonView(
                      content: lessonContent,
                      isLastContent: isLastContent,
                    ),
                  ),
                  TapToRevealLessonContent() => BlocProvider(
                    key: ValueKey('tap_to_reveal_${state.currentIndex}'),
                    create: (context) => TapToRevealLessonContentBloc(),
                    child: TapToRevealLessonView(content: lessonContent),
                  ),
                  DragToMatchLessonContent() => DragToMatchScreen(
                    lessonContent: lessonContent,
                  ),
                  TapToPopLessonContent() => BlocProvider(
                    create: (context) =>
                        TapToPopBloc()
                          ..add(TapToPopEvent.started(lessonContent)),
                    child: TapToPopLessonView(content: lessonContent),
                  ),
                  ListenAndRepeatLessonContent() => BlocProvider(
                    create: (context) => ListenAndRepeatBloc(
                      audioPlayerService: AudioPlayerServiceImpl(),
                      audioRecorderService: AudioRecorderServiceImpl(),
                    ),
                    child: ListenAndRepeatView(content: lessonContent),
                  ),
                  CharTracingLessonContent() => NewLetterTracingPage(
                    content: lessonContent,
                  ),
                  TeaMakingLessonContent() => KitchenPage(
                    content: lessonContent,
                  ),
                  BallSlideLessonContent() => BallSlideView(
                    key: ValueKey('ball_slide_${state.currentIndex}'),
                    content: lessonContent,
                  ),
                  FlipCardLessonContent() => FlipCardView(
                    key: ValueKey('flip_card_${state.currentIndex}'),
                    content: lessonContent,
                  ),
                  SlideUpToMatchLessonContent() => MatchGameScreen(
                    key: ValueKey('slide_up_to_match_${state.currentIndex}'),
                    content: lessonContent,
                    isLastContent: isLastContent,
                  ),
                  BalloonFillLessonContent() => BalloonFillView(
                    content: lessonContent,
                  ),
                  GunFillLessonContent() => GunFillLessonView(
                    content: lessonContent,
                  ),
                  HoliAnimateLessonContent() => HoliAnimateView(
                    content: lessonContent,
                  ),
                  TapToChangeLessonContent() => TapToChangeView(
                    content: lessonContent,
                  ),
                  TapToFillLessonContent() => TapToFillView(
                    key: ValueKey('tap_to_fill_${state.currentIndex}'),
                    content: lessonContent,
                  ),
                  OptionSelectionLessonContent() => OptionSelectionView(
                    content: lessonContent,
                  ),
                  PutInBagLessonContent() => PutInBagView(
                    key: ValueKey('put_in_bag_${state.currentIndex}'),
                    content: lessonContent,
                  ),
                  TapTheButtonLessonContent() => TapTheButtonView(
                    key: ValueKey('tap_the_button_${state.currentIndex}'),
                    content: lessonContent,
                  ),
                  LessonRecommendationLessonContent() =>
                    LessonRecommendationView(content: lessonContent),
                  _ => UnknownLessonType(
                    isFirst: isFirstContent,
                    isLast: isLastContent,
                  ),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}
