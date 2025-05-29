import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String profileImage;
  final int progressLevel;
  final int totalStars;
  final Function(String) onTabSelected;
  final bool isMobile;

  const UserAppBar({
    super.key,
    required this.name,
    required this.profileImage,
    required this.progressLevel,
    required this.totalStars,
    required this.onTabSelected,
    this.isMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    return Container(
      height: preferredSize.height,
      color: AppColors.kWhite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  customInkwell(
                    onTap: () {
                      Utility.navigateMaterialRoute(
                        context,
                        ChildRegisterScreen(),
                      );
                    },
                    child: CustomImage(
                      Assets.userAvatar,
                      width: 40,
                      height: 40,
                      imageType: CustomImageType.local,
                      boxFit: BoxFit.cover,
                      circular: true,
                    ),
                  ),
                  Gaps.horizontalGapOf(10),
                  // Text(
                  //   name,
                  //   style: const TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ],
              ),
              // Row(
              //   children: [
              //     _buildProgressBar(),
              //     Container(
              //       padding: const EdgeInsets.all(6),
              //       decoration: const BoxDecoration(
              //         color: Colors.amber,
              //         shape: BoxShape.circle,
              //       ),
              //       child: const Icon(
              //         Icons.star,
              //         color: Colors.white,
              //         size: 10,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),

          // Dynamic Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 16,
            children:
                homeServices.asMap().entries.map((entry) {
                  final index = entry.key;
                  final service = entry.value;
                  return _buildTab(
                    service.icon ?? "",
                    service.name ?? '',
                    Colors.blue,
                    () => onTabSelected(service.route),
                    index,
                    selectedIndex,
                  );
                }).toList(),
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
