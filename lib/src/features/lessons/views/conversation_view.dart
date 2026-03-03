import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class ConversationView extends StatelessWidget {
  const ConversationView({super.key, required this.content});
  final BallSlideLessonContent content;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return Stack(
      children: [
        Positioned.fill(
          child: CustomCachedImage(
            imageUrl: isMobile
                ? content.bgImageMobile ?? ''
                : content.bgImageTablet ?? '',
            fit: BoxFit.cover,
          ),
        ),

        CenterLeftAlignedBackButton(
          onTap: () {
            context.read<LessonBloc>().add(LessonEvent.previousContent());
          },
        ),
        CenterRightAlignedForwardButton(
          onTap: () {
            context.read<LessonBloc>().add(LessonEvent.nextContent());
          },
        ),
      ],
    );
  }
}
