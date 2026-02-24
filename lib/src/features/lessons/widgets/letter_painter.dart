import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class LetterPainter extends CustomPainter {
  final double strokeWidth;
  final List<Path> letterPaths;
  final Path? outlinePath;
  final List<Path> completedPaths;
  final List<List<Offset>> pathsPoints;
  final List<Offset> userStrokes;
  final int currentPathIndex;
  final double currentStrokeProgress;
  final bool isTracingOutsideBounds;
  final bool showPointer;
  final Offset? pointerPosition;
  final bool showGuideDots;
  final bool showStrokeDirection;
  final List<Rect> strokeBoundingBoxes;
  final bool isMobile;

  LetterPainter({
    required this.strokeWidth,
    required this.letterPaths,
    this.outlinePath,
    required this.completedPaths,
    required this.pathsPoints,
    required this.userStrokes,
    required this.currentPathIndex,
    this.currentStrokeProgress = 0.0,
    this.isTracingOutsideBounds = false,
    this.showPointer = false,
    this.pointerPosition,
    this.showGuideDots = true,
    this.showStrokeDirection = true,
    required this.strokeBoundingBoxes,
    required this.isMobile,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (outlinePath != null) {
      // Draw letter outline
      canvas.drawPath(
        outlinePath!,
        Paint()
          ..color = AppColors.kBlack
          ..style = PaintingStyle.stroke
          ..strokeWidth = isMobile ? 4 : 8
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    // Draw all strokes with different visual states
    for (int i = 0; i < letterPaths.length; i++) {
      final path = letterPaths[i];
      final isCompleted = completedPaths.contains(path);
      final isCurrent = i == currentPathIndex;
      final isFuture = i > currentPathIndex;

      Paint strokePaint;

      if (isCompleted) {
        strokePaint = Paint()
          ..color = AppColors.kButtonGreen
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
      } else if (isCurrent) {
        strokePaint = Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        if (showGuideDots && pathsPoints.length > i) {
          _drawGuideDots(canvas, pathsPoints[i]);
        }

        if (currentStrokeProgress > 0) {
          _drawProgressIndicator(canvas, path, currentStrokeProgress);
        }
      } else if (isFuture) {
        strokePaint = Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
      } else {
        strokePaint = Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
      }

      canvas.drawPath(path, strokePaint);

      if (isCurrent && showStrokeDirection && pathsPoints.length > i) {
        _drawStrokeDirection(canvas, pathsPoints[i]);
      }
    }

    // Draw user's current stroke
    if (userStrokes.isNotEmpty) {
      final userPaint = Paint()
        ..color = isTracingOutsideBounds
            ? AppColors.kPrimaryColor
            : AppColors.kOrange
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 0.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final userPath = Path();
      userPath.moveTo(userStrokes.first.dx, userStrokes.first.dy);
      for (int i = 1; i < userStrokes.length; i++) {
        userPath.lineTo(userStrokes[i].dx, userStrokes[i].dy);
      }
      canvas.drawPath(userPath, userPaint);
    }

    // Draw animated pointer with arrow icon
    if (showPointer && pointerPosition != null) {
      _drawPointerWithIcon(canvas, pointerPosition!);
    }
  }

  void _drawPointerWithIcon(Canvas canvas, Offset position) {
    // Get direction from current stroke
    double angle = 0.0;
    if (currentPathIndex < pathsPoints.length &&
        pathsPoints[currentPathIndex].length >= 2) {
      final startPoint = pathsPoints[currentPathIndex][0];
      final nextPoint = pathsPoints[currentPathIndex].length > 10
          ? pathsPoints[currentPathIndex][10]
          : pathsPoints[currentPathIndex][1];

      final dx = nextPoint.dx - startPoint.dx;
      final dy = nextPoint.dy - startPoint.dy;
      angle = atan2(dy, dx);
    }

    // Inner solid circle
    final innerCirclePaint = Paint()
      ..color = AppColors.kOrange
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, strokeWidth * 0.6, innerCirclePaint);

    // Draw arrow icon using TextPainter (Material Icons)
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);

    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.arrow_forward.codePoint),
        style: TextStyle(
          fontSize: strokeWidth * 0.7,
          fontFamily: Icons.arrow_forward.fontFamily,
          package: Icons.arrow_forward.fontPackage,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );

    canvas.restore();
  }

  void _drawGuideDots(Canvas canvas, List<Offset> points) {
    final dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i += 15) {
      canvas.drawCircle(points[i], isMobile ? 2 : 3, dotPaint);
    }
  }

  void _drawProgressIndicator(Canvas canvas, Path path, double progress) {
    final progressPaint = Paint()
      ..color = AppColors.kButtonGreen.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.2
      ..strokeCap = StrokeCap.round;

    final metrics = path.computeMetrics().first;
    final extractPath = metrics.extractPath(0, metrics.length * progress);

    canvas.drawPath(extractPath, progressPaint);
  }

  void _drawStrokeDirection(Canvas canvas, List<Offset> points) {
    if (points.length < 10) return;

    final arrowIndex = (points.length * 0.2).toInt();
    if (arrowIndex >= points.length - 1) return;

    final startPoint = points[arrowIndex];
    final endPoint =
        points[arrowIndex + 5 < points.length
            ? arrowIndex + 5
            : points.length - 1];

    final dx = endPoint.dx - startPoint.dx;
    final dy = endPoint.dy - startPoint.dy;
    final angle = atan2(dy, dx);

    final arrowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final arrowPath = Path();
    final arrowSize = strokeWidth * 0.8;

    arrowPath.moveTo(endPoint.dx, endPoint.dy);
    arrowPath.lineTo(
      endPoint.dx - arrowSize * cos(angle - 0.4),
      endPoint.dy - arrowSize * sin(angle - 0.4),
    );
    arrowPath.lineTo(
      endPoint.dx - arrowSize * cos(angle + 0.4),
      endPoint.dy - arrowSize * sin(angle + 0.4),
    );
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(LetterPainter oldDelegate) {
    return oldDelegate.userStrokes != userStrokes ||
        oldDelegate.completedPaths != completedPaths ||
        oldDelegate.currentPathIndex != currentPathIndex ||
        oldDelegate.currentStrokeProgress != currentStrokeProgress ||
        oldDelegate.isTracingOutsideBounds != isTracingOutsideBounds ||
        oldDelegate.showPointer != showPointer ||
        oldDelegate.pointerPosition != pointerPosition;
  }
}

double atan2(double y, double x) {
  return (Offset(x, y)).direction;
}

double cos(double radians) {
  return Offset.fromDirection(radians).dx;
}

double sin(double radians) {
  return Offset.fromDirection(radians).dy;
}
