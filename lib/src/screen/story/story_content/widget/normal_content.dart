import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
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
    final isMobile = PlatformUtility.isMobile(context);
    bool isTabletLandScape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    return Stack(
      children: [
        // Background image is handled at parent level in story_content_screen.dart
        // to fill the entire screen (appears once)
        // Top center sound icon
        Positioned(
          top: isMobile ? 24 : 32,
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
                  child: SvgHelper.fromSource(
                    path: Assets.sound,
                    height: Dimensions.kIconSize(context),
                    width: Dimensions.kIconSize(context),
                  ),
                );
                return storyProvider.isPlaying
                    ? CustomAvatarGlow(child: soundIcon)
                    : soundIcon;
              },
            ),
          ),
        ),
        // Top right wrong icon
        TopRightPositionedCloseButton(
          onTap: () {
            storyProvider.stopAudioAndResetIndex();
            logger.d('[NormalContent] Wrong icon tapped, stopping audio');

            // Navigate to appropriate dashboard based on user type
            bool isGuest = GuestUtil.isGuestUser();
            if (isGuest) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.guestDashboardScreen,
                (route) => false,
              );
              UserAppBar.setTabIndex(0);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.dashboardScreen,
                (route) => false,
              );
              UserAppBar.setTabIndex(0);
            }
          },
        ),
        // Left arrow (center vertically)
        CenterLeftAlignedBackButton(
          onTap: () => storyProvider.previousContent(),
        ),
        // Right arrow (center vertically)
        CenterRightAlignedForwardButton(
          onTap: () => storyProvider.nextContent(context),
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
