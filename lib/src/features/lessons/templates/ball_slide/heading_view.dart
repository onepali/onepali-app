import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/templates/ball_slide/ball_heading_bloc/ball_heading_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';
import 'package:onepali/src/features/lessons/widgets/curved_ball_slider.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';

class HeadingView extends StatefulWidget {
  final BallSlideLessonContent content;
  final VoidCallback onNext;
  const HeadingView({super.key, required this.content, required this.onNext});

  @override
  State<HeadingView> createState() => _HeadingViewState();
}

class _HeadingViewState extends State<HeadingView>
    with AutoAdvanceMixin<HeadingView> {
  static const _autoAdvanceDelay = Duration(seconds: 1);

  bool isComplete = false;
  late AudioPlayerService audioPlayerService;

  @override
  void initState() {
    super.initState();
    audioPlayerService = AudioPlayerServiceImpl();
  }

  @override
  void dispose() {
    audioPlayerService.dispose();
    super.dispose();
  }

  Future<void> _completeAfterFeedback() async {
    final completion = audioPlayerService.onPlayerComplete.first;
    try {
      if (widget.content.messageSound != null &&
          widget.content.messageSound!.isNotEmpty) {
        await audioPlayerService.play(widget.content.messageSound!);
      } else {
        await audioPlayerService.playAsset(Assets.starBlast);
      }
      await completion;
    } catch (_) {
      // Audio feedback should not block progression.
    }
    if (!mounted) return;
    scheduleAutoAdvance(_autoAdvanceDelay, widget.onNext);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BallHeadingBloc, BallHeadingState>(
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackgroundImage(
                bgImageMb: widget.content.bgImageMobile,
                bgImageTb: widget.content.bgImageTablet,
              ),
            ),

            TopRightPositionedCloseButton(
              onTap: () {
                Navigator.pop(context);
              },
            ),

            if (isComplete)
              CenterLeftAlignedBackButton(
                onTap: () {
                  context.read<LessonBloc>().add(LessonEvent.previousContent());
                },
              ),
            if (isComplete)
              CenterRightAlignedForwardButton(
                onTap: () {
                  widget.onNext();
                },
              ),

            if (state.isAllAudioCompleted)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;

                    final startX = isMobile
                        ? (width - (width * widget.content.sliderLengthMb)) / 2
                        : (width - (width * widget.content.sliderLengthTb)) / 2;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: isMobile
                              ? widget.content.pDyMb.toDouble()
                              : height * 0.1,
                          left: startX,
                          child: SizedBox(
                            width: isMobile
                                ? width * widget.content.sliderLengthMb
                                : width * widget.content.sliderLengthTb,
                            child: CurvedBallSlider(
                              height: isMobile ? 150 : 300,
                              isRTL: widget.content.direction == 'rtl_heading',
                              value: isComplete ? 1.0 : 0.0,
                              sliderColor: widget.content.sliderColor,
                              onChanged: (v) {
                                if (v == 1.0) {
                                  if (isComplete) return;
                                  setState(() {
                                    log('isComplete: $isComplete');
                                    isComplete = true;
                                  });
                                  unawaited(_completeAfterFeedback());
                                } else {
                                  if (!isComplete) return;
                                  setState(() {
                                    log('isComplete: $isComplete');
                                    isComplete = false;
                                  });
                                }
                              },
                              content: widget.content,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            if (isComplete && state.content?.message != null)
              Positioned(
                top: size.height * 0.1,
                left: 0,
                right: 0,
                child: LabelDisplay(
                  nameNp: state.content?.message ?? '',
                  nameEn: '',
                ),
              ),
          ],
        );
      },
    );
  }
}
