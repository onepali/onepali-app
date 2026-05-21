import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';

/// Bottom right cat image with shake and scale effect and play good feedback audio
/// Use this widget inside stack to show the cat image at the bottom right of the screen
class BottomRightCat extends StatefulWidget {
  const BottomRightCat({super.key});

  @override
  State<BottomRightCat> createState() => _BottomRightCatState();
}

class _BottomRightCatState extends State<BottomRightCat> {
  late AudioPlayerService audioPlayerService;
  @override
  void initState() {
    super.initState();
    audioPlayerService = AudioPlayerServiceImpl();
    playAudio();
  }

  void playAudio() {
    audioPlayerService.playAsset(Assets.goodFeedback);
  }

  @override
  void dispose() {
    audioPlayerService.stop();
    audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomRight,
      child: Animate(
        effects: [ScaleEffect(), ShakeEffect()],
        child: Image.asset(Assets.goodRemark1, height: size.height * 0.4),
      ),
    );
  }
}
