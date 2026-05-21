import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String profileImage;
  final int totalStars;
  final Function(String) onTabSelected;
  final List<ChildUserModel> childData;
  final int totalChildCount;
  final AuthProviderType? authType;
  final BuildContext context;
  final int totalLessonsCompleted;
  final bool isGuest;
  final bool playStarBlastAudio;
  final Color menuColor;
  final double elevation;

  const UserAppBar({
    super.key,
    required this.name,
    required this.profileImage,
    required this.totalStars,
    required this.onTabSelected,
    required this.childData,
    this.authType,
    this.totalChildCount = 0,
    required this.context,
    this.isGuest = false,
    this.playStarBlastAudio = false,
    this.totalLessonsCompleted = 0,
    this.menuColor = AppColors.kLessonColor,
    this.elevation = 0.0,
  }) : assert(totalStars >= 0, 'Total stars must be non-negative'),
       assert(totalChildCount >= 0, 'Total child count must be non-negative'),
       assert(
         totalLessonsCompleted >= 0,
         'Total lessons completed must be non-negative',
       );

  @override
  Widget build(BuildContext context) {
    logger.d('totalChildCount: $totalChildCount');
    int selectedIndex = _selectedTabIndex;
    final isMobileLandScape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);
    logger.d('UserAppBar: isMobileLandScape: $isMobileLandScape');

    // Responsive variables
    final isTablet = PlatformUtility.isTablet(context);
    final isTabletLandscape = isTablet && PlatformUtility.isLandscape(context);
    final isMobile = PlatformUtility.isMobile(context);

    // ============================================================
    // Simplified Layout Calculation - Top Down Approach
    // ============================================================

    // Step 1: Calculate base dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaInsets = MediaQuery.of(context).padding;

    // Step 2: App bar dimensions
    // Base padding - SafeArea will handle safe area insets automatically when enabled
    final horizontalPadding = screenWidth * 0.02; // 2% base padding
    final verticalPadding = screenHeight * 0.02; // 2% padding
    // Content width accounts for base padding and left safe area (for mobile landscape)
    // SafeArea adds padding, so we need to subtract it from available width
    final leftSafeAreaPadding = isMobileLandScape ? safeAreaInsets.left : 0.0;
    final contentWidth =
        screenWidth - (horizontalPadding * 2) - leftSafeAreaPadding;

    // Step 3: Side allocations
    final sectionGap = contentWidth * 0.04; // Gap between sides
    final leftSideWidth = contentWidth * 0.48;
    final rightSideWidth = contentWidth * 0.48;

    // Step 4: Calculate tab dimensions (centralized in helper method)
    final tabDims = _calculateTabDimensions(rightSideWidth);
    final tabWidth = tabDims.tabWidth;
    final tabSpacing = tabDims.tabSpacing;
    final tabIconSize = tabDims.tabIconSize;
    final tabCaptionFontSize = tabDims.tabCaptionFontSize;
    final tabHeight = tabDims.tabContentHeight;

    // Step 5: Left side elements (based on leftSideWidth)
    // Make avatar size consistent across devices, matching icon size
    // tabIconSize = 12% of leftSideWidth (calculated from tabWidth * 0.40)
    // tabWidth = 30% of rightSideWidth, rightSideWidth = leftSideWidth
    // tabIconSize = leftSideWidth * 0.30 * 0.40 = leftSideWidth * 0.12
    final avatarSize =
        leftSideWidth * 0.12; // Same as icon size for consistency
    final rewardIconSize = leftSideWidth * (isMobile ? 0.15 : 0.12);
    final starRewardLottieSize = leftSideWidth * (isMobile ? 0.10 : 0.15);
    final achievementsBarWidth = leftSideWidth * 0.80;

    // Text styles - make name font size similar to caption
    final nameFontSize = isTabletLandscape
        ? (tabCaptionFontSize * 1.3)
        : (tabCaptionFontSize * 1.2);
    final nameTextStyle = isTabletLandscape
        ? AppStyles.text32PxBold.copyWith(fontSize: nameFontSize)
        : AppStyles.text16PxBold.copyWith(fontSize: nameFontSize);

    final guestTopGap = isTabletLandscape ? screenHeight * 0.02 : 0.0;

    // Always respect left safe area - SafeArea will only add padding if needed
    return SafeArea(
      left: true,
      top: true,
      right: false,
      bottom: false,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: isMobileLandScape
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isGuest) Gaps.verticalGapOf(guestTopGap),
                      Row(
                        spacing: 0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: avatarSize + 8,
                                child: Center(
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      if (!isGuest) {
                                        Utility.navigateMaterialRoute(
                                          context,
                                          DrawerScreen(
                                            data: childData,
                                            totalChildCount: totalChildCount,
                                          ),
                                          routeName: AppRoutes.drawerRoutes,
                                        );
                                      }
                                      // } else {
                                      //   Utility.navigate(
                                      //     context,
                                      //     AppRoutes.systemScreen,
                                      //   );
                                      // }
                                    },
                                    icon: CustomImage(
                                      isGuest
                                          ? Assets.blueUserAvatar
                                          : profileImage,
                                      height: avatarSize,
                                      width: avatarSize,
                                      circular: true,
                                      // isProfileImage: true,
                                      imageType: isGuest
                                          ? CustomImageType.local
                                          : CustomImageType.network,
                                    ),
                                  ),
                                ),
                              ),
                              Gaps.horizontalGapOf(tabSpacing),
                              // Name not shown on mobile - only on tablet
                              if (!isGuest && totalChildCount > 0)
                                if (
                                // totalLessonsCompleted == 5 &&
                                GlobalConfig.isUserTesting &&
                                    childData.isNotEmpty) ...[
                                  Builder(
                                    builder: (context) {
                                      // Only play audio if playStarBlastAudio is true
                                      // if (playStarBlastAudio &&
                                      //     _selectedTabIndex == 0 &&
                                      //     childData.isNotEmpty) {
                                      //   _playStarBlastAudio();
                                      // }
                                      return customInkwell(
                                        onTap: () {
                                          Utility.navigate(
                                            context,
                                            AppRoutes.chooseRewardScreen,
                                          );
                                        },
                                        child: LottieHelper.fromSource(
                                          path: Assets.starRewardLottie,
                                          height: starRewardLottieSize,
                                          width: starRewardLottieSize,
                                          repeat: false,
                                        ),
                                      );
                                    },
                                  ),
                                ] else ...[
                                  if (!isGuest && totalChildCount > 0)
                                    customInkwell(
                                      onTap: () {
                                        Utility.navigate(
                                          context,
                                          AppRoutes.rewardCollectionScreen,
                                        );
                                      },
                                      child: SvgHelper.fromSource(
                                        path: Assets.reward,
                                        height: rewardIconSize,
                                        width: rewardIconSize,
                                      ),
                                    ),
                                ],
                            ],
                          ),
                          // Explicit gap between sections
                          SizedBox(width: sectionGap),
                          // Right side: Tabs
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: tabSpacing,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < homeServices.length; i++)
                                  _buildTab(
                                    homeServices[i].icon ?? '',
                                    homeServices[i].name ?? '',
                                    homeServices[i].color,
                                    () => onTabSelected(
                                      homeServices[i].name ?? '',
                                    ),
                                    i,
                                    selectedIndex,
                                    iconSize: tabIconSize,
                                    tabWidth: tabWidth,
                                    tabHeight: tabHeight,
                                    captionFontSize: tabCaptionFontSize,
                                    isMobile: isMobile,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // if (isGuest) Gaps.verticalGapOf(guestTopGap),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: leftSideWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: avatarSize + 8,
                                        child: Center(
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () {
                                              if (!isGuest) {
                                                Utility.navigateMaterialRoute(
                                                  context,
                                                  TabDrawerScreen(
                                                    data: childData,
                                                    totalChildCount:
                                                        totalChildCount,
                                                  ),
                                                  routeName:
                                                      AppRoutes.tabDrawerRoutes,
                                                );
                                              }
                                              //  else {
                                              //   Utility.navigate(context, AppRoutes.systemScreen);
                                              // }
                                            },
                                            icon: CustomImage(
                                              isGuest
                                                  ? Assets.blueUserAvatar
                                                  : profileImage,
                                              height: avatarSize,
                                              width: avatarSize,
                                              circular: true,
                                              isProfileImage: true,
                                              imageType: isGuest
                                                  ? CustomImageType.local
                                                  : CustomImageType.network,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gaps.horizontalGapOf(tabSpacing),
                                      if (!isGuest &&
                                          totalChildCount > 0 &&
                                          isTablet)
                                        Text(
                                          name,
                                          style: nameTextStyle.copyWith(
                                            color: AppColors.kPitchBlack,
                                          ),
                                        ),
                                    ],
                                  ),
                                  // Achievements bar below avatar/name, aligned with captions
                                  if (!isGuest && totalChildCount > 0)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                            (isMobile ? 0.01 : 0.015),
                                      ), // Same margin as captions
                                      child: SizedBox(
                                        width:
                                            achievementsBarWidth, // 80% of left side allocation
                                        child: buildProgressBar(
                                          achievementsBarWidth,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Explicit gap between sections
                            SizedBox(width: sectionGap),
                            // Right side: Tabs
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: tabSpacing,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int i = 0; i < homeServices.length; i++)
                                    _buildTab(
                                      homeServices[i].icon ?? '',
                                      homeServices[i].name ?? '',
                                      homeServices[i].color,
                                      () => onTabSelected(
                                        homeServices[i].name ?? '',
                                      ),
                                      i,
                                      selectedIndex,
                                      iconSize: tabIconSize,
                                      tabWidth: tabWidth,
                                      tabHeight: tabHeight,
                                      captionFontSize: tabCaptionFontSize,
                                      isMobile: isMobile,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
          // Horizontal line with shadow at bottom when elevation > 0
          if (elevation > 0)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  static int _selectedTabIndex = 0;
  static CustomAudioWidget? _starBlastAudioWidget;
  static bool _isStarBlastPlaying = false;

  static void setTabIndex(int index) {
    _selectedTabIndex = index;
  }

  // Method to stop and dispose star blast audio
  static Future<void> _stopStarBlastAudio() async {
    if (_starBlastAudioWidget != null) {
      try {
        await _starBlastAudioWidget!.audioPlayer.stop();
        await _starBlastAudioWidget!.dispose();
        _starBlastAudioWidget = null;
        _isStarBlastPlaying = false;
        logger.d('Star blast audio stopped and disposed');
      } catch (e) {
        logger.e('Error stopping star blast audio: $e');
      }
    }
  }

  // Common method to play star blast audio
  static void _playStarBlastAudio() {
    // Prevent multiple simultaneous plays
    if (_isStarBlastPlaying) {
      logger.d('Star blast audio already playing, skipping');
      return;
    }

    Misc.onLayoutRendered(() async {
      try {
        // Stop any existing audio first
        // await _stopStarBlastAudio();

        // _starBlastAudioWidget = CustomAudioWidget(
        //   audioPath: Assets.starBlast,
        //   audioSourceType: AudioSourceType.asset,
        // );

        // _isStarBlastPlaying = true;
        // await _starBlastAudioWidget!.play();

        // Future.delayed(
        //   const Duration(milliseconds: AppConstants.starBlastDuration),
        //   () async {
        //     await _stopStarBlastAudio();
        //   },
        // );
      } catch (e) {
        logger.e('Error playing star blast audio: $e');
        _isStarBlastPlaying = false;
      }
    });
  }

  // Public method to reset audio from outside
  static Future<void> resetStarBlastAudio() async {
    await _stopStarBlastAudio();
  }

  Widget buildProgressBar(double progressBarWidth) {
    const totalSteps = 4;
    final isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    // Calculate responsive sizes based on progressBarWidth (already 80% of left side)
    final progressBarHeight =
        progressBarWidth * (isTabletLandscape ? 0.02 : 0.03); // 4% thickness
    final connectorLength =
        progressBarWidth *
        (isTabletLandscape ? 0.08 : 0.10); // 10% / 8% connector width
    final circleSize =
        progressBarWidth * (isTabletLandscape ? 0.04 : 0.05); // 5% dot size
    final rewardSize =
        progressBarWidth *
        (isTabletLandscape ? 0.10 : 0.12); // 10% / 12% reward size
    final starLottieSize =
        progressBarWidth *
        (isTabletLandscape ? 0.10 : 0.12); // 10% / 12% star size

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Distribute across available width
      children: [
        for (int i = 0; i < totalSteps; i++) ...[
          _buildDottedConnector(
            isActive: totalLessonsCompleted > i,
            length: connectorLength,
            height: progressBarHeight,
          ),

          // Progress dot
          _buildProgressDot(
            isCompleted: totalLessonsCompleted > i,
            isLastStep: i == totalSteps - 1,
            circleSize: circleSize,
          ),
        ],

        // Final dotted connector after last dot
        _buildDottedConnector(
          isActive: totalLessonsCompleted >= totalSteps,
          length: connectorLength,
          height: progressBarHeight,
        ),

        // Reward icon
        if (
        // totalLessonsCompleted == 5 &&
        GlobalConfig.isUserTesting && !isGuest && totalChildCount > 0) ...[
          Builder(
            builder: (context) {
              // Only play audio if playStarBlastAudio is true
              if (playStarBlastAudio &&
                  _selectedTabIndex == 0 &&
                  childData.isNotEmpty) {
                _playStarBlastAudio();
              }

              return customInkwell(
                onTap: () {
                  if (totalStars >= 5) {
                    Utility.navigate(context, AppRoutes.chooseRewardScreen);
                  } else {
                    Utility.navigate(context, AppRoutes.rewardCollectionScreen);
                  }
                },
                child: LottieHelper.fromSource(
                  path: Assets.starRewardLottie,
                  height: starLottieSize,
                  repeat: false,
                  width: starLottieSize,
                ),
              );
            },
          ),
        ] else ...[
          if (!isGuest && totalChildCount > 0)
            SvgHelper.fromSource(
              path: Assets.reward,
              height: rewardSize,
              width: rewardSize,
            ),
        ],
      ],
    );
  }

  Widget _buildProgressDot({
    required bool isCompleted,
    required bool isLastStep,
    required double circleSize,
  }) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.kOrange : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: isLastStep && isCompleted
          ? Icon(Icons.star, color: AppColors.kWhite, size: circleSize * 0.6)
          : null,
    );
  }

  Widget _buildDottedConnector({
    required bool isActive,
    required double length,
    required double height,
  }) {
    return CustomPaint(
      size: Size(length, height),
      painter: DottedLinePainter(
        color: isActive ? AppColors.sunshineYellow : Colors.grey.shade300,
        strokeWidth: height,
      ),
    );
  }

  Widget _buildTab(
    String icon,
    String label,
    Color color,
    VoidCallback onTap,
    int index,
    int selectedIndex, {
    required double iconSize,
    required double tabWidth,
    required double? tabHeight,
    required double? captionFontSize,
    required bool isMobile,
  }) {
    final bool isSelected = index == selectedIndex;
    final isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    final labelTextStyle = isTabletLandscape
        ? AppStyles.text24PxMedium.copyWith(
            overflow: TextOverflow.ellipsis,
            fontFamily: AppConstants.kDMSansFont,
          )
        : AppStyles.text16PxSemiBold.copyWith(
            overflow: TextOverflow.ellipsis,
            fontFamily: AppConstants.kDMSansFont,
          );

    return SizedBox(
      width: tabWidth,
      child: GestureDetector(
        onTap: onTap,
        // borderRadius: BorderRadius.circular(8),
        // hoverColor: AppColors.kTransparentColor,
        // splashColor: AppColors.kTransparentColor.withValues(alpha: 0.1),
        // focusColor: AppColors.kTransparentColor,
        // highlightColor: AppColors.kTransparentColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container - compact height
            SizedBox(
              height: iconSize * 1.0,
              child: Center(
                child: SvgHelper.fromSource(
                  path: icon,
                  height: iconSize,
                  width: iconSize,
                ),
              ),
            ),

            // Caption - sized relative to available space (tabWidth minus padding)
            // Available text width: tabWidth - 2*(tabWidth*0.05) = tabWidth * 0.90
            // Font size: 22% of tabWidth ≈ fits 80-90% of available space
            Container(
              margin: EdgeInsets.only(top: tabWidth * 0.05),
              padding: EdgeInsets.symmetric(
                horizontal: tabWidth * 0.05,
                vertical: tabWidth * 0.02,
              ),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelTextStyle.copyWith(
                  color: isSelected ? AppColors.kWhite : Colors.transparent,
                  fontSize:
                      captionFontSize ??
                      tabWidth *
                          0.18, // Use passed font size (≈80-85% of available space)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isTablet = PlatformUtility.isTablet(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final isPortrait = PlatformUtility.isPortrait(context);

    final isTabletLandscape = isTablet && isLandscape;
    final isTabletPortrait = isTablet && isPortrait;
    final isMobileLandscape = !isTablet && isLandscape;
    final isMobilePortrait = !isTablet && isPortrait;

    // Calculate actual content height needed to prevent overflow
    // Use the same helper method as build() to avoid duplication
    final contentWidth = screenWidth * 0.96;
    final rightSideWidth = contentWidth * 0.48;
    final tabDims = _calculateTabDimensions(rightSideWidth);
    final tabContentHeight = tabDims.tabContentHeight;

    // App bar needs to accommodate tab content + vertical padding
    final verticalPadding = screenHeight * 0.02 * 2; // Top + bottom padding
    final totalHeight = tabContentHeight + verticalPadding;

    // Add buffer at the bottom
    // For guest, use mobile buffer (20) to match mobile height
    // For non-guest, use device-appropriate buffer
    final buffer = isGuest ? 20 : (isTablet ? 50 : 20);
    final calculatedHeight = totalHeight + buffer;

    // Tablet configurations
    if (isTabletLandscape) {
      return Size.fromHeight(calculatedHeight);
    } else if (isTabletPortrait) {
      return Size.fromHeight(calculatedHeight);
    }
    // Mobile configurations
    else if (isMobileLandscape) {
      return Size.fromHeight(calculatedHeight);
    } else if (isMobilePortrait) {
      return Size.fromHeight(calculatedHeight);
    }

    // Fallback
    return Size.fromHeight(calculatedHeight);
  }

  /// Calculate tab dimensions - returns all values needed for tabs
  /// This method centralizes the calculation to avoid duplication
  ({
    double tabWidth,
    double tabSpacing,
    double tabIconSize,
    double captionTotalHeight,
    double tabCaptionFontSize,
    double tabContentHeight,
  })
  _calculateTabDimensions(double rightSideWidth) {
    // Tab width and spacing
    final tabWidth = rightSideWidth * 0.30;
    final tabSpacing = rightSideWidth * 0.05;

    // Icon and caption sizing - using the original logic
    final tabIconSize = tabWidth * 0.40; // Icon = 40% of tab width
    final captionVerticalPadding = tabWidth * 0.02 * 2; // 4% total padding
    final tabCaptionFontSize =
        tabWidth * 0.18; // Caption font = 18% of tab width (original)
    final captionTotalHeight =
        tabCaptionFontSize + captionVerticalPadding; // Caption container height

    // Total tab height
    final tabContentHeight =
        tabIconSize + (tabWidth * 0.05) + captionTotalHeight;

    return (
      tabWidth: tabWidth,
      tabSpacing: tabSpacing,
      tabIconSize: tabIconSize,
      captionTotalHeight: captionTotalHeight,
      tabCaptionFontSize: tabCaptionFontSize,
      tabContentHeight: tabContentHeight,
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DottedLinePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
