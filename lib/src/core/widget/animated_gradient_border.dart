import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:onepali/src/src.dart';

class AnimatedSolidColorBorder extends StatefulWidget {
  final double size;
  final double borderWidth;
  final List<Color> colors;
  final Widget child;
  final Duration fillDuration;
  final Duration hideDuration;

  const AnimatedSolidColorBorder({
    super.key,
    required this.size,
    required this.child,
    this.borderWidth = 4.0,
    this.colors = const [
      AppColors.kRed,
      AppColors.kSecondaryColor,
      AppColors.kButtonGreen,
      AppColors.kOrange,
    ],
    this.fillDuration = const Duration(seconds: 2),
    this.hideDuration = const Duration(milliseconds: 600),
  });

  @override
  State<AnimatedSolidColorBorder> createState() =>
      _AnimatedSolidColorBorderState();
}

class _AnimatedSolidColorBorderState extends State<AnimatedSolidColorBorder>
    with TickerProviderStateMixin {
  late AnimationController _fillController;
  late AnimationController _hideController;
  late Animation<double> _hideAnimation;

  @override
  void initState() {
    super.initState();
    _fillController = AnimationController(
      vsync: this,
      duration: widget.fillDuration,
    )..forward();
    _hideController = AnimationController(
      vsync: this,
      duration: widget.hideDuration,
    );
    _hideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _hideController, curve: Curves.easeInOut),
    );
    _fillController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _hideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fillController.dispose();
    _hideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_fillController, _hideController]),
            builder: (context, child) {
              if (_hideController.isCompleted) return const SizedBox.shrink();
              return Opacity(
                opacity: _hideAnimation.value,
                child: CustomPaint(
                  painter: _SolidColorBorderPainter(
                    progress: _fillController.value,
                    borderWidth: widget.borderWidth,
                    colors: widget.colors,
                  ),
                  child: const SizedBox.expand(),
                ),
              );
            },
          ),
          SizedBox(
            width: widget.size - widget.borderWidth * 2,
            height: widget.size - widget.borderWidth * 2,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class _SolidColorBorderPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final double borderWidth;
  final List<Color> colors;

  _SolidColorBorderPainter({
    required this.progress,
    required this.borderWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - borderWidth / 2;
    final totalSweep = 2 * math.pi * progress;
    final segmentSweep = totalSweep / colors.length;
    double startAngle = -math.pi / 2;
    for (final color in colors) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..strokeCap = StrokeCap.butt;
      final sweep = segmentSweep;
      if (progress > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweep,
          false,
          paint,
        );
      }
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _SolidColorBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.colors != colors ||
        oldDelegate.borderWidth != borderWidth;
  }
}
