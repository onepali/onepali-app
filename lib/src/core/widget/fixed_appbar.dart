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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.kWhite),
      child:
          isMobileLandScape
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isGuest) Gaps.verticalGapOf(35),

                  Row(
                    spacing: 8,
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
                              isGuest ? Assets.userAvatar : profileImage,
                              height: 45,
                              width: 45,
                              circular: true,
                              isProfileImage: true,
                              imageType:
                                  isGuest
                                      ? CustomImageType.local
                                      : CustomImageType.network,
                            ),
                          ),
                          Gaps.horizontalGapOf(10),
                          if (isGuest)
                            Text(
                              name,
                              style: AppStyles.text16PxBold.copyWith(
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
                                  if (playStarBlastAudio &&
                                      _selectedTabIndex == 0 &&
                                      childData.isNotEmpty) {
                                    _playStarBlastAudio();
                                  }
                                  return customInkwell(
                                    onTap: () {
                                      Utility.navigate(
                                        context,
                                        AppRoutes.chooseRewardScreen,
                                      );
                                    },
                                    child: LottieHelper.fromSource(
                                      path: Assets.starRewardLottie,
                                      height: 65,
                                      width: 65,
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
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                            ],
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
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
                            ),
                          Gaps.horizontalGapOf(10),
                        ],
                      ),
                    ],
                  ),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            );
                          }
                          //  else {
                          //   Utility.navigate(context, AppRoutes.systemScreen);
                          // }
                        },
                        icon: CustomImage(
                          isGuest ? Assets.parentAvatar : profileImage,
                          height: 45,
                          width: 45,
                          circular: true,
                          isProfileImage: true,
                          imageType:
                              isGuest
                                  ? CustomImageType.local
                                  : CustomImageType.network,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            ),
                          Gaps.horizontalGapOf(10),
                        ],
                      ),
                    ],
                  ),
                  // Gaps.verticalGapOf(8),
                  if (!isGuest) buildProgressBar(),
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
        await _stopStarBlastAudio();

        _starBlastAudioWidget = CustomAudioWidget(
          audioPath: Assets.starBlast,
          audioSourceType: AudioSourceType.asset,
        );

        _isStarBlastPlaying = true;
        await _starBlastAudioWidget!.play();

        Future.delayed(
          const Duration(milliseconds: AppConstants.starBlastDuration),
          () async {
            await _stopStarBlastAudio();
          },
        );
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
    return Row(
      children: [
        Container(
          height: 8,
          width: 40,
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
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: isFilled ? AppColors.kOrange : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 8,
                width: 40,
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
                height: 40,
                repeat: false,
                width: 40,
              );
            },
          ),
        ] else ...[
          if (!isGuest && totalChildCount > 0)
            SvgHelper.fromSource(path: Assets.reward, height: 30, width: 30),
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
    int selectedIndex,
  ) {
    final bool isSelected = index == selectedIndex;
    return IconButton(
      onPressed: onTap,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // if (isGuest) Gaps.verticalGapOf(30),
          SvgHelper.fromSource(
            path: icon,
            height: 44,
            width: 44,
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
                style: AppStyles.text12PxMedium.copyWith(
                  color: AppColors.kWhite,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    PlatformUtility.isMobile(context) && PlatformUtility.isLandscape(context)
        ? 110
        : 130,
  );
}
