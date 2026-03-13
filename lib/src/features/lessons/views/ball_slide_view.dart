import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/ball_heading_bloc/ball_heading_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/ball_slider_bloc/ball_slider_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/conversation_view.dart';
import 'package:onepali/src/features/lessons/views/heading_view.dart';
import 'package:onepali/src/features/lessons/views/penalty_slide_view.dart';
import 'package:onepali/src/features/lessons/widgets/ball_slider.dart';

class BallSlideView extends StatelessWidget {
  const BallSlideView({super.key, required this.content, required this.onNext});
  final BallSlideLessonContent content;
  final VoidCallback onNext;

  Widget buildSlider(String direction) {
    switch (direction) {
      case 'ltr':
        return BallSliderLtrView(content: content, onNext: onNext);
      case 'rtl':
        return BallSliderRtlView(content: content, onNext: onNext);
      case 'ltr_heading':
      case 'rtl_heading':
        return HeadingSliderLtrScreen(content: content, onNext: onNext);
      case 'penalty':
        return PenaltySlideView(content: content, onNext: onNext);
      case 'none':
        return ConversationView(content: content, onNext: onNext);
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
  const BallSliderLtrView({
    super.key,
    required this.content,
    required this.onNext,
  });
  final BallSlideLessonContent content;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BallSliderBloc(
        ballSize: 60.0,
        completionThreshold: 0.98,
        direction: SliderDirection.leftToRight,
      ),
      child: _SliderView(content: content, onNext: onNext),
    );
  }
}

class BallSliderRtlView extends StatelessWidget {
  const BallSliderRtlView({
    super.key,
    required this.content,
    required this.onNext,
  });
  final BallSlideLessonContent content;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BallSliderBloc(
        ballSize: 60.0,
        completionThreshold: 0.98,
        direction: SliderDirection.rightToLeft, // ← reversed
      ),
      child: _SliderView(content: content, onNext: onNext),
    );
  }
}

class HeadingSliderLtrScreen extends StatelessWidget {
  const HeadingSliderLtrScreen({
    super.key,
    required this.content,
    required this.onNext,
  });
  final BallSlideLessonContent content;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BallHeadingBloc()..add(BallHeadingEvent.started(content)),
      child: HeadingView(content: content, onNext: onNext),
    );
  }
}

class _SliderView extends StatelessWidget {
  final BallSlideLessonContent content;
  final VoidCallback onNext;
  const _SliderView({required this.content, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: CustomCachedImage(
            imageUrl: isMobile
                ? content.bgImageMobile ?? ''
                : content.bgImageTablet ?? '',
            fit: BoxFit.cover,
          ),
        ),

        // Close button
        TopRightPositionedCloseButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        CenterRightAlignedForwardButton(onTap: onNext),
        CenterLeftAlignedBackButton(
          onTap: () {
            context.read<LessonBloc>().add(LessonEvent.previousContent());
          },
        ),
        // Ball Slider
        Positioned(
          bottom: isMobile
              ? content.pDyMb.toDouble()
              : content.pDyTb.toDouble(),

          left: isMobile
              ? (size.width - (content.sliderLengthMb * size.width)) / 2
              : (size.width - (content.sliderLengthTb * size.width)) / 2,
          right: isMobile
              ? (size.width - (content.sliderLengthMb * size.width)) / 2
              : (size.width - (content.sliderLengthTb * size.width)) / 2,
          child: Transform.rotate(
            // rotate opposite if not 'ltr'
            angle: content.angle.toDouble(),
            child: BallSlider(
              trackHeight: isMobile ? 52 : 80,
              ballSize: isMobile ? 70 : 120,
              ballImagePath: content.ballImage ?? '',
            ),
          ),
        ),

        // Goal message
        BlocBuilder<BallSliderBloc, BallSliderState>(
          buildWhen: (p, c) => p.isComplete != c.isComplete,
          builder: (context, state) => AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: state.isComplete ? 60 : 20,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: state.isComplete ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kYellow,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Goal!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
