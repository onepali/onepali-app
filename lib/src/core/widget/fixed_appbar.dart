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
    final isTabletPortrait =
        (PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context));

    // Smaller sizes for mobile landscape to prevent overflow
    final avatarSize = isTabletPortrait
        ? 64.0
        : (isMobileLandScape ? 35.0 : 45.0);
    final rewardIconSize = isTabletPortrait
        ? 50.0
        : (isMobileLandScape ? 30.0 : 40.0);
    final starRewardLottieSize = isTabletPortrait
        ? 85.0
        : (isMobileLandScape ? 30.0 : 40.0);
    final tabIconSize = isTabletPortrait
        ? 64.0
        : (isMobileLandScape ? 35.0 : 45.0);
    final horizontalPadding = isTabletPortrait
        ? 24.0
        : (isMobileLandScape ? 8.0 : 16.0);
    final verticalPadding = isTabletPortrait
        ? 12.0
        : (isMobileLandScape ? 4.0 : 8.0);
    final guestTopGap = isTabletPortrait ? 50.0 : 20.0;
    final tabSpacing = isTabletPortrait
        ? 25.0
        : (isMobileLandScape ? 6.0 : 10.0);
    final nameTextStyle = isTabletPortrait
        ? AppStyles.text32PxBold
        : (isMobileLandScape ? AppStyles.text12PxBold : AppStyles.text16PxBold);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: elevation,
                  offset: Offset(0, elevation / 2),
                ),
              ]
            : null,
      ),
      child: isMobileLandScape
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
                        SizedBox(
                          height: tabIconSize + 10,
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
                                isGuest ? Assets.blueUserAvatar : profileImage,
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
                      mainAxisSize: MainAxisSize.min,
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
          : SafeArea(
              child: Column(
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
                              SizedBox(
                                height: tabIconSize + 10,
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
                                      imageType: isGuest
                                          ? CustomImageType.local
                                          : CustomImageType.network,
                                    ),
                                  ),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: buildProgressBar(),
                            ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: tabSpacing,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < homeServices.length; i++) ...[
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
                            if (i != homeServices.length - 1)
                              Gaps.horizontalGapOf(tabSpacing),
                          ],
                        ],
                      ),
                    ],
                  ),
                  // Gaps.verticalGapOf(8),
                ],
              ),
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
    const totalSteps = 4;
    final isTabletPortrait =
        (PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context));
    final progressBarHeight = isTabletPortrait ? 12.0 : 8.0;
    final connectorLength = isTabletPortrait ? 100.0 : 40.0;
    final circleSize = isTabletPortrait ? 16.0 : 12.0;
    final rewardSize = isTabletPortrait ? 56.0 : 30.0;
    final starLottieSize = isTabletPortrait ? 56.0 : 40.0;

    return Row(
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
                  Utility.navigate(context, AppRoutes.chooseRewardScreen);
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
    int selectedIndex, [
    double? iconSize,
  ]) {
    final bool isSelected = index == selectedIndex;
    final effectiveIconSize = iconSize ?? 44.0;
    final isTabletPortrait =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    final labelTextStyle = isTabletPortrait
        ? AppStyles.text24PxMedium.copyWith(
            overflow: TextOverflow.ellipsis,
            fontFamily: AppConstants.kDMSansFont,
          )
        : AppStyles.text16PxSemiBold.copyWith(
            overflow: TextOverflow.ellipsis,
            fontFamily: AppConstants.kDMSansFont,
          );

    // Calculate fixed width based on the longest possible label
    final tabWidth = isTabletPortrait ? 125.0 : 85.0;

    return SizedBox(
      width: tabWidth,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        hoverColor: AppColors.kTransparentColor,
        splashColor: AppColors.kTransparentColor.withValues(alpha: 0.1),
        focusColor: AppColors.kTransparentColor,
        highlightColor: AppColors.kTransparentColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: effectiveIconSize + 10,
              child: Center(
                child: SvgHelper.fromSource(
                  path: icon,
                  height: effectiveIconSize,
                  width: effectiveIconSize,
                  // color: menuColor,
                ),
              ),
            ),

            SizedBox(
              width: tabWidth,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.0,
                child: Container(
                  margin: EdgeInsets.only(top: isTabletPortrait ? 15 : 8),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTabletPortrait ? 8 : 8,
                    vertical: 2,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? menuColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    // maxLines: 1,
                    style: labelTextStyle.copyWith(
                      color: isSelected ? AppColors.kWhite : Colors.transparent,
                    ),
                  ),
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
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    final isMobileLandscape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);

    if (isTabletLandscape) {
      return Size.fromHeight(isGuest ? 160 : 160);
    } else if (isTabletPortrait) {
      return const Size.fromHeight(130);
    } else if (isMobileLandscape) {
      return Size.fromHeight(isGuest ? 110 : 120);
    } else {
      return const Size.fromHeight(110);
    }
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
