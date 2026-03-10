import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/penalty_slide_view.dart';

class PenaltySlider extends StatefulWidget {
  final GameSliderConfig config;
  final BallSlideLessonContent content;
  const PenaltySlider({super.key, required this.config, required this.content});

  @override
  State<PenaltySlider> createState() => _PenaltySliderState();
}

class _PenaltySliderState extends State<PenaltySlider>
    with SingleTickerProviderStateMixin {
  /// Negative = left path, positive = right path, 0 = resting centre
  double _ballProgress = 0.0;

  final _audioPlayerService = AudioPlayerServiceImpl();

  late AnimationController _snapCtrl;
  late Animation<double> _snapAnim;
  double _snapFrom = 0.0;
  double _snapTarget = 0.0;

  bool _showGoal = false;

  @override
  void initState() {
    super.initState();
    _snapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _snapAnim = CurvedAnimation(parent: _snapCtrl, curve: Curves.easeOutCubic);
    _snapAnim.addListener(() {
      setState(() {
        _ballProgress = _lerp(_snapFrom, _snapTarget, _snapAnim.value);
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (final audio in widget.content.conversation) {
        _audioPlayerService.play(audio);
        await _audioPlayerService.onPlayerComplete.first;
      }
    });
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    _snapCtrl.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _snapFrom = _ballProgress;
    _snapTarget = target;
    _snapCtrl.forward(from: 0);
  }

  void _onPanEnd() {
    log("Ball progress at pan end: $_ballProgress");
    final double p = _ballProgress.abs();
    if (p > 0.85) {
      _animateTo(_ballProgress < 0 ? -1.0 : 1.0);
      Future.delayed(const Duration(milliseconds: 420), () {
        if (mounted) setState(() => _showGoal = true);
      });
    } else if (p > 0.04) {
      _animateTo(0.0);
    }
  }

  void _reset() => setState(() {
    _showGoal = false;
    _ballProgress = 0.0;
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);

    final ballSize = isMobile ? 70.0 : 120.0;
    final trackHeight = isMobile ? 52.0 : 80.0;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final leftPath = _buildPath(size, true);
        final rightPath = _buildPath(size, false);

        return Stack(
          children: [
            // Background
            Positioned.fill(
              child: CustomCachedImage(
                imageUrl: isMobile
                    ? widget.content.bgImageMobile ?? ''
                    : widget.content.bgImageTablet ?? '',
                fit: BoxFit.cover,
              ),
            ),

            // Goal-zone glows
            IgnorePointer(
              child: CustomPaint(
                size: size,
                painter: GoalZonePainter(
                  config: widget.config,
                  progress: _ballProgress,
                ),
              ),
            ),

            // Tracks
            IgnorePointer(
              child: CustomPaint(
                size: size,
                painter: PathPainter(
                  leftPath: leftPath,
                  rightPath: rightPath,
                  progress: _ballProgress,
                  strokeWidth: trackHeight,
                ),
              ),
            ),

            // Ball
            if (!_showGoal)
              _ball(
                size,
                leftPath,
                rightPath,
                widget.content.ballImage ?? '',
                ballSize,
              ),
            if (_showGoal) _showGoalImage(isMobile, _ballProgress > 0),
            // Goal overlay
            // if (_showGoal) _goalOverlay(),
            TopRightPositionedCloseButton(
              onTap: () {
                Navigator.pop(context);
              },
            ),
            CenterRightAlignedForwardButton(
              onTap: () {
                context.read<LessonBloc>().add(LessonEvent.nextContent());
              },
            ),
            CenterLeftAlignedBackButton(
              onTap: () {
                context.read<LessonBloc>().add(LessonEvent.previousContent());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showGoalImage(bool isMobile, bool isRightGoal) {
    final goalImage = isMobile
        ? (isRightGoal
              ? widget.content.goalRightImageMb
              : widget.content.goalLeftImageMb)
        : (isRightGoal
              ? widget.content.goalRightImageTb
              : widget.content.goalLeftImageTb);
    if (goalImage == null) return const SizedBox.shrink();
    return Positioned.fill(
      child: CustomCachedImage(imageUrl: goalImage, fit: BoxFit.cover),
    );
  }

  Widget _ball(
    Size size,
    Path leftPath,
    Path rightPath,
    String ballImage,
    double ballSize,
  ) {
    final bool isLeft = _ballProgress <= 0;
    final double lp = _ballProgress.abs().clamp(0.0, 1.0);
    final Path path = isLeft ? leftPath : rightPath;

    final Offset pos;
    if (lp < 0.001) {
      pos = Offset(size.width * 0.5, size.height * widget.config.startYFactor);
    } else {
      final m = path.computeMetrics().first;
      pos =
          m.getTangentForOffset(m.length * lp)?.position ??
          Offset(size.width * 0.5, size.height * widget.config.startYFactor);
    }

    return Positioned(
      left: pos.dx - (ballSize / 2),
      top: pos.dy - (ballSize / 2),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (d) {
          if (_snapCtrl.isAnimating) _snapCtrl.stop();
          final RenderBox box = context.findRenderObject() as RenderBox;
          final Offset touch = box.globalToLocal(d.globalPosition);
          final bool left = touch.dx < size.width * 0.5;
          final double t = _closestT(left ? leftPath : rightPath, touch);
          setState(() => _ballProgress = left ? -t : t);
        },
        onPanEnd: (_) => _onPanEnd(),
        child: SizedBox(
          width: ballSize,
          height: ballSize,
          child: Center(
            child: CustomCachedImage(
              imageUrl: ballImage,
              width: ballSize,
              height: ballSize,
            ),
          ),
        ),
      ),
    );
  }

  Widget _goalOverlay() => GestureDetector(
    onTap: _reset,
    child: Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '⚽  GOAL!',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: Colors.greenAccent,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 14,
                ),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  double _closestT(Path path, Offset touch) {
    final m = path.computeMetrics().first;
    double minD = double.infinity, bestT = 0;
    for (double t = 0; t <= 1.0; t += 0.005) {
      final d =
          (m.getTangentForOffset(m.length * t)!.position - touch).distance;
      if (d < minD) {
        minD = d;
        bestT = t;
      }
    }
    return bestT;
  }

  Path _buildPath(Size size, bool isLeft) {
    final track = isLeft ? widget.config.leftTrack : widget.config.rightTrack;
    final double sx = size.width * 0.5;
    final double sy = size.height * widget.config.startYFactor;

    final path = Path()..moveTo(sx, sy);
    path.cubicTo(
      sx,
      sy + size.height * 0.05,
      size.width * track.curveWidthFactor,
      size.height * track.curveHeightFactor,
      size.width * track.endXFactor,
      size.height * track.endYFactor,
    );
    return path;
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}

class PathPainter extends CustomPainter {
  final Path leftPath, rightPath;
  final double progress;
  final double strokeWidth;

  const PathPainter({
    required this.leftPath,
    required this.rightPath,
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _draw(canvas, leftPath, progress < 0 ? progress.abs() : 0);
    _draw(canvas, rightPath, progress > 0 ? progress.abs() : 0);
  }

  void _draw(Canvas canvas, Path path, double fillProgress) {
    final metrics = path.computeMetrics().first;

    // background track
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.kButtonGrey.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // filled portion — grows as ball is dragged
    if (fillProgress > 0) {
      final filledPath = metrics.extractPath(0, metrics.length * fillProgress);

      // Thick colour fill
      canvas.drawPath(
        filledPath,
        Paint()
          ..color = AppColors.kButtonGreen
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    // thin white centre line
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.kWhite.withValues(
          alpha: fillProgress > 0 ? 0.85 : 0.38,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant PathPainter old) => old.progress != progress;
}

class GoalZonePainter extends CustomPainter {
  final GameSliderConfig config;
  final double progress;

  const GoalZonePainter({required this.config, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    _glow(canvas, size, config.leftTrack, progress < 0);
    _glow(canvas, size, config.rightTrack, progress > 0);
  }

  void _glow(Canvas canvas, Size size, TrackConfig t, bool active) {
    final c = Offset(size.width * t.endXFactor, size.height * t.endYFactor);
    canvas.drawCircle(
      c,
      58,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.kYellow.withValues(alpha: active ? 0.65 : 0.18),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: c, radius: 58)),
    );
  }

  @override
  bool shouldRepaint(covariant GoalZonePainter old) => old.progress != progress;
}
