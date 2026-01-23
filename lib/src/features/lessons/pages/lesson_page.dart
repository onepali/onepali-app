import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/choose_correct_lesson_view.dart';
import 'package:onepali/src/features/lessons/views/info_lesson_view.dart';
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
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LessonBloc()..add(LessonEvent.started(widget.lessonId)),
      child: Scaffold(
        body: BlocBuilder<LessonBloc, LessonState>(
          builder: (context, state) {
            if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }
            if (state.lessonDetails == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final contents = state.lessonDetails!.contents;
            if (contents.isEmpty) {
              return const Center(child: Text('No lesson content available'));
            }

            final index = state.currentIndex.clamp(0, contents.length - 1);
            final lessonContent = contents[index];
            switch (lessonContent) {
              case InfoLessonContent():
                return InfoLessonView(
                  key: ValueKey('${lessonContent.id}-${lessonContent.index}'),
                  lessonInformation: lessonContent,
                );
              case ChooseCorrectLessonContent():
                return ChooseCorrectLessonView(
                  key: ValueKey('${lessonContent.id}-${lessonContent.index}'),
                  lessonInformation: lessonContent,
                );
              case TapToRevealLessonContent():
                return TapToRevealLessonView(
                  lessonBloc: context.read<LessonBloc>(),
                );
              default:
                return const Center(child: Text('Unknown content type'));
            }
          },
        ),
      ),
    );
  }
}
