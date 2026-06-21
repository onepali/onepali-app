import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/tap_to_change_bloc/tap_to_change_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';

class TapToChangeView extends StatefulWidget {
  const TapToChangeView({
    super.key,
    required this.content,
    required this.onNext,
  });
  final TapToChangeLessonContent content;
  final VoidCallback onNext;

  @override
  State<TapToChangeView> createState() => _TapToChangeViewState();
}

class _TapToChangeViewState extends State<TapToChangeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) =>
          TapToChangeBloc()..add(TapToChangeEvent.started(widget.content)),
      child: BlocBuilder<TapToChangeBloc, TapToChangeState>(
        builder: (context, state) {
          if (state.content == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return GestureDetector(
            onTapDown: (TapDownDetails details) {
              if (state.status != TapToChangeStatus.idle) return;
              final position = details.globalPosition;

              context.read<TapToChangeBloc>().add(
                TapToChangeEvent.tapped(position),
              );
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackgroundImage(
                    bgImageMb: state.status == TapToChangeStatus.tapped
                        ? widget.content.afterBgImage
                        : widget.content.bgImage,
                    bgImageTb: state.status == TapToChangeStatus.tapped
                        ? widget.content.afterBgImageTb
                        : widget.content.bgImageTb,
                  ),
                ),
                TopRightPositionedCloseButton(
                  onTap: () => Navigator.of(context).pop(),
                ),
                CenterRightAlignedForwardButton(
                  onTap: () {
                    widget.onNext();
                  },
                ),

                CenterLeftAlignedBackButton(
                  onTap: () {
                    context.read<LessonBloc>().add(
                      const LessonEvent.previousContent(),
                    );
                  },
                ),
                if (state.status == TapToChangeStatus.idle)
                  Center(
                    child:
                        CustomCachedImage(
                              imageUrl: state.content!.tapGesture ?? '',
                              height: size.height * 0.2,
                              width: size.height * 0.2,
                            )
                            .animate(
                              onComplete: (controller) {
                                controller.repeat(reverse: true);
                              },
                            )
                            .scaleXY(
                              begin: 1.0,
                              end: 1.12,
                              duration: 500.ms,
                              curve: Curves.easeInOut,
                            ),
                  ),
                if (state.status == TapToChangeStatus.tapped &&
                    state.tapPosition != null)
                  Positioned(
                    top: state.tapPosition!.dy - (size.height * 0.25 / 2),
                    left: state.tapPosition!.dx - (size.height * 0.25 / 2),
                    // add animation like splash animaton to this widget
                    child: CustomCachedImage(
                      imageUrl: state.content!.splashImage ?? '',
                      height: size.height * 0.25,
                      width: size.height * 0.25,
                    ).animate().slideX(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
