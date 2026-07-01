import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:provider/provider.dart';

import '../../../../src.dart';

// Slide UI
class SlideContent extends StatefulWidget {
  final Content content;
  final bool playAudio;
  const SlideContent({super.key, required this.content, this.playAudio = true});
  @override
  State<SlideContent> createState() => SlideContentState();
}

class SlideContentState extends State<SlideContent> {
  double _position = 0.0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    final char1Width = 120.0;
    final char2Width = 120.0;
    final sliderPadding = 32.0;
    final sliderWidth = screenWidth - sliderPadding * 2;
    final maxPosition = sliderWidth - char1Width;
    // Images: content.characters = [char1, char2]
    // Background image is handled at parent level in story_content_screen.dart
    // to fill the entire screen (appears once)
    final charList = widget.content.characters ?? [];
    final char1 = charList.isNotEmpty ? charList[0] : widget.content.image;
    final char2 = charList.length > 1 ? charList[1] : widget.content.image;
    bool isTabletLandScape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    void handleDrag(double dx) async {
      if (_completed) return;
      setState(() {
        _position += dx;
        if (_position < 0) _position = 0;
        if (_position > maxPosition) _position = maxPosition;
      });
      if (_position >= maxPosition && !_completed) {
        setState(() => _completed = true);
        await Future.delayed(const Duration(milliseconds: 600));
        if (!context.mounted) return;
        if (mounted) storyProvider.nextContent(context);
      }
    }

    return Stack(
      children: [
        // Background image is handled at parent level in story_content_screen.dart
        // to fill the entire screen (appears once)
        // Character 2 (static, right side)
        Positioned(
          right: sliderPadding + char2Width, // Position char2 at the right side
          bottom: 55,
          child: SvgHelper.fromSource(
            path: char2 ?? '',
            height: 30.h(context),
            width: char2Width,
            type: SvgSourceType.network,
          ),
        ),
        // Character 1 (draggable)
        Positioned(
          left: sliderPadding + _position,
          bottom: 70,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              handleDrag(details.delta.dx);
            },
            child: SvgHelper.fromSource(
              path: char1 ?? '',
              height: 25.h(context),
              width: char1Width,
              type: SvgSourceType.network,
            ),
          ),
        ),
        // Top center sound icon
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Consumer<StoryProvider>(
              builder: (context, storyProvider, _) {
                final soundIcon = CircularButtonWidget(
                  onPressed: () {
                    logger.d(
                      '[SlideContent] Sound icon tapped, isPlaying: \\${storyProvider.isPlaying}',
                    );
                    storyProvider.playAudio(widget.content.audio);
                  },
                  type: CircularButtonType.sound,
                );
                return storyProvider.isPlaying
                    ? CustomAvatarGlow(child: soundIcon)
                    : soundIcon;
              },
            ),
          ),
        ),

        TopRightPositionedCloseButton(
          onTap: () {
            storyProvider.stopAudioAndResetIndex();
            Navigator.of(context).pop();
          },
        ),

        CenterLeftAlignedBackButton(
          onTap: () {
            storyProvider.previousContent();
          },
        ),
        // Right arrow (center vertically)
        // Positioned(
        //   right: Dimensions.kIconMargin(context),
        //   top: 0,
        //   bottom: 0,
        //   child: Center(
        //     child: CircularButtonWidget(
        //       type: CircularButtonType.rightArrow,
        //       onPressed: () => storyProvider.nextContent(context),
        //     ),
        //   ),
        // ),
        CenterRightAlignedForwardButton(
          onTap: () => storyProvider.nextContent(context),
        ),
        Positioned(
          left: 32,
          right: 32,
          bottom:
              70, // Same bottom position as Character 1 (the draggable animal)
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _completed ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height:
                        PlatformUtility.isTablet(context) &&
                            PlatformUtility.isLandscape(context)
                        ? 70
                        : 48,
                    decoration: BoxDecoration(
                      color: AppColors.kBlack.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(
                        PlatformUtility.isTablet(context) &&
                                PlatformUtility.isLandscape(context)
                            ? 35
                            : 24,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12 + _position,
                    child: SvgHelper.fromSource(
                      path: Assets.rightArrow,
                      height:
                          PlatformUtility.isTablet(context) &&
                              PlatformUtility.isLandscape(context)
                          ? 70
                          : 44,
                      width:
                          PlatformUtility.isTablet(context) &&
                              PlatformUtility.isLandscape(context)
                          ? 70
                          : 44,
                      type: SvgSourceType.asset,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom white background with text
        Align(
          alignment: Alignment.bottomCenter,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Consumer<StoryProvider>(
                builder: (context, storyProvider, _) {
                  // Calculate max width as 90% of screen width
                  final screenWidth = MediaQuery.of(context).size.width;
                  final textBoxMaxWidth = screenWidth * 0.9;

                  // Consistent font sizes based on screen width
                  final baseFontSize = isTabletLandScape ? 24.0 : 16.0;
                  final iconSizeForText = isTabletLandScape ? 36.0 : 24.0;

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
                                height: iconSizeForText,
                                width: iconSizeForText,
                                type: SvgSourceType.network,
                              ),
                            if (iconPath.isNotEmpty && i == 0)
                              Gaps.horizontalGapOf(12.0),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: isTabletLandScape ? 8 : 0,
                                ),
                                child: Text(
                                  lines[i],
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.text20PxMedium.copyWith(
                                    fontFamily: AppConstants.kMuktaFont,
                                    fontSize: baseFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }

                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: textBoxMaxWidth),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isTabletLandScape ? 12 : 10,
                        horizontal: isTabletLandScape ? 24 : 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: messageWidgets,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
