import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StoryContentCard extends StatelessWidget {
  final Content content;
  final VoidCallback? onConfetti;
  final bool isLast;
  const StoryContentCard({
    super.key,
    required this.content,
    this.onConfetti,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return buildStoryContentWidget(
      content: content,
      onConfetti: onConfetti,
      isLast: isLast,
    );
  }
}

// Normal Confetti UI
class NormalConfettiContent extends StatelessWidget {
  final Content content;
  final VoidCallback? onConfetti;
  final bool isLast;
  const NormalConfettiContent({
    super.key,
    required this.content,
    this.onConfetti,
    required this.isLast,
  });
  @override
  Widget build(BuildContext context) {
    // For demo, just show a confetti icon if isLast or confetti is not empty
    final showConfetti = isLast || (content.confetti.isNotEmpty);
    return Stack(
      alignment: Alignment.center,
      children: [
        NormalContent(content: content),
        if (showConfetti)
          LottieHelper.fromSource(
            path: content.confetti,
            repeat: true,
            type: LottieSourceType.network,
          ),
      ],
    );
  }
}
