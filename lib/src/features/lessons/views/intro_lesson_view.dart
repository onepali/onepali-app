import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class IntroLessonView extends StatelessWidget {
  const IntroLessonView({super.key, required this.content});
  final IntroLessonContent content;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Positioned.fill(child: Container(color: colorFromHex(content.bgColor))),
        Positioned(
          top: size.height * 0.03,
          right: size.width * 0.03,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SvgHelper.fromSource(path: Assets.wrong),
          ),
        ),
        Center(
          child: SvgHelper.fromSource(
            path: content.image ?? '',
            type: SvgSourceType.network,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          top: 0,

          child: Padding(
            padding: const EdgeInsets.all(32),
            child: InkWell(
              onTap: () {
                context.read<LessonBloc>().add(const LessonEvent.nextContent());
              },
              child: SvgHelper.fromSource(path: Assets.rightArrow),
            ),
          ),
        ),
      ],
    );
  }
}
