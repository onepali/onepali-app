
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/bloc/letter_tracing_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/src.dart';

class NewLetterTracingPage extends StatelessWidget {
  const NewLetterTracingPage({super.key, required this.content});
  // final NepaliLetter? letter;
  final CharTracingLessonContent content;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) =>
          LetterTracingBloc()..add(LetterTracingEvent.started(content)),
      child: Scaffold(
        body: BlocBuilder<LetterTracingBloc, LetterTracingState>(
          builder: (context, state) {
            if (state.letter == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  color: Colors.white,
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            // Move GestureDetector here
                            onPanStart: (details) {
                              context.read<LetterTracingBloc>().add(
                                LetterTracingEvent.onPanStart(
                                  details.localPosition,
                                ),
                              );
                            },
                            onPanUpdate: (details) {
                              context.read<LetterTracingBloc>().add(
                                LetterTracingEvent.onPanUpdate(
                                  details.localPosition,
                                ),
                              );
                            },
                            onPanEnd: (details) {
                              context.read<LetterTracingBloc>().add(
                                LetterTracingEvent.onPanEnd(
                                  details.localPosition,
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.white,
                              width: state.letterSize.width,
                              height: state.letterSize.height,
                              child: Stack(
                                children: [
                                  CustomPaint(
                                    painter: LetterPainter(
                                      strokeWidth: state.strokeWidth,
                                      letterPaths: state.letterPaths,
                                      completedPaths: state.completedPaths,
                                      pathsPoints: state.pathsPoints,
                                      userStrokes: state.userStrokes,
                                      currentPathIndex:
                                          state.currentStrokeIndex,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: state.letterPaths.map((p) {
                              final isComplete = state.completedPaths.contains(
                                p,
                              );
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Icon(
                                  isComplete ? Icons.star : Icons.star_outline,
                                  color: Colors.amber,
                                  size: 40,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      Positioned(
                        top: size.height * 0.05,
                        right: size.width * 0.05,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgHelper.fromSource(path: Assets.wrong),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class LetterPainter extends CustomPainter {
  final double? strokeWidth;
  final List<Path> letterPaths;
  final List<Path> completedPaths;
  final List<List<Offset>> pathsPoints;
  final List<Offset> userStrokes;
  final int currentPathIndex;

  LetterPainter({
    super.repaint,
    required this.letterPaths,
    required this.completedPaths,
    required this.pathsPoints,
    required this.userStrokes,
    required this.currentPathIndex,
    this.strokeWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = this.strokeWidth ?? 20.0;
    //---------------Draw letter-------------------
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round;
    for (var i = 0; i < letterPaths.length; i++) {
      final isCompleted = completedPaths.contains(letterPaths[i]);
      final isActive = i == currentPathIndex;
      paint.color = isActive
          ? Colors.red
          : isCompleted
          ? Colors.green
          : Colors.grey;
      paint.strokeWidth = strokeWidth;
      canvas.drawPath(letterPaths[i], paint);
    }
    // ---------------Draw user strokes---------------
    final inkPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final userPath = Path();
    for (int i = 0; i < userStrokes.length; i++) {
      final point = userStrokes[i];
      if (i == 0) {
        userPath.moveTo(point.dx, point.dy);
      } else {
        userPath.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(userPath, inkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
