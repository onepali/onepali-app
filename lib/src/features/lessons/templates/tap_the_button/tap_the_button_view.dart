import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tap_the_button/tap_the_button_bloc/tap_the_button_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';

class TapTheButtonView extends StatefulWidget {
  const TapTheButtonView({
    super.key,
    required this.content,
    required this.onNext,
  });

  final TapTheButtonLessonContent content;
  final VoidCallback onNext;

  @override
  State<TapTheButtonView> createState() => _TapTheButtonViewState();
}

class _TapTheButtonViewState extends State<TapTheButtonView>
    with AutoAdvanceMixin<TapTheButtonView> {
  static const _autoAdvanceDelay = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) =>
          TapTheButtonBloc()..add(TapTheButtonEvent.started(widget.content)),
      child: BlocConsumer<TapTheButtonBloc, TapTheButtonState>(
        listenWhen: (previous, current) =>
            !previous.isCompleted && current.isCompleted,
        listener: (context, state) {
          scheduleAutoAdvance(_autoAdvanceDelay, widget.onNext);
        },
        builder: (context, state) {
          if (state.content == null) {
            return const Center(child: Text('No content found'));
          }
          return Stack(
            children: [
              Positioned.fill(
                child: BackgroundImage(
                  bgImageMb: widget.content.bgImage,
                  bgImageTb: widget.content.bgImageTb,
                ),
              ),
              TopRightPositionedCloseButton(
                onTap: () => Navigator.of(context).pop(),
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
              if (state.isCompleted)
                CenterLeftAlignedBackButton(
                  onTap: () {
                    context.read<LessonBloc>().add(
                      LessonEvent.previousContent(),
                    );
                  },
                ),
              if (state.isCompleted)
                CenterRightAlignedForwardButton(onTap: widget.onNext),
            ],
          );
        },
      ),
    );
  }
}
