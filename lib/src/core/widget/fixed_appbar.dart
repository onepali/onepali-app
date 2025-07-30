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
  }) : assert(totalStars >= 0, 'Total stars must be non-negative'),
       assert(totalChildCount >= 0, 'Total child count must be non-negative'),
       assert(
         totalLessonsCompleted >= 0,
         'Total lessons completed must be non-negative',
       );

  @override
  Widget build(BuildContext context) {
    logger.d('totalLessonsCompleted: $totalLessonsCompleted');
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
                children: [
                  if (isGuest) Gaps.verticalGapOf(35),

                  Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          if (!isGuest)
                            if (
                            // totalLessonsCompleted == 5 &&
                            GlobalConfig.isUserTesting) ...[
                              Builder(
                                builder: (context) {
                                  // Only play audio if playStarBlastAudio is true
                                  if (playStarBlastAudio &&
                                      _selectedTabIndex == 0) {
                                    Misc.onLayoutRendered(() async {
                                      final audioWidget = CustomAudioWidget(
                                        audioPath: Assets.starBlast,
                                        audioSourceType: AudioSourceType.asset,
                                      );
                                      await audioWidget.play();

                                      Future.delayed(
                                        const Duration(
                                          milliseconds:
                                              AppConstants.starBlastDuration,
                                        ),
                                        () async {
                                          await audioWidget.dispose();
                                        },
                                      );
                                    });
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
                                    ),
                                  );
                                },
                              ),
                            ] else ...[
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
                        mainAxisAlignment: MainAxisAlignment.center,
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

  static void setTabIndex(int index) {
    _selectedTabIndex = index;
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
        GlobalConfig.isUserTesting) ...[
          Builder(
            builder: (context) {
              // Only play audio if playStarBlastAudio is true
              if (playStarBlastAudio && _selectedTabIndex == 0) {
                Misc.onLayoutRendered(() async {
                  final audioWidget = CustomAudioWidget(
                    audioPath: Assets.starBlast,
                    audioSourceType: AudioSourceType.asset,
                  );
                  await audioWidget.play();

                  Future.delayed(
                    const Duration(
                      milliseconds: AppConstants.starBlastDuration,
                    ),
                    () async {
                      await audioWidget.dispose();
                    },
                  );
                });
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (isGuest) Gaps.verticalGapOf(30),
          SvgHelper.fromSource(path: icon, height: 28, width: 28),
          if (isSelected) ...[
            Gaps.verticalGapOf(4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                label,
                style: AppStyles.text10PxMedium.copyWith(
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
        ? 90
        : 130,
  );
}
