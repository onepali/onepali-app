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
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final avatarSize = isTabletPortrait ? 60.0 : 45.0;
    final rewardIconSize = isTabletPortrait ? 50.0 : 40.0;
    final starRewardLottieSize = isTabletPortrait ? 85.0 : 65.0;
    final tabIconSize = isTabletPortrait ? 60.0 : 44.0;
    final horizontalPadding = isTabletPortrait ? 24.0 : 16.0;
    final verticalPadding = isTabletPortrait ? 12.0 : 8.0;
    final guestTopGap = isTabletPortrait ? 50.0 : 20.0;
    final tabSpacing = isTabletPortrait ? 15.0 : 10.0;
    final nameTextStyle =
        isTabletPortrait ? AppStyles.text24PxSemiBold : AppStyles.text16PxBold;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        boxShadow:
            elevation > 0
                ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: elevation,
                    offset: Offset(0, elevation / 2),
                  ),
                ]
                : null,
      ),
      child:
          isMobileLandScape
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isGuest) Gaps.verticalGapOf(guestTopGap),
                  Row(
                    spacing: tabSpacing,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
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
                              isGuest ? Assets.blueUserAvatar : profileImage,
                              height: avatarSize,
                              width: avatarSize,
                              circular: true,
                              // isProfileImage: true,
                              imageType:
                                  isGuest
                                      ? CustomImageType.local
                                      : CustomImageType.network,
                            ),
                          ),
                          Gaps.horizontalGapOf(tabSpacing),
                          if (isGuest)
                            Text(
                              name,
                              style: nameTextStyle.copyWith(
                                color: AppColors.kPitchBlack,
                              ),
                            ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: tabSpacing,
                        children: [
                          for (int i = 0; i < homeServices.length; i++)
                            _buildTab(
                              homeServices[i].icon ?? '',
                              homeServices[i].name ?? '',
                              selectedIndex == i
                                  ? AppColors.kSecondaryColor
                                  : AppColors.kGrey,
                              () => onTabSelected(homeServices[i].name ?? ''),
                              i,
                              selectedIndex,
                              tabIconSize,
                            ),
                          Gaps.horizontalGapOf(tabSpacing),
                        ],
                      ),
                    ],
                  ),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isGuest) Gaps.verticalGapOf(guestTopGap),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (!isGuest) {
                                    Utility.navigateMaterialRoute(
                                      context,
                                      TabDrawerScreen(
                                        data: childData,
                                        totalChildCount: totalChildCount,
                                      ),
                                      routeName: AppRoutes.tabDrawerRoutes,
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
                                  imageType:
                                      isGuest
                                          ? CustomImageType.local
                                          : CustomImageType.network,
                                ),
                              ),
                              Gaps.horizontalGapOf(tabSpacing),
                              if (!isGuest && totalChildCount > 0)
                                Text(
                                  name,
                                  style: nameTextStyle.copyWith(
                                    color: AppColors.kPitchBlack,
                                  ),
                                ),
                            ],
                          ),
                          if (!isGuest && totalChildCount > 0)
                            buildProgressBar(),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: tabSpacing,
                        children: [
                          for (int i = 0; i < homeServices.length; i++)
                            _buildTab(
                              homeServices[i].icon ?? '',
                              homeServices[i].name ?? '',
                              selectedIndex == i
                                  ? AppColors.kSecondaryColor
                                  : AppColors.kGrey,
                              () => onTabSelected(homeServices[i].name ?? ''),
                              i,
                              selectedIndex,
                              tabIconSize,
                            ),
                          Gaps.horizontalGapOf(tabSpacing),
                        ],
                      ),
                    ],
                  ),
                  // Gaps.verticalGapOf(8),
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

  Widget buildProgressBar() {
    const totalSteps = 5;
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final progressBarHeight = isTabletPortrait ? 10.0 : 8.0;
    final progressBarWidth = isTabletPortrait ? 50.0 : 40.0;
    final circleSize = isTabletPortrait ? 16.0 : 12.0;
    final rewardSize = isTabletPortrait ? 40.0 : 30.0;
    final starLottieSize = isTabletPortrait ? 50.0 : 40.0;

    return Row(
      children: [
        Container(
          height: progressBarHeight,
          width: progressBarWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color:
                totalLessonsCompleted > 0
                    ? AppColors.kOrange.withValues(alpha: 0.2)
                    : Colors.grey.shade300,
          ),
        ),
        ...List.generate(totalSteps - 1, (index) {
          final isFilled = totalLessonsCompleted > index;
          final isBarFilled = totalLessonsCompleted > (index + 1);
          return Row(
            children: [
              Container(
                height: circleSize,
                width: circleSize,
                decoration: BoxDecoration(
                  color: isFilled ? AppColors.kOrange : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: progressBarHeight,
                width: progressBarWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color:
                      isBarFilled
                          ? AppColors.kOrange.withValues(alpha: 0.2)
                          : Colors.grey.shade300,
                ),
              ),
            ],
          );
        }),
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

              return LottieHelper.fromSource(
                path: Assets.starRewardLottie,
                height: starLottieSize,
                repeat: false,
                width: starLottieSize,
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

  Widget _buildTab(
    String icon,
    String label,
    Color color,
    VoidCallback onTap,
    int index,
    int selectedIndex, [
    double? iconSize,
  ]) {
    final bool isSelected = index == selectedIndex;
    final effectiveIconSize = iconSize ?? 44.0;
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final labelTextStyle =
        isTabletPortrait ? AppStyles.text14PxMedium : AppStyles.text12PxMedium;

    return IconButton(
      onPressed: onTap,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // if (isGuest) Gaps.verticalGapOf(30),
          SvgHelper.fromSource(
            path: icon,
            height: effectiveIconSize,
            width: effectiveIconSize,
            // color: menuColor,
          ),
          if (isSelected) ...[
            Gaps.verticalGapOf(4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: menuColor,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                label,
                style: labelTextStyle.copyWith(color: AppColors.kWhite),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    if (isTabletLandscape) {
      return Size.fromHeight(isGuest ? 110 : 160);
    } else if (isTabletPortrait) {
      return const Size.fromHeight(130);
    } else {
      return const Size.fromHeight(110);
    }
  }
}
