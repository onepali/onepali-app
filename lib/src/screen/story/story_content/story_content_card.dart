import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StoryContentCard extends StatelessWidget {
  final Content content;
  final VoidCallback? onConfetti;
  final bool isLast;
  final bool playAudio;
  const StoryContentCard({
    super.key,
    required this.content,
    this.onConfetti,
    this.isLast = false,
    this.playAudio = true,
  });

  @override
  Widget build(BuildContext context) {
    return buildStoryContentWidget(
      content: content,
      onConfetti: onConfetti,
      isLast: isLast,
      playAudio: playAudio,
    );
  }
}

// Normal Confetti UI
class NormalConfettiContent extends StatelessWidget {
  final Content content;
  final VoidCallback? onConfetti;
  final bool isLast;
  final bool playAudio;
  const NormalConfettiContent({
    super.key,
    required this.content,
    this.onConfetti,
    required this.isLast,
    this.playAudio = true,
  });
  @override
  Widget build(BuildContext context) {
    final showConfetti = isLast || (content.confetti.isNotEmpty);
    logger.d('showConfetti: ${content.confetti} $showConfetti');
    return Stack(
      alignment: Alignment.center,
      children: [
        NormalContent(content: content, playAudio: playAudio),
        if (showConfetti)
          IgnorePointer(
            child: LottieHelper.fromSource(
            path: content.confetti,
            fit: BoxFit.cover,
            repeat: true,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height,
            type: LottieSourceType.network,
            ),
          ),
      ],
    );
  }
}
