import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/features/lessons/templates/ball_slide/ball_slider_bloc/ball_slider_bloc.dart';

class BallSlider extends StatelessWidget {
  final double trackHeight;
  final double ballSize;
  final String ballImagePath;
  final String? ballImageEndPath;
  final String? sliderColor;

  const BallSlider({
    super.key,
    this.trackHeight = 52.0,
    this.ballSize = 60.0,
    required this.ballImagePath,
    this.ballImageEndPath,
    this.sliderColor,
  });

  @override
  Widget build(BuildContext context) {
    final direction = context.read<BallSliderBloc>().direction;
    final isRtL = direction == SliderDirection.rightToLeft;

    return BlocBuilder<BallSliderBloc, BallSliderState>(
      builder: (context, state) {
        log("Audio completed: ${state.isAllAudioCompleted}");
        return !state.isAllAudioCompleted
            ? SizedBox.shrink()
            : LayoutBuilder(
                builder: (context, constraints) {
                  final trackWidth = constraints.maxWidth;

                  print(trackWidth);
                  final usableWidth = trackWidth - ballSize;

                  final ballLeft = isRtL
                      ? ((1.0 - state.value) * usableWidth).clamp(
                          0.0,
                          usableWidth,
                        )
                      : (state.value * usableWidth).clamp(0.0, usableWidth);

                  final fillWidth = (state.value * usableWidth + ballSize / 2)
                      .clamp(0.0, trackWidth);

                  return SizedBox(
                    height: ballSize,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,

                      onHorizontalDragUpdate: (details) {
                        if (state.value >= 1) return;
                        final normalizedDelta = details.delta.dx / usableWidth;
                        context.read<BallSliderBloc>().add(
                          BallSliderEvent.ballDragged(
                            delta: normalizedDelta,
                            usableWidth: usableWidth,
                          ),
                        );
                      },

                      onHorizontalDragEnd: (details) {
                        if (state.value >= 1) return;
                        context.read<BallSliderBloc>().add(
                          BallSliderEvent.ballDragEnded(
                            velocityPx: details.velocity.pixelsPerSecond.dx,
                            usableWidth: usableWidth,
                          ),
                        );
                      },

                      onTapDown: (details) {
                        context.read<BallSliderBloc>().add(
                          BallSliderEvent.ballTapped(
                            tapX: details.localPosition.dx,
                            trackWidth: usableWidth,
                          ),
                        );
                      },

                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Center(
                            child: Container(
                              height: trackHeight,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: state.isComplete
                                    ? colorFromHex(state.content?.sliderColor)
                                    : AppColors.kLightGrey.withValues(
                                        alpha: 0.5,
                                      ),
                                borderRadius: BorderRadius.circular(
                                  trackHeight / 2,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: isRtL ? null : 0,
                            right: isRtL ? 0 : null,
                            top: (ballSize - trackHeight) / 2,
                            child: Container(
                              width: fillWidth,
                              height: trackHeight,
                              decoration: BoxDecoration(
                                color:
                                    colorFromHex(sliderColor) ??
                                    AppColors.kButtonGreen,
                                borderRadius: BorderRadius.circular(
                                  trackHeight / 2,
                                ),
                              ),
                            ),
                          ),

                          if (isRtL)
                            Positioned(
                              left: 0,
                              right: trackWidth - ballLeft,
                              top: 0,
                              bottom: 0,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: CustomPaint(
                                  painter: _ArrowBarPainter(pointRight: false),
                                  child: const SizedBox.expand(),
                                ),
                              ),
                            )
                          else
                            Positioned(
                              left: ballLeft + ballSize / 2,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: CustomPaint(
                                  painter: _ArrowBarPainter(pointRight: true),
                                  child: const SizedBox.expand(),
                                ),
                              ),
                            ),

                          //  Ball image thumb (rotates as it rolls)
                          Positioned(
                            left: ballLeft,
                            top: 0,
                            child: Transform.rotate(
                              angle: direction == SliderDirection.rightToLeft
                                  ? -state.rotationAngle
                                  : state.rotationAngle,
                              child: CustomCachedImage(
                                imageUrl: ballImagePath,
                                width: ballSize,
                                height: ballSize,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}

class _ArrowBarPainter extends CustomPainter {
  final bool pointRight;
  const _ArrowBarPainter({required this.pointRight});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width < 16) return;

    const arrowHeadSize = 12.0;
    final cy = size.height / 2;

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final arrowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    if (pointRight) {
      //  Right-pointing arrow
      final lineEndX = size.width - arrowHeadSize - 4;
      canvas.drawLine(Offset(0, cy), Offset(lineEndX, cy), linePaint);
      final path = Path()
        ..moveTo(size.width - 4, cy)
        ..lineTo(lineEndX, cy - arrowHeadSize / 2)
        ..lineTo(lineEndX, cy + arrowHeadSize / 2)
        ..close();
      canvas.drawPath(path, arrowPaint);
    } else {
      //  Left-pointing arrow
      final lineStartX = arrowHeadSize + 4;
      canvas.drawLine(
        Offset(lineStartX, cy),
        Offset(size.width, cy),
        linePaint,
      );
      final path = Path()
        ..moveTo(4, cy)
        ..lineTo(lineStartX, cy - arrowHeadSize / 2)
        ..lineTo(lineStartX, cy + arrowHeadSize / 2)
        ..close();
      canvas.drawPath(path, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArrowBarPainter old) =>
      old.pointRight != pointRight;
}
