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
    bool isTabletLandScape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    Widget arrowButton({required bool isLeft, required VoidCallback onTap}) {
      return CircularButtonWidget(
        type:
            isLeft
                ? CircularButtonType.leftArrow
                : CircularButtonType.rightArrow,
        onPressed: onTap,
        // margin: const EdgeInsets.symmetric(horizontal: 16),
      );
    }

    return Stack(
      children: [
        // Background image is handled at parent level in story_content_screen.dart
        // to fill the entire screen (appears once)
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
        Positioned(
          top: 16,
          right: Dimensions.kIconMargin(context),
          child: CircularButtonWidget(
            onPressed: () {
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
            type: CircularButtonType.close,
          ),
        ),
        // Left arrow (center vertically)
        Positioned(
          left: Dimensions.kIconMargin(context),
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
          right: Dimensions.kIconMargin(context),
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
                            height:
                                PlatformUtility.isTablet(context) &&
                                        PlatformUtility.isLandscape(context)
                                    ? 40
                                    : 26,
                            width:
                                PlatformUtility.isTablet(context) &&
                                        PlatformUtility.isLandscape(context)
                                    ? 40
                                    : 26,
                            type: SvgSourceType.network,
                          ),
                        if (iconPath.isNotEmpty && i == 0)
                          Gaps.horizontalGapOf(12.0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: isTabletLandScape ? 8 : 0,
                          ),
                          child: Text(
                            lines[i],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.text20PxMedium.copyWith(
                              fontFamily: AppConstants.kMuktaFont,
                              fontSize:
                                  PlatformUtility.isTablet(context) &&
                                          PlatformUtility.isLandscape(context)
                                      ? 40
                                      : 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
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
              );
            },
          ),
        ),
      ],
    );
  }
}
