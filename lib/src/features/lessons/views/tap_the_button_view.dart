import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/tap_the_button_bloc/tap_the_button_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';

class TapTheButtonView extends StatelessWidget {
  const TapTheButtonView({super.key, required this.content});
  final TapTheButtonLessonContent content;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) =>
          TapTheButtonBloc()..add(TapTheButtonEvent.started(content)),
      child: BlocBuilder<TapTheButtonBloc, TapTheButtonState>(
        builder: (context, state) {
          if (state.content == null) {
            return const Center(child: Text('No content found'));
          }
          return Stack(
            children: [
              Positioned.fill(
                child: BackgroundImage(
                  bgImageMb: content.bgImage,
                  bgImageTb: content.bgImageTb,
                ),
              ),
              if (!state.isTapped && !state.isCompleted)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.read<TapTheButtonBloc>().add(
                        TapTheButtonEvent.tapped(),
                      );
                    },
                    child:
                        CustomCachedImage(
                              imageUrl: state.content!.buttonImage ?? '',
                              height: isMobile
                                  ? size.height * 0.4
                                  : size.height * 0.2,
                              width: isMobile
                                  ? size.width * 0.4
                                  : size.width * 0.2,
                            )
                            .animate(
                              onComplete: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .scaleXY(
                              begin: 1.0,
                              end: 1.12,
                              duration: 900.ms,
                              curve: Curves.easeInOut,
                            ),
                  ),
                ),
              if (state.isCompleted || state.isTapped)
                CenterLeftAlignedBackButton(
                  onTap: () {
                    context.read<LessonBloc>().add(
                      LessonEvent.previousContent(),
                    );
                  },
                ),
              if (state.isCompleted || state.isTapped)
                CenterRightAlignedForwardButton(
                  onTap: () {
                    context.read<LessonBloc>().add(LessonEvent.nextContent());
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
