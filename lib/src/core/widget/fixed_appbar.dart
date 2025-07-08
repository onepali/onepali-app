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
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = _selectedTabIndex;
    final isMobileLandScape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.kWhite),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed:
                    () => Utility.navigateMaterialRoute(
                      context,
                      isMobileLandScape
                          ? DrawerScreen(
                            data: childData,
                            totalChildCount: totalChildCount,
                          )
                          : TabDrawerScreen(
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
              Gaps.horizontalGapOf(8),

              IconButton(
                onPressed:
                    () => Utility.navigate(
                      context,
                      AppRoutes.parentPinScreen,
                      arguments: {'fromScreenTimeLimit': false},
                    ),
                icon: SvgHelper.fromSource(
                  path: Assets.reward,
                  height: 45,
                  width: 45,
                ),
              ),
            ],
          ),
          Row(
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
    );
  }

  static int _selectedTabIndex = 0;

  static void setTabIndex(int index) {
    _selectedTabIndex = index;
  }

  Widget buildProgressBar() {
    const totalSteps = 5;
    return Row(
      children: List.generate(totalSteps, (index) {
        final isFilled = index < progressLevel;
        return Row(
          children: [
            if (index > 0)
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color:
                      isFilled
                          ? AppColors.kOrange.withValues(alpha: 0.2)
                          : Colors.grey.shade300,
                ),
              ),
            if (index > 0 && index < totalSteps - 1)
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: isFilled ? AppColors.kOrange : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
            if (index == totalSteps - 1)
              Container(
                height: 4,
                width: 40,
                color:
                    isFilled
                        ? AppColors.kOrange.withValues(alpha: 0.2)
                        : Colors.grey.shade300,
              ),
          ],
        );
      }),
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
  Size get preferredSize => const Size.fromHeight(90);
}
