import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/choose_correct_lesson_view.dart';
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
          LessonBloc()..add(LessonEvent.started('bhiS1LNNJEXUoOEOIirT')),
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
                return InfoLessonView(lessonInformation: lessonContent);
              case ChooseCorrectLessonContent():
                return ChooseCorrectLessonView(
                  lessonInformation: lessonContent,
                );
              case TapToRevealLessonContent():
                return TapToRevealLessonView(
                  lessonBloc: context.read<LessonBloc>(),
                );
              default:
                return Center(child: Text('Unknown content type'));
            }
          },
        ),
      ),
    );
  }
}
