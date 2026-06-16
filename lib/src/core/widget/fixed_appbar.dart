import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/dialog/create_child_profile_dialog.dart';
import 'package:onepali/src/src.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String profileImage;
  final Function(String) onTabSelected;
  final List<ChildUserModel> childData;
  final int totalChildCount;
  final AuthProviderType? authType;
  final BuildContext context;
  final String? parentUid;
  final String? childUid;
  final bool isGuest;
  final bool playStarBlastAudio;
  final Color menuColor;
  final double elevation;

  const UserAppBar({
    super.key,
    required this.name,
    required this.profileImage,
    required this.onTabSelected,
    required this.childData,
    this.authType,
    this.totalChildCount = 0,
    required this.context,
    this.isGuest = false,
    this.playStarBlastAudio = false,
    this.parentUid,
    this.childUid,
    this.menuColor = AppColors.kLessonColor,
    this.elevation = 0.0,
  }) : assert(totalChildCount >= 0, 'Total child count must be non-negative');

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
    ChildUserModel? activeChild;
    for (final child in childData) {
      if (child.uid == childUid) {
        activeChild = child;
        break;
      }
    }
    activeChild ??= childData.isNotEmpty ? childData.first : null;
    final hasRewardReady =
        activeChild != null && activeChild.completedLessonsCount >= 5;

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
                                    onPressed: () async {
                                      await _handleAvatarTap(context);
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
                                          if (hasRewardReady) {
                                            Utility.navigate(
                                              context,
                                              AppRoutes.chooseRewardScreen,
                                            );
                                          } else {
                                            Utility.navigate(
                                              context,
                                              AppRoutes.rewardCollectionScreen,
                                            );
                                          }
                                        },
                                        child: LottieHelper.fromSource(
                                          path: Assets.starRewardLottie,
                                          height: starRewardLottieSize,
                                          width: starRewardLottieSize,
                                          repeat: hasRewardReady,
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
                                            onPressed: () async {
                                              await _handleAvatarTap(context);
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
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => GestureDetector(
                                                    onTap: () async {
                                                      await _handleAvatarTap(
                                                        context,
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      Assets.blueUserAvatar,
                                                      height: avatarSize,
                                                      width: avatarSize,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
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
                                  if (!isGuest &&
                                      totalChildCount > 0 &&
                                      parentUid != null &&
                                      childUid != null)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                            (isMobile ? 0.01 : 0.015),
                                      ), // Same margin as captions
                                      child: SizedBox(
                                        width: achievementsBarWidth,
                                        child: AppBarProgressBar(
                                          parentUid: parentUid!,
                                          childUid: childUid!,
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

  static int get selectedTabIndex => _selectedTabIndex;
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

  static void triggerStarBlastAudio() => _playStarBlastAudio();

  Future<void> _handleAvatarTap(BuildContext context) async {
    if (isGuest) {
      Utility.navigate(context, AppRoutes.onboardingScreen);
      return;
    }

    final hasNoChild = childData.isEmpty || totalChildCount <= 0;
    if (hasNoChild) {
      final shouldCreateChild = await showCreateChildProfileDialog(context);
      if (shouldCreateChild == true) {
        Utility.navigate(context, AppRoutes.childRegisterScreen);
      }
      return;
    }

    final isMobileLandscape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);
    if (isMobileLandscape) {
      Utility.navigateMaterialRoute(
        context,
        DrawerScreen(data: childData, totalChildCount: totalChildCount),
        routeName: AppRoutes.drawerRoutes,
      );
      return;
    }

    Utility.navigateMaterialRoute(
      context,
      TabDrawerScreen(data: childData, totalChildCount: totalChildCount),
      routeName: AppRoutes.tabDrawerRoutes,
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
