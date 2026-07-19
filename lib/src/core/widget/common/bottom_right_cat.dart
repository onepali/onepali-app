import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';

class BottomRightCat extends StatefulWidget {
  const BottomRightCat({super.key});

  @override
  State<BottomRightCat> createState() => _BottomRightCatState();
}

class _BottomRightCatState extends State<BottomRightCat> {
  late final AudioPlayerService _audioPlayerService;

  @override
  void initState() {
    super.initState();
    _audioPlayerService = AudioPlayerServiceImpl();
    _audioPlayerService.playAsset(Assets.goodFeedback);
  }

  @override
  void dispose() {
    _audioPlayerService.stop();
    _audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomRight,
      child: Animate(
        effects: const [ScaleEffect(), ShakeEffect()],
        child: Image.asset(Assets.goodRemark1, height: size.height * 0.4),
      ),
    );
  }
}
