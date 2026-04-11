import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';

class UnknownLessonType extends StatelessWidget {
  const UnknownLessonType({
    super.key,
    this.isFirst = false,
    this.isLast = false,
  });
  final bool isLast;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TopRightPositionedCloseButton(onTap: () => Navigator.of(context).pop()),
        Center(
          child: Text('Unknown Lesson Type'),
        ),
        if (!isLast) CenterRightAlignedForwardButton(
          onTap: () => context.read<LessonBloc>().add(
            const LessonEvent.nextContent(),
          ),
        ),
        if (!isFirst)
          CenterLeftAlignedBackButton(
            onTap: () => context.read<LessonBloc>().add(
              const LessonEvent.previousContent(),
            ),
          ),
      ],
    );
  }
}
