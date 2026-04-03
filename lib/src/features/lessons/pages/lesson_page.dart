import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/services/audio_record_service.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';
import 'package:onepali/src/features/lessons/blocs/choose_correct_lesson_content_bloc/choose_correct_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/info_lesson_content_bloc/info_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/listen_and_repeat_bloc/listen_and_repeat_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/tap_to_pop_bloc/tap_to_pop_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/tap_to_reveal_lesson_content_bloc/tap_to_reveal_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/ball_match_view.dart';
import 'package:onepali/src/features/lessons/views/ball_slide_view.dart';
import 'package:onepali/src/features/lessons/views/balloon_fill_view.dart';
import 'package:onepali/src/features/lessons/views/choose_correct_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/drag_to_match_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/flip_card_view.dart';
import 'package:onepali/src/features/lessons/views/info_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/intro_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/listen_and_repeat_view.dart';
import 'package:onepali/src/features/lessons/views/new_letter_tracing_page.dart';
import 'package:onepali/src/features/lessons/views/tap_to_pop_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/tap_to_reveal_lesson_view.dart';
import 'package:onepali/src/features/tea_maker/pages/kitchen_page.dart';

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
        body: BlocConsumer<LessonBloc, LessonState>(
          listenWhen: (previous, current) =>
              current.status == LessonStatus.success &&
              previous.lessonDetails != current.lessonDetails,
          listener: (context, state) {
            if (state.lessonDetails != null) {
              MediaCacheManager().cacheLessonMedia(
                state.lessonDetails!.contents,
                context,
              );
            }
          },
          builder: (context, state) {
            if (state.lessonDetails == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (state.currentContent == null) {
              return Center(child: Text('No content found'));
            }
            final lessonContent = state.currentContent!;
            final contents = state.lessonDetails!.contents;
            final isLastContent = state.currentIndex >= contents.length - 1;
            final isFirstContent = state.currentIndex == 0;

            void handleNext() {
              if (isLastContent) {
                Navigator.of(context).pop();
              } else {
                context.read<LessonBloc>().add(const LessonEvent.nextContent());
              }
            }

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
                create: (context) => TapToRevealLessonContentBloc(),
                child: TapToRevealLessonView(content: lessonContent),
              ),
              DragToMatchLessonContent() => DragToMatchScreen(
                lessonContent: lessonContent,
              ),
              TapToPopLessonContent() => BlocProvider(
                create: (context) =>
                    TapToPopBloc()..add(TapToPopEvent.started(lessonContent)),
                child: TapToPopLessonView(content: lessonContent),
              ),
              ListenAndRepeatLessonContent() => BlocProvider(
                create: (context) => ListenAndRepeatBloc(
                  audioPlayerService: AudioPlayerServiceImpl(),
                  audioRecorderService: AudioRecorderServiceImpl(),
                ),
                child: ListenAndRepeatView(
                  content: lessonContent,
                  onCompleted: handleNext,
                ),
              ),
              CharTracingLessonContent() => NewLetterTracingPage(
                content: lessonContent,
              ),
              TeaMakingLessonContent() => const KitchenPage(),
              BallSlideLessonContent() => BallSlideView(
                key: ValueKey('ball_slide_${state.currentIndex}'),
                content: lessonContent,
                onNext: handleNext,
              ),
              FlipCardLessonContent() => FlipCardView(
                key: ValueKey('flip_card_${state.currentIndex}'),
                content: lessonContent,
                onNext: handleNext,
              ),
              SlideUpToMatchLessonContent() => MatchGameScreen(
                key: ValueKey('slide_up_to_match_${state.currentIndex}'),
                content: lessonContent,
                isLastContent: isLastContent,
                onNext: handleNext,
              ),
              BalloonFillLessonContent() => BalloonFillView(
                content: lessonContent,
              ),
              _ => Center(child: Text('Unknown content type')),
            };
          },
        ),
      ),
    );
  }
}
