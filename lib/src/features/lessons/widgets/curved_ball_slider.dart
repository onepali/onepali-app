import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class CurvedBallSlider extends StatefulWidget {
  final double value; 
  final ValueChanged<double>? onChanged;
  final double height;
  final bool isRTL;
  final BallSlideLessonContent content;

  const CurvedBallSlider({
    required this.content,
    super.key,
    this.value = 0,
    this.onChanged,
    this.height = 160,
    this.isRTL = false,
  });

  @override
  State<CurvedBallSlider> createState() => _CurvedBallSliderState();
}

class _CurvedBallSliderState extends State<CurvedBallSlider> {
  late double progress;

  @override
  void initState() {
    super.initState();
    progress = widget.value.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final trackHeight = isMobile ? 52 : 80;
    final ballSize = isMobile ? 70 : 120;
    final totalHeight = widget.height + ballSize;

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final path = _buildPath(
            width,
            widget.height,
            trackHeight.toDouble(),
            widget.isRTL,
            ballSize.toDouble(),
          );

          final metric = path.computeMetrics().first;
          final tangent = metric.getTangentForOffset(metric.length * progress)!;

          return GestureDetector(
            onPanUpdate: (details) {
              if(progress == 1.0) return;
              final width = context.size!.width;

              double delta = details.delta.dx / width;

              if (widget.isRTL) {
                delta = -delta;
              }

              setState(() {
                progress += delta * 1.3;
                progress = progress.clamp(0.0, 1.0);
              });

              widget.onChanged?.call(progress);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(width, widget.height),
                  painter: _CurvePainter(
                    progress: progress,
                    strokeWidth: trackHeight.toDouble(),
                    isRTL: widget.isRTL,
                  ),
                ),

                CustomPaint(
                  size: Size(width, widget.height),
                  painter: _ArrowPainter(
                    path: path,
                    progress: progress,
                    isRTL: widget.isRTL,
                    strokeWidth: trackHeight.toDouble(),
                  ),
                ),

                // Ball Image
                Positioned(
                  left: tangent.position.dx - ballSize / 2,
                  top: tangent.position.dy - ballSize / 2,
                  child: CustomCachedImage(
                    imageUrl: widget.content.ballImage ?? '',
                    width: ballSize.toDouble(),
                    height: ballSize.toDouble(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Path _buildPath(
    double width,
    double height,
    double stroke,
    bool isRTL,
    double ballSize,
  ) {
    final path = Path();

    final topPadding = stroke;
    final bottomY = height - stroke;

    final startX = ballSize;
    final endX = width - ballSize;

    if (!isRTL) {
      path.moveTo(startX, bottomY);
      path.quadraticBezierTo(width / 2, topPadding, endX, bottomY);
    } else {
      path.moveTo(endX, bottomY);
      path.quadraticBezierTo(width / 2, topPadding, startX, bottomY);
    }

    return path;
  }
}

class _CurvePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final bool isRTL;

  _CurvePainter({
    required this.progress,
    required this.strokeWidth,
    required this.isRTL,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final topPadding = strokeWidth;
    final bottomY = size.height - strokeWidth;

    final greyPaint = Paint()
      ..color = AppColors.kButtonGrey.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final redPaint = Paint()
      ..color = AppColors.kButtonGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final thumbRadius = strokeWidth * 2.2 / 2;

    final startX = thumbRadius;
    final endX = size.width - thumbRadius;

    if (!isRTL) {
      path.moveTo(startX, bottomY);
      path.quadraticBezierTo(size.width / 2, topPadding, endX, bottomY);
    } else {
      path.moveTo(endX, bottomY);
      path.quadraticBezierTo(size.width / 2, topPadding, startX, bottomY);
    }

    canvas.drawPath(path, greyPaint);

    final metric = path.computeMetrics().first;
    final extractPath = metric.extractPath(0, metric.length * progress);

    canvas.drawPath(extractPath, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ArrowPainter extends CustomPainter {
  final Path path;
  final double progress;
  final bool isRTL;
  final double strokeWidth;

  _ArrowPainter({
    required this.path,
    required this.progress,
    required this.isRTL,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 0.95) return; 

    final metric = path.computeMetrics().first;
    final pathLength = metric.length;

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final arrowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final startOffset = (pathLength * progress) + 20;
    if (startOffset < pathLength) {
      final remainingPath = metric.extractPath(startOffset, pathLength);
      canvas.drawPath(remainingPath, linePaint);
    }

    final tangent = metric.getTangentForOffset(pathLength - 1.0)!;
    final pos = tangent.position;
    final angle = tangent.angle;

    const double arrowSize = 12.0;

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
   
    canvas.rotate(
      isRTL ? 2.628 : -angle,
    ); 

    final arrowPath = Path()
      ..moveTo(arrowSize, 0) // The tip
      ..lineTo(-arrowSize * 0.8, -arrowSize * 0.6) // Bottom left
      ..lineTo(-arrowSize * 0.8, arrowSize * 0.6) // Bottom right
      ..close();

    canvas.drawPath(arrowPath, arrowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
