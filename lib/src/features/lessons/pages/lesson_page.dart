import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/services/audio_record_service.dart';
import 'package:onepali/src/features/lessons/blocs/choose_correct_lesson_content_bloc/choose_correct_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/info_lesson_content_bloc/info_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/listen_and_repeat_bloc/listen_and_repeat_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/tap_to_pop_bloc/tap_to_pop_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/tap_to_reveal_lesson_content_bloc/tap_to_reveal_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/choose_correct_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/drag_to_match_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/info_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/intro_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/listen_and_repeat_view.dart';
import 'package:onepali/src/features/lessons/views/new_letter_tracing_page.dart';
import 'package:onepali/src/features/lessons/views/tap_to_pop_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/tap_to_reveal_lesson_view.dart';

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
        body: BlocBuilder<LessonBloc, LessonState>(
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

            switch (lessonContent) {
              case IntroLessonContent():
                return IntroLessonView(content: lessonContent);
              // return LetterSelectionScreen();
              case InfoLessonContent():
                return BlocProvider(
                  key: ValueKey('info_${state.currentIndex}'),
                  create: (context) => InfoLessonContentBloc(),
                  child: InfoLessonView(content: lessonContent),
                );
              case ChooseCorrectLessonContent():
                return BlocProvider(
                  create: (context) => ChooseCorrectLessonContentBloc(),
                  child: ChooseCorrectLessonView(content: lessonContent),
                );
              case TapToRevealLessonContent():
                return BlocProvider(
                  create: (context) => TapToRevealLessonContentBloc(),
                  child: TapToRevealLessonView(content: lessonContent),
                );
              case DragToMatchLessonContent():
                return DragToMatchScreen(lessonContent: lessonContent);
              case TapToPopLessonContent():
                return BlocProvider(
                  create: (context) =>
                      TapToPopBloc()..add(TapToPopEvent.started(lessonContent)),
                  child: TapToPopLessonView(content: lessonContent),
                );
              case ListenAndRepeatLessonContent():
                return BlocProvider(
                  create: (context) => ListenAndRepeatBloc(
                    audioPlayerService: AudioPlayerServiceImpl(),
                    audioRecorderService: AudioRecorderServiceImpl(),
                  ),
                  child: ListenAndRepeatView(
                    content: lessonContent,
                    onCompleted: () {
                      if (isLastContent) {
                        Navigator.of(context).pop();
                      } else {
                        context.read<LessonBloc>().add(
                          const LessonEvent.nextContent(),
                        );
                      }
                    },
                  ),
                );
              case CharTracingLessonContent():
                return NewLetterTracingPage(content: lessonContent);
              default:
                return Center(child: Text('Unknown content type'));
            }
          },
        ),
      ),
    );
  }
}
