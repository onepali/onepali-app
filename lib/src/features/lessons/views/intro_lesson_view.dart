import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class IntroLessonView extends StatefulWidget {
  const IntroLessonView({super.key, required this.content});
  final IntroLessonContent content;

  @override
  State<IntroLessonView> createState() => _IntroLessonViewState();
}

class _IntroLessonViewState extends State<IntroLessonView> {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Positioned.fill(child: Container(color: colorFromHex(widget.content.bgColor))),
        TopRightPositionedCloseButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        Center(
          child: SvgHelper.fromSource(
            path: widget.content.image ?? '',
            type: SvgSourceType.network,
          ),
        ),

        CenterRightAlignedForwardButton(
          onTap: () {
            context.read<LessonBloc>().add(const LessonEvent.nextContent());
          },
        ),
      ],
    );
  }
}
