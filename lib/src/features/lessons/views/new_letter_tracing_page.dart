import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/letter_tracing_bloc/letter_tracing_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/letter_painter.dart';
import 'package:onepali/src/src.dart';

class NewLetterTracingPage extends StatefulWidget {
  const NewLetterTracingPage({super.key, required this.content});
  final CharTracingLessonContent content;

  @override
  State<NewLetterTracingPage> createState() => _NewLetterTracingPageState();
}

class _NewLetterTracingPageState extends State<NewLetterTracingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pointerAnimationController;
  late Animation<double> _pointerAnimation;

  @override
  void initState() {
    super.initState();
    // Animation for pulsing pointer
    _pointerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pointerAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pointerAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pointerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) =>
          LetterTracingBloc()..add(LetterTracingEvent.started(widget.content)),
      child: Scaffold(
        body: BlocConsumer<LetterTracingBloc, LetterTracingState>(
          listener: (context, state) {
            // Show feedback messages
            if (state.feedbackMessage != null) {}

            // Celebrate completion
            if (state.isLetterComplete) {}
          },
          builder: (context, state) {
            if (state.letter == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SizedBox(
              width: size.width,
              height: size.height,
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // Header with progress
                        const Spacer(),
                        // Main tracing area
                        Center(child: _buildTracingArea(context, state, size)),
                        SizedBox(height: size.height * 0.02),
                        // Stroke indicators at bottom
                        _buildStrokeIndicators(state),
                        Spacer(),
                      ],
                    ),
                    TopRightPositionedCloseButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    if (state.isLetterComplete)
                      CenterRightAlignedForwardButton(
                        onTap: () {
                          context.read<LessonBloc>().add(
                            const LessonEvent.nextContent(),
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTracingArea(
    BuildContext context,
    LetterTracingState state,
    Size size,
  ) {
    return Center(
      child: GestureDetector(
        onPanStart: (details) {
          context.read<LetterTracingBloc>().add(
            LetterTracingEvent.onPanStart(details.localPosition),
          );
        },
        onPanUpdate: (details) {
          context.read<LetterTracingBloc>().add(
            LetterTracingEvent.onPanUpdate(details.localPosition),
          );
        },
        onPanEnd: (details) {
          context.read<LetterTracingBloc>().add(
            LetterTracingEvent.onPanEnd(
              Offset.zero,
            ), // Position not needed on end
          );
        },
        child: SizedBox(
          width: state.letterSize.width,
          height: state.letterSize.height,
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: CustomPaint(painter: BackgroundPatternPainter()),
              ),

              // Letter tracing
              AnimatedBuilder(
                animation: _pointerAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(
                      state.letterSize.width * 0.3,
                      state.letterSize.height * 0.3,
                    ),
                    painter: LetterPainter(
                      strokeWidth: state.strokeWidth,
                      letterPaths: state.letterPaths,
                      outlinePath: state.outlinePath,
                      completedPaths: state.completedPaths,
                      pathsPoints: state.pathsPoints,
                      userStrokes: state.userStrokes,
                      currentPathIndex: state.currentStrokeIndex,
                      currentStrokeProgress: state.currentStrokeProgress,
                      isTracingOutsideBounds: state.isTracingOutsideBounds,
                      showPointer: state.showPointer,
                      pointerPosition: state.pointerPosition,
                      showGuideDots: state.showGuideDots,
                      showStrokeDirection: state.showStrokeDirection,
                      strokeBoundingBoxes: state.strokeBoundingBoxes,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrokeIndicators(LetterTracingState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(state.numberOfStrokes, (index) {
        final isComplete = index < state.currentStrokeIndex;
        final isCurrent = index == state.currentStrokeIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCurrent ? 50 : 40,
            height: isCurrent ? 50 : 40,

            child: Center(
              child: Icon(
                isComplete ? Icons.star : Icons.star_outline,
                color: AppColors.kOrange,
                size: 32,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// Background pattern painter
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw subtle grid
    const spacing = 30.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
