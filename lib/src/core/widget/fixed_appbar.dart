import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onepali/src/src.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String profileImage;
  final int progressLevel;
  final int totalStars;
  final Function(String) onTabSelected;
  final List<ChildUserModel> childData;
  final bool isMobile;

  const UserAppBar({
    super.key,
    required this.name,
    required this.profileImage,
    required this.progressLevel,
    required this.totalStars,
    required this.onTabSelected,
    required this.childData,
    this.isMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    return AppBar(
      backgroundColor: AppColors.kWhite,
      elevation: 0,
      leading: Row(
        children: [
          IconButton(
            icon: CustomImage(
              Assets.avatar1,
              height: isMobile ? 50 : 65,
              width: isMobile ? 50 : 65,
              borderRadius: 60,
            ),
            onPressed:
                () => Utility.navigateMaterialRoute(
                  context,
                  DrawerScreen(data: childData),
                ),
          ),
          Gaps.horizontalGapOf(16),
          IconButton(
            onPressed: () => {},
            icon: SvgHelper.fromSource(
              path: Assets.reward,
              height: 28,
              width: 28,
            ),
          ),
          IconButton(
            onPressed: () => {},
            icon: SvgHelper.fromSource(
              path: Assets.search,
              height: 28,
              width: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
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
