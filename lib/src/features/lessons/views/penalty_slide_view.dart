import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/penalty_slider.dart';

class TrackConfig {
  final double curveWidthFactor;
  final double curveHeightFactor;
  final double endXFactor;
  final double endYFactor;

  const TrackConfig({
    required this.curveWidthFactor,
    required this.curveHeightFactor,
    required this.endXFactor,
    required this.endYFactor,
  });
}

class GameSliderConfig {
  final TrackConfig leftTrack;
  final TrackConfig rightTrack;
  final double startYFactor;

  const GameSliderConfig({
    required this.leftTrack,
    required this.rightTrack,
    this.startYFactor = 0.85,
  });
}

class PenaltySlideView extends StatelessWidget {
  const PenaltySlideView({
    super.key,
    required this.content,
  });
  final BallSlideLessonContent content;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final mobileConfig = GameSliderConfig(
      startYFactor: 0.85,

      leftTrack: TrackConfig(
        endXFactor: 0.35,
        endYFactor: 0.4,
        curveHeightFactor: 0.50,
        curveWidthFactor: 0.25,
      ),
      rightTrack: TrackConfig(
        curveWidthFactor: 0.8,
        curveHeightFactor: 0.35,
        endXFactor: 0.65,
        endYFactor: 0.12,
      ),
    );

    final tabletConfig = GameSliderConfig(
      startYFactor: 0.85,

      leftTrack: TrackConfig(
        endXFactor: 0.35,
        endYFactor: 0.4,
        curveHeightFactor: 0.68,
        curveWidthFactor: 0.25,
      ),
      rightTrack: TrackConfig(
        curveWidthFactor: 0.8,
        curveHeightFactor: 0.35,
        endXFactor: 0.65,
        endYFactor: 0.12,
      ),
    );

    return Scaffold(
      body: PenaltySlider(
        config: isMobile ? mobileConfig : tabletConfig,
        content: content,
      ),
    );
  }
}
