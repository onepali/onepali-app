import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String profileImage;
  final int progressLevel;
  final int totalStars;
  final Function(String) onTabSelected;
  final List<ChildUserModel> childData;
  final int totalChildCount;
  final AuthProviderType? authType;
  final BuildContext context;
  final int totalLessonsCompleted;

  const UserAppBar({
    super.key,
    required this.name,
    required this.profileImage,
    required this.progressLevel,
    required this.totalStars,
    required this.onTabSelected,
    required this.childData,
    this.authType,
    this.totalChildCount = 0,
    required this.context,

    this.totalLessonsCompleted = 0,
  }) : assert(
         progressLevel >= 0 && progressLevel <= 5,
         'Progress level must be between 0 and 5',
       ),
       assert(totalStars >= 0, 'Total stars must be non-negative'),
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
              ? Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed:
                            () => Utility.navigateMaterialRoute(
                              context,
                              DrawerScreen(
                                data: childData,
                                totalChildCount: totalChildCount,
                              ),
                            ),
                        icon: CustomImage(
                          profileImage,
                          height: 45,
                          width: 45,
                          circular: true,
                          isProfileImage: true,
                          imageType: CustomImageType.network,
                        ),
                      ),
                      Gaps.horizontalGapOf(10),
                      if (totalLessonsCompleted == 5) ...[
                        LottieHelper.fromSource(
                          path: Assets.starRewardLottie,
                          height: 100,
                          width: 100,
                        ),
                      ] else ...[
                        SvgHelper.fromSource(
                          path: Assets.reward,
                          height: 40,
                          width: 40,
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
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed:
                            () => Utility.navigateMaterialRoute(
                              context,
                              TabDrawerScreen(
                                data: childData,
                                totalChildCount: totalChildCount,
                              ),
                            ),
                        icon: CustomImage(
                          profileImage,
                          height: 45,
                          width: 45,
                          circular: true,
                          isProfileImage: true,
                          imageType: CustomImageType.network,
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
                  buildProgressBar(),
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
            color: Colors.grey.shade300,
          ),
        ),
        ...List.generate(totalSteps, (index) {
          final isFilled = index < progressLevel;
          return Row(
            children: [
              if (index < totalSteps - 1)
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: isFilled ? AppColors.kOrange : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              if (index < totalSteps - 1)
                Container(
                  height: 8,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color:
                        isFilled
                            ? AppColors.kOrange.withValues(alpha: 0.2)
                            : Colors.grey.shade300,
                  ),
                ),
            ],
          );
        }),
        SvgHelper.fromSource(path: Assets.reward, height: 30, width: 30),
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
