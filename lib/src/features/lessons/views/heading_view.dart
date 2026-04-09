import 'dart:developer';
import 'dart:math' show pi;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/ball_heading_bloc/ball_heading_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/curved_ball_slider.dart';

class HeadingView extends StatefulWidget {
  final BallSlideLessonContent content;
  const HeadingView({super.key, required this.content});

  @override
  State<HeadingView> createState() => _HeadingViewState();
}

class _HeadingViewState extends State<HeadingView> {
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

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return BlocBuilder<BallHeadingBloc, BallHeadingState>(
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: CustomCachedImage(
                imageUrl: isMobile
                    ? widget.content.bgImageMobile ?? ''
                    : widget.content.bgImageTablet ?? '',
                fit: BoxFit.cover,
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
                  context.read<LessonBloc>().add(LessonEvent.nextContent());
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
                          child: Container(
                            // color: Colors.pink,
                            width: isMobile
                                ? width * widget.content.sliderLengthMb
                                : width * widget.content.sliderLengthTb,

                            child: CurvedBallSlider(
                              height: isMobile ? 150 : 300,
                              isRTL: widget.content.direction == 'rtl_heading',
                              value: 0.0,
                              sliderColor: widget.content.sliderColor,
                              onChanged: (v) {
                                if (v == 1.0) {
                                  if (isComplete) return;
                                  setState(() {
                                    log('isComplete: $isComplete');
                                    isComplete = true;
                                  });
                                  audioPlayerService.playAsset(
                                    Assets.starBlast,
                                  );
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

            // if (isComplete)
            //   AnimatedOpacity(
            //     opacity: 1.0,
            //     duration: const Duration(milliseconds: 300),
            //     child: Center(
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 24,
            //           vertical: 12,
            //         ),
            //         decoration: BoxDecoration(
            //           color: Colors.yellow,
            //           borderRadius: BorderRadius.circular(30),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.2),
            //               blurRadius: 8,
            //               offset: const Offset(0, 4),
            //             ),
            //           ],
            //         ),
            //         child: const Text(
            //           'Header!',
            //           style: TextStyle(
            //             fontSize: 22,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.black87,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        );
      },
    );
  }
}
