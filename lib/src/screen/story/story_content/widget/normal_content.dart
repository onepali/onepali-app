import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';

// Normal UI
class NormalContent extends StatefulWidget {
  final Content content;
  final bool playAudio;
  const NormalContent({
    super.key,
    required this.content,
    this.playAudio = true,
  });
  @override
  State<NormalContent> createState() => _NormalContentState();
}

class _NormalContentState extends State<NormalContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    Widget arrowButton({required bool isLeft, required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.kBlack.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: SvgHelper.fromSource(
            path: isLeft ? Assets.leftArrow : Assets.rightArrow,
            height: 36,
            width: 36,
          ),
        ),
      );
    }

    return Stack(
      children: [
        if (widget.content.image.isNotEmpty)
          Positioned.fill(
            // bottom: 50,
            child: CustomImage(
              widget.content.image,
              imageType: CustomImageType.network,
              boxFit: BoxFit.cover,
            ),
          ),
        // Top center sound icon
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: Center(
            child: Consumer<StoryProvider>(
              builder: (context, storyProvider, _) {
                final soundIcon = GestureDetector(
                  onTap: () {
                    logger.d(
                      '[NormalContent] Sound icon tapped, isPlaying: \\${storyProvider.isPlaying}',
                    );
                    storyProvider.playAudio(widget.content.audio);
                  },
                  child: SvgHelper.fromSource(path: Assets.sound, height: 40),
                );
                return storyProvider.isPlaying
                    ? CustomAvatarGlow(child: soundIcon)
                    : soundIcon;
              },
            ),
          ),
        ),
        // Top right wrong icon
        Positioned(
          top: 24,
          right: 24,
          child: customInkwell(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              storyProvider.stopAudioAndResetIndex();
              logger.d('[NormalContent] Wrong icon tapped, stopping audio');
            },
            child: SvgHelper.fromSource(path: Assets.wrong, height: 45),
          ),
        ),
        // Left arrow (center vertically)
        Positioned(
          left: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: arrowButton(
              isLeft: true,
              onTap: () => storyProvider.previousContent(),
            ),
          ),
        ),
        // Right arrow (center vertically)
        Positioned(
          right: 25,
          top: 0,
          bottom: 0,
          child: Center(
            child: arrowButton(
              isLeft: false,
              onTap: () => storyProvider.nextContent(context),
            ),
          ),
        ),
        // Bottom white background with text
        Align(
          alignment: Alignment.bottomCenter,
          child: Consumer<StoryProvider>(
            builder: (context, storyProvider, _) {
              // Prepare conversation rows based on current audio index
              List<Widget> messageWidgets = [];

              // Only show the conversation message corresponding to the current audio index
              final currentAudioIndex = storyProvider.currentAudioIndex;

              // Ensure we have conversations and the index is valid
              if (widget.content.conversation.isNotEmpty &&
                  currentAudioIndex < widget.content.conversation.length) {
                final conversation =
                    widget.content.conversation[currentAudioIndex];

                final String iconPath = conversation.icon;
                String messageNp = conversation.messageNp;
                final colonIdx = messageNp.indexOf(':');
                if (colonIdx != -1) {
                  messageNp = messageNp.substring(colonIdx + 1).trimLeft();
                }
                // Split on \n for multi-line
                final lines = messageNp.split('\n');
                for (var i = 0; i < lines.length; i++) {
                  messageWidgets.add(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (iconPath.isNotEmpty && i == 0)
                          SvgHelper.fromSource(
                            path: iconPath,
                            height: 26,
                            width: 26,
                            type: SvgSourceType.network,
                          ),
                        if (iconPath.isNotEmpty && i == 0)
                          Gaps.horizontalGapOf(12.0),
                        Text(
                          lines[i],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.text20PxMedium.copyWith(
                            fontFamily: 'Mukta',
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }

              return Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: messageWidgets,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
