// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui';

// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:onepali/src/features/lessons/models/nepali_letter.dart';
// import 'package:path_drawing/path_drawing.dart';
// import 'dart:ui' as ui;
// import 'dart:math' as math;

// class TracingScreen extends StatefulWidget {
//   final NepaliLetter letter;

//   const TracingScreen({super.key, required this.letter});

//   @override
//   State<TracingScreen> createState() => _TracingScreenState();
// }

// class _TracingScreenState extends State<TracingScreen> {
//   int currentStrokeIndex = 0;
//   late List<bool> strokeCompleted;
//   late List<List<Offset>> userStrokes;
//   bool showCelebration = false;

//   late List<Path> letterPaths;
//   late List<List<Offset>> pathPoints;
//   late Size letterSize;

//   // Track how far along the current path the user has moved (0.0 to 1.0)
//   double currentProgress = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   void _initializeData() {
//     letterSize = widget.letter.getSize();
//     strokeCompleted = List.filled(widget.letter.strokes.length, false);
//     userStrokes = List.generate(widget.letter.strokes.length, (_) => []);

//     // Parse SVG paths and pre-calculate points for collision detection
//     letterPaths = widget.letter.strokes
//         .map((stroke) => parseSvgPathData(stroke.path))
//         .toList();

//     pathPoints = letterPaths.map((path) => _extractPathPoints(path)).toList();
//   }

//   List<Offset> _extractPathPoints(Path path) {
//     List<Offset> points = [];
//     for (final metric in path.computeMetrics()) {
//       for (double d = 0; d <= metric.length; d += 2.0) {
//         points.add(metric.getTangentForOffset(d)!.position);
//       }
//     }
//     return points;
//   }

//   double calculateFitScale(Size availableSize, Size svgSize) {
//     // Calculate scale factors for both dimensions
//     double scaleX = availableSize.width / svgSize.width;
//     double scaleY = availableSize.height / svgSize.height;

//     // Use the smaller scale factor to ensure it fits within both boundaries
//     return math.min(scaleX, scaleY);
//   }

//   void _handlePanUpdate(Offset localPos, Size drawSize) {
//     if (currentStrokeIndex >= widget.letter.strokes.length) return;

//     // 1. Calculate Uniform Scale
//     double scale = math.min(
//       drawSize.width / letterSize.width,
//       drawSize.height / letterSize.height,
//     );

//     // 2. Calculate Offsets (Centering)
//     double dx = (drawSize.width - (letterSize.width * scale)) / 2;
//     double dy = (drawSize.height - (letterSize.height * scale)) / 2;

//     // 3. Convert Local Touch to SVG Coordinates
//     // Formula: (TouchPoint - Offset) / Scale
//     Offset scaledUserPoint = Offset(
//       (localPos.dx - dx) / scale,
//       (localPos.dy - dy) / scale,
//     );

//     List<Offset> targetPoints = pathPoints[currentStrokeIndex];
//     int closestPointIndex = -1;
//     double minDistance = 35.0; // Tolerance

//     for (int i = 0; i < targetPoints.length; i++) {
//       double dist = (scaledUserPoint - targetPoints[i]).distance;
//       if (dist < minDistance) {
//         minDistance = dist;
//         closestPointIndex = i;
//       }
//     }

//     if (closestPointIndex != -1) {
//       double progress = closestPointIndex / targetPoints.length;
//       if (progress >= currentProgress - 0.1) {
//         if (progress > currentProgress) {
//           setState(() {
//             currentProgress = progress;
//             userStrokes[currentStrokeIndex].add(localPos);
//           });
//         }
//       }
//     }
//   }

//   void _onPanEnd() {
//     if (currentStrokeIndex >= widget.letter.strokes.length) return;

//     if (currentProgress > 0.85) {
//       setState(() {
//         strokeCompleted[currentStrokeIndex] = true;
//         // CRITICAL: Clear the user's hand-drawn points so they disappear
//         // and get replaced by the perfect template path
//         userStrokes[currentStrokeIndex].clear();
//         currentProgress = 0.0;

//         if (currentStrokeIndex < widget.letter.strokes.length - 1) {
//           currentStrokeIndex++;
//         } else {
//           showCelebration = true;
//         }
//       });
//     } else {
//       setState(() {
//         userStrokes[currentStrokeIndex].clear();
//         currentProgress = 0.0;
//       });
//     }
//   }

//   void _resetTracing() {
//     setState(() {
//       currentStrokeIndex = 0;
//       currentProgress = 0.0;
//       showCelebration = false;
//       strokeCompleted.fillRange(0, strokeCompleted.length, false);
//       for (var stroke in userStrokes) {
//         stroke.clear();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F7),
//       appBar: AppBar(
//         title: Text('Trace ${widget.letter.letter}'),
//         backgroundColor: Colors.deepOrange,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _resetTracing),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildProgressBar(),
//           Expanded(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 double canvasSize =
//                     math.min(constraints.maxWidth, constraints.maxHeight) * 0.8;
//                 Size drawSize = Size(
//                   canvasSize,
//                   canvasSize * (letterSize.height / letterSize.width),
//                 );
//                 log('drawSize: $drawSize');

//                 return GestureDetector(
//                   onPanUpdate: (d) =>
//                       _handlePanUpdate(d.localPosition, drawSize),
//                   onPanEnd: (_) => _onPanEnd(),
//                   child: Container(
//                     color: Colors.red,
//                     width: drawSize.width,
//                     height: drawSize.height,
//                     child: CustomPaint(
//                       size: drawSize,
//                       painter: LetterPainter(
//                         letterPaths: letterPaths,
//                         pathPoints: pathPoints,
//                         userStrokes: userStrokes,
//                         strokeCompleted: strokeCompleted,
//                         currentStrokeIndex: currentStrokeIndex,
//                         letterSize: letterSize,
//                         currentProgress: currentProgress,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           _buildInstructionFooter(),
//         ],
//       ),
//     );
//   }

//   Widget _buildProgressBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       color: Colors.deepOrange,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(widget.letter.strokes.length, (index) {
//           bool isDone = strokeCompleted[index];
//           bool isCurrent = index == currentStrokeIndex;
//           return isCurrent
//               ? Icon(Icons.safety_check)
//               : Icon(
//                   Icons.check,
//                   size: 20,
//                   color: isDone ? Colors.green : Colors.white,
//                 );
//         }),
//       ),
//     );
//   }

//   Widget _buildInstructionFooter() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       child: Text(
//         currentStrokeIndex < widget.letter.strokes.length
//             ? widget.letter.strokes[currentStrokeIndex].instruction
//             : "Well done!",
//         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
// }

// class LetterPainter extends CustomPainter {
//   final List<Path> letterPaths;
//   final List<List<Offset>> pathPoints;
//   final List<List<Offset>> userStrokes;
//   final List<bool> strokeCompleted;
//   final int currentStrokeIndex;
//   final Size letterSize;
//   final double currentProgress;

//   LetterPainter({
//     required this.letterPaths,
//     required this.pathPoints,
//     required this.userStrokes,
//     required this.strokeCompleted,
//     required this.currentStrokeIndex,
//     required this.letterSize,
//     required this.currentProgress,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     // 1. Calculate the scale based on the ACTUAL path bounds, not the JSON viewBox
//     double scale = math.min(
//       size.width / letterSize.width,
//       size.height / letterSize.height,
//     );

//     // 2. Center it
//     double dx = (size.width - (letterSize.width * scale)) / 2;
//     double dy = (size.height - (letterSize.height * scale)) / 2;

//     final Matrix4 matrix = Matrix4.identity()
//       ..translate(dx, dy)
//       ..scale(scale, scale);

//     // 3. Drawing strokes
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.round;

//     for (int i = 0; i < letterPaths.length; i++) {
//       // Ghost Template
//       paint.color = Colors.grey.shade300;
//       paint.strokeWidth = 25;
//       canvas.drawPath(letterPaths[i].transform(matrix.storage), paint);

//       // Completed Fill
//       if (strokeCompleted[i]) {
//         paint.color = Colors.green;
//         canvas.drawPath(letterPaths[i].transform(matrix.storage), paint);
//       }
//     }

//     // 4. User Ink (Drawn in screen pixels, no matrix needed)
//     if (currentStrokeIndex < userStrokes.length &&
//         userStrokes[currentStrokeIndex].isNotEmpty) {
//       final inkPaint = Paint()
//         ..color = Colors.blue
//         ..strokeWidth = 25
//         ..style = PaintingStyle.stroke
//         ..strokeCap = StrokeCap.round;

//       final userPath = Path()
//         ..addPolygon(userStrokes[currentStrokeIndex], false);
//       canvas.drawPath(userPath, inkPaint);
//     }
//     // 4. Draw Hint for current stroke start
//     if (currentStrokeIndex < pathPoints.length &&
//         !strokeCompleted[currentStrokeIndex]) {
//       final startPt = pathPoints[currentStrokeIndex].first;

//       // Pulse effect or simple circle
//       canvas.drawCircle(
//         Offset(startPt.dx * scale, startPt.dy * scale),
//         12,
//         Paint()..color = Colors.orange.withOpacity(0.3),
//       );
//       canvas.drawCircle(
//         Offset(startPt.dx * scale, startPt.dy * scale),
//         6,
//         Paint()..color = Colors.orange,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant LetterPainter oldDelegate) => true;
// }


import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onepali/src/features/lessons/models/nepali_letter.dart';
import 'package:path_drawing/path_drawing.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class TracingScreen extends StatefulWidget {
  final NepaliLetter letter;

  const TracingScreen({super.key, required this.letter});

  @override
  State<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends State<TracingScreen>
    with SingleTickerProviderStateMixin {
  int currentStrokeIndex = 0;
  late List<bool> strokeCompleted;
  late List<List<Offset>> userStrokes;
  bool showCelebration = false;

  late List<Path> letterPaths;
  late List<List<Offset>> pathPoints;
  late Size letterSize;
  late Rect letterBounds;

  // Track how far along the current path the user has moved (0.0 to 1.0)
  double currentProgress = 0.0;

  // Animation controller for hints
  late AnimationController _hintController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupAnimations();
  }

  void _setupAnimations() {
    _hintController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
  }

  void _initializeData() {
    // Parse SVG paths
    letterPaths = widget.letter.strokes
        .map((stroke) => parseSvgPathData(stroke.path))
        .toList();

    // Calculate the actual bounds of all paths combined
    letterBounds = _calculateCombinedBounds(letterPaths);

    // Normalize paths to start from (0,0) and store normalized size
    letterSize = Size(letterBounds.width, letterBounds.height);
    
    // Normalize all paths to start from origin
    for (int i = 0; i < letterPaths.length; i++) {
      letterPaths[i] = letterPaths[i].shift(Offset(-letterBounds.left, -letterBounds.top));
    }

    // Extract points for collision detection
    pathPoints = letterPaths.map((path) => _extractPathPoints(path)).toList();

    // Initialize tracking arrays
    strokeCompleted = List.filled(widget.letter.strokes.length, false);
    userStrokes = List.generate(widget.letter.strokes.length, (_) => []);
  }

  Rect _calculateCombinedBounds(List<Path> paths) {
    if (paths.isEmpty) return Rect.zero;

    Rect? combinedBounds;
    for (var path in paths) {
      final bounds = path.getBounds();
      if (combinedBounds == null) {
        combinedBounds = bounds;
      } else {
        combinedBounds = combinedBounds.expandToInclude(bounds);
      }
    }
    return combinedBounds ?? Rect.zero;
  }

  List<Offset> _extractPathPoints(Path path) {
    List<Offset> points = [];
    for (final metric in path.computeMetrics()) {
      // Sample more densely for better accuracy
      double step = math.max(1.0, metric.length / 200);
      for (double d = 0; d <= metric.length; d += step) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent != null) {
          points.add(tangent.position);
        }
      }
    }
    return points;
  }

  void _handlePanUpdate(Offset localPos, Size drawSize) {
    if (currentStrokeIndex >= widget.letter.strokes.length) return;
    if (strokeCompleted[currentStrokeIndex]) return;

    // 1. Calculate Uniform Scale
    double scale = math.min(
      drawSize.width / letterSize.width,
      drawSize.height / letterSize.height,
    );

    // 2. Calculate Offsets (Centering)
    double dx = (drawSize.width - (letterSize.width * scale)) / 2;
    double dy = (drawSize.height - (letterSize.height * scale)) / 2;

    // 3. Convert Local Touch to SVG Coordinates
    Offset scaledUserPoint = Offset(
      (localPos.dx - dx) / scale,
      (localPos.dy - dy) / scale,
    );

    List<Offset> targetPoints = pathPoints[currentStrokeIndex];
    if (targetPoints.isEmpty) return;

    int closestPointIndex = -1;
    double minDistance = double.infinity;

    // Dynamic tolerance based on letter size
    double tolerance = math.max(20.0, letterSize.width * 0.15);

    for (int i = 0; i < targetPoints.length; i++) {
      double dist = (scaledUserPoint - targetPoints[i]).distance;
      if (dist < minDistance) {
        minDistance = dist;
        closestPointIndex = i;
      }
    }

    if (closestPointIndex != -1 && minDistance < tolerance) {
      double progress = closestPointIndex / targetPoints.length;
      
      // Allow some backtracking but prevent jumping too far ahead
      if (progress >= currentProgress - 0.15 && progress <= currentProgress + 0.3) {
        setState(() {
          if (progress > currentProgress) {
            currentProgress = progress;
          }
          userStrokes[currentStrokeIndex].add(localPos);
        });
      }
    }
  }

  void _handlePanStart(Offset localPos, Size drawSize) {
    if (currentStrokeIndex >= widget.letter.strokes.length) return;
    if (strokeCompleted[currentStrokeIndex]) return;

    // Clear previous attempt
    setState(() {
      userStrokes[currentStrokeIndex].clear();
      currentProgress = 0.0;
    });
  }

  void _onPanEnd() {
    if (currentStrokeIndex >= widget.letter.strokes.length) return;
    if (strokeCompleted[currentStrokeIndex]) return;

    // More lenient completion threshold
    if (currentProgress > 0.75) {
      setState(() {
        strokeCompleted[currentStrokeIndex] = true;
        // Clear user strokes to show clean template
        userStrokes[currentStrokeIndex].clear();
        currentProgress = 0.0;

        if (currentStrokeIndex < widget.letter.strokes.length - 1) {
          currentStrokeIndex++;
        } else {
          showCelebration = true;
          _hintController.stop();
        }
      });

      // Haptic feedback
      HapticFeedback.mediumImpact();
    } else {
      // Failed attempt - clear and let user try again
      setState(() {
        userStrokes[currentStrokeIndex].clear();
        currentProgress = 0.0;
      });

      // Light haptic feedback for failed attempt
      HapticFeedback.lightImpact();
    }
  }

  void _resetTracing() {
    setState(() {
      currentStrokeIndex = 0;
      currentProgress = 0.0;
      showCelebration = false;
      strokeCompleted.fillRange(0, strokeCompleted.length, false);
      for (var stroke in userStrokes) {
        stroke.clear();
      }
    });
    _hintController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text('Trace ${widget.letter.letter}'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetTracing,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Use 85% of available space with padding
                  double maxSize = math.min(
                    constraints.maxWidth * 0.85,
                    constraints.maxHeight * 0.85,
                  );

                  // Maintain aspect ratio
                  double aspectRatio = letterSize.width / letterSize.height;
                  Size drawSize;

                  if (aspectRatio > 1) {
                    // Wider than tall
                    drawSize = Size(maxSize, maxSize / aspectRatio);
                  } else {
                    // Taller than wide
                    drawSize = Size(maxSize * aspectRatio, maxSize);
                  }

                  return GestureDetector(
                    onPanStart: (d) => _handlePanStart(d.localPosition, drawSize),
                    onPanUpdate: (d) => _handlePanUpdate(d.localPosition, drawSize),
                    onPanEnd: (_) => _onPanEnd(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      width: drawSize.width+15,
                      height: drawSize.height+15,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              size: drawSize,
                              painter: LetterPainter(
                                letterPaths: letterPaths,
                                pathPoints: pathPoints,
                                userStrokes: userStrokes,
                                strokeCompleted: strokeCompleted,
                                currentStrokeIndex: currentStrokeIndex,
                                letterSize: letterSize,
                                currentProgress: currentProgress,
                                pulseValue: _pulseAnimation.value,
                                showCelebration: showCelebration,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _buildInstructionFooter(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Stroke ${currentStrokeIndex + 1} of ${widget.letter.strokes.length}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.letter.strokes.length, (index) {
              bool isDone = strokeCompleted[index];
              bool isCurrent = index == currentStrokeIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDone
                        ? Colors.green
                        : isCurrent
                            ? Colors.deepOrange
                            : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isCurrent ? Colors.white : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              );
            }),
          ),
          if (currentProgress > 0 && !strokeCompleted[currentStrokeIndex])
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: currentProgress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                  minHeight: 6,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInstructionFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (showCelebration)
            Column(
              children: [
                const Icon(Icons.celebration, color: Colors.amber, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Excellent! You traced ${widget.letter.letter}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          else
            Text(
              currentStrokeIndex < widget.letter.strokes.length
                  ? widget.letter.strokes[currentStrokeIndex].instruction
                  : "Well done!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class LetterPainter extends CustomPainter {
  final List<Path> letterPaths;
  final List<List<Offset>> pathPoints;
  final List<List<Offset>> userStrokes;
  final List<bool> strokeCompleted;
  final int currentStrokeIndex;
  final Size letterSize;
  final double currentProgress;
  final double pulseValue;
  final bool showCelebration;

  LetterPainter({
    required this.letterPaths,
    required this.pathPoints,
    required this.userStrokes,
    required this.strokeCompleted,
    required this.currentStrokeIndex,
    required this.letterSize,
    required this.currentProgress,
    required this.pulseValue,
    required this.showCelebration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate scale and translation
    double scale = math.min(
      size.width / letterSize.width,
      size.height / letterSize.height,
    );

    double dx = (size.width - (letterSize.width * scale)) / 2;
    double dy = (size.height - (letterSize.height * scale)) / 2;

    final Matrix4 matrix = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale, scale);

    // Paint setup
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw all strokes
    for (int i = 0; i < letterPaths.length; i++) {
      final transformedPath = letterPaths[i].transform(matrix.storage);

      // Ghost template (always show for incomplete strokes)
      if (!strokeCompleted[i]) {
        paint.color = Colors.grey.shade200;
        paint.strokeWidth = 28 * scale;
        canvas.drawPath(transformedPath, paint);

        // Lighter guide for non-current strokes
        if (i != currentStrokeIndex) {
          paint.color = Colors.grey.shade100;
          paint.strokeWidth = 24 * scale;
          canvas.drawPath(transformedPath, paint);
        }
      }

      // Completed strokes - show in green
      if (strokeCompleted[i]) {
        paint.color = Colors.green.withOpacity(0.9);
        paint.strokeWidth = 26 * scale;
        canvas.drawPath(transformedPath, paint);
      }
    }

    // Draw user's current stroke
    if (currentStrokeIndex < userStrokes.length &&
        userStrokes[currentStrokeIndex].isNotEmpty &&
        !strokeCompleted[currentStrokeIndex]) {
      final inkPaint = Paint()
        ..color = Colors.deepOrange
        ..strokeWidth = 24 * scale
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final userPath = Path();
      for (int i = 0; i < userStrokes[currentStrokeIndex].length; i++) {
        final point = userStrokes[currentStrokeIndex][i];
        if (i == 0) {
          userPath.moveTo(point.dx, point.dy);
        } else {
          userPath.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(userPath, inkPaint);
    }

    // Draw start hint for current stroke
    if (currentStrokeIndex < pathPoints.length &&
        !strokeCompleted[currentStrokeIndex] &&
        pathPoints[currentStrokeIndex].isNotEmpty) {
      final startPt = pathPoints[currentStrokeIndex].first;
      final screenStartPt = Offset(
        startPt.dx * scale + dx,
        startPt.dy * scale + dy,
      );

      // Pulsing outer circle
      canvas.drawCircle(
        screenStartPt,
        16 * pulseValue,
        Paint()
          ..color = Colors.deepOrange.withOpacity(0.3 * pulseValue)
          ..style = PaintingStyle.fill,
      );

      // Inner solid circle
      canvas.drawCircle(
        screenStartPt,
        8,
        Paint()
          ..color = Colors.deepOrange
          ..style = PaintingStyle.fill,
      );

      // White center
      canvas.drawCircle(
        screenStartPt,
        4,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
    }

    // Draw directional arrow for current stroke
    if (currentStrokeIndex < pathPoints.length &&
        !strokeCompleted[currentStrokeIndex] &&
        pathPoints[currentStrokeIndex].length > 10) {
      _drawDirectionArrow(canvas, pathPoints[currentStrokeIndex], scale, dx, dy);
    }

    // Celebration effect
    if (showCelebration) {
      _drawCelebration(canvas, size);
    }
  }

  void _drawDirectionArrow(Canvas canvas, List<Offset> points, double scale, double dx, double dy) {
    if (points.length < 20) return;

    // Get a point about 20% along the path
    int arrowIndex = (points.length * 0.2).toInt();
    final arrowStart = points[arrowIndex];
    final arrowEnd = points[math.min(arrowIndex + 5, points.length - 1)];

    final screenStart = Offset(arrowStart.dx * scale + dx, arrowStart.dy * scale + dy);
    final screenEnd = Offset(arrowEnd.dx * scale + dx, arrowEnd.dy * scale + dy);

    // Draw arrow
    final arrowPaint = Paint()
      ..color = Colors.deepOrange.withOpacity(0.6)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(screenStart, screenEnd, arrowPaint);

    // Draw arrowhead
    final angle = math.atan2(screenEnd.dy - screenStart.dy, screenEnd.dx - screenStart.dx);
    final arrowSize = 12.0;

    final path = Path()
      ..moveTo(screenEnd.dx, screenEnd.dy)
      ..lineTo(
        screenEnd.dx - arrowSize * math.cos(angle - math.pi / 6),
        screenEnd.dy - arrowSize * math.sin(angle - math.pi / 6),
      )
      ..moveTo(screenEnd.dx, screenEnd.dy)
      ..lineTo(
        screenEnd.dx - arrowSize * math.cos(angle + math.pi / 6),
        screenEnd.dy - arrowSize * math.sin(angle + math.pi / 6),
      );

    canvas.drawPath(path, arrowPaint..style = PaintingStyle.stroke);
  }

  void _drawCelebration(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Simple confetti effect
    final random = math.Random(42); // Fixed seed for consistent animation
    for (int i = 0; i < 20; i++) {
      paint.color = [Colors.amber, Colors.green, Colors.blue, Colors.red][i % 4]
          .withOpacity(0.6);
      
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        4,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LetterPainter oldDelegate) {
    return currentProgress != oldDelegate.currentProgress ||
        currentStrokeIndex != oldDelegate.currentStrokeIndex ||
        pulseValue != oldDelegate.pulseValue ||
        showCelebration != oldDelegate.showCelebration;
  }
}