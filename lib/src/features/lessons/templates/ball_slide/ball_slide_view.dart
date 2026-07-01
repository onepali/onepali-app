import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/templates/ball_slide/ball_heading_bloc/ball_heading_bloc.dart';
import 'package:onepali/src/features/lessons/templates/ball_slide/ball_slider_bloc/ball_slider_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/templates/conversation/conversation_view.dart';
import 'package:onepali/src/features/lessons/templates/ball_slide/heading_view.dart';
import 'package:onepali/src/features/lessons/templates/ball_slide/penalty_slide_view.dart';
import 'package:onepali/src/features/lessons/widgets/ball_slider.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';

class BallSlideView extends StatelessWidget {
  const BallSlideView({super.key, required this.content});
  final BallSlideLessonContent content;

  Widget buildSlider(String direction) {
    switch (direction) {
      case 'ltr':
        return BallSliderLtrView(content: content);
      case 'rtl':
        return BallSliderRtlView(content: content);
      case 'ltr_heading':
      case 'rtl_heading':
        return HeadingSliderLtrScreen(content: content);
      case 'penalty':
        return PenaltySlideView(content: content);
      case 'none':
        return ConversationView(content: content);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildSlider(content.direction);
  }
}

class BallSliderLtrView extends StatelessWidget {
  const BallSliderLtrView({super.key, required this.content});
  final BallSlideLessonContent content;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BallSliderBloc(
        ballSize: 60.0,
        completionThreshold: 0.98,
        direction: SliderDirection.leftToRight,
      )..add(BallSliderEvent.started(content)),
      child: _SliderView(content: content),
    );
  }
}

class BallSliderRtlView extends StatelessWidget {
  const BallSliderRtlView({super.key, required this.content});
  final BallSlideLessonContent content;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BallSliderBloc(
        ballSize: 60.0,
        completionThreshold: 0.98,
        direction: SliderDirection.rightToLeft, // ← reversed
      )..add(BallSliderEvent.started(content)),
      child: _SliderView(content: content),
    );
  }
}

class _SliderView extends StatefulWidget {
  final BallSlideLessonContent content;
  const _SliderView({required this.content});

  @override
  State<_SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<_SliderView> {
  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<BallSliderBloc, BallSliderState>(
      buildWhen: (p, c) => p.isComplete != c.isComplete,
      builder: (context, state) {
        return Stack(
          children: [
            // Background
            Positioned.fill(
              child: CustomCachedImage(
                imageUrl: isMobile
                    ? widget.content.bgImageMobile ?? ''
                    : widget.content.bgImageTablet ?? '',
                fit: BoxFit.cover,
              ),
            ),

            // Close button
            TopRightPositionedCloseButton(
              onTap: () {
                Navigator.pop(context);
              },
            ),
            if (state.isComplete)
              CenterRightAlignedForwardButton(
                onTap: () {
                  context.read<LessonBloc>().add(LessonEvent.nextContent());
                },
              ),
            if (state.isComplete)
              CenterLeftAlignedBackButton(
                onTap: () {
                  context.read<LessonBloc>().add(LessonEvent.previousContent());
                },
              ),
            // Ball Slider
            Positioned(
              bottom: isMobile
                  ? widget.content.pDyMb.toDouble()
                  : widget.content.pDyTb.toDouble(),

              left: isMobile
                  ? (size.width -
                            (widget.content.sliderLengthMb * size.width)) /
                        2
                  : (size.width -
                            (widget.content.sliderLengthTb * size.width)) /
                        2,
              right: isMobile
                  ? (size.width -
                            (widget.content.sliderLengthMb * size.width)) /
                        2
                  : (size.width -
                            (widget.content.sliderLengthTb * size.width)) /
                        2,
              child: Transform.rotate(
                // rotate opposite if not 'ltr'
                angle: widget.content.angle.toDouble(),
                child: BallSlider(
                  trackHeight: isMobile ? 52 : 80,
                  ballSize: isMobile ? 70 : 120,
                  ballImagePath: state.isComplete
                      ? widget.content.ballImageEnd ??
                            widget.content.ballImage ??
                            ''
                      : widget.content.ballImage ?? '',
                  sliderColor: widget.content.sliderColor,
                ),
              ),
            ),

            // Goal message
            BlocBuilder<BallSliderBloc, BallSliderState>(
              buildWhen: (p, c) => p.isComplete != c.isComplete,
              builder: (context, state) {
                if (state.isComplete && state.content?.message != null) {
                  return Positioned(
                    top: size.height * 0.1,
                    left: 0,
                    right: 0,
                    child: LabelDisplay(
                      nameNp: state.content?.message ?? '',
                      nameEn: '',
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        );
      },
    );
  }
}

class HeadingSliderLtrScreen extends StatelessWidget {
  const HeadingSliderLtrScreen({super.key, required this.content});
  final BallSlideLessonContent content;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BallHeadingBloc()..add(BallHeadingEvent.started(content)),
      child: HeadingView(content: content),
    );
  }
}
