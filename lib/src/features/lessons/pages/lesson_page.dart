import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/choose_correct_lesson_content_bloc/choose_correct_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/drag_to_match_bloc/drag_to_match_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/info_lesson_content_bloc/info_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/tap_to_reveal_lesson_content_bloc/tap_to_reveal_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/choose_correct_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/drag_to_match_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/info_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/tap_to_reveal_lesson_view.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key});

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
          LessonBloc()..add(LessonEvent.started('F0j1Xen6IIrF8gkYP3s1')),
      child: Scaffold(
        body: BlocBuilder<LessonBloc, LessonState>(
          builder: (context, state) {
            if (state.lessonDetails == null) {
              return Center(child: CircularProgressIndicator());
            }
            final index = state.currentIndex;
            final lessonContent = state.lessonDetails!.contents[index];
            switch (lessonContent) {
              case InfoLessonContent():
                return BlocProvider(
                  create: (context) =>
                      InfoLessonContentBloc()
                        ..add(InfoLessonContentEvent.started(lessonContent)),
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
              default:
                return Center(child: Text('Unknown content type'));
            }
          },
        ),
      ),
    );
  }
}
