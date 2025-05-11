import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String profileImage;
  final int progressLevel;
  final int totalStars;
  final Function(String) onTabSelected;

  const UserAppBar({
    super.key,
    required this.name,
    required this.profileImage,
    required this.progressLevel,
    required this.totalStars,
    required this.onTabSelected,
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
                  CustomImage(
                    profileImage,
                    width: 40,
                    height: 40,
                    imageType: CustomImageType.network,
                    boxFit: BoxFit.cover,
                    circular: true,
                  ),
                  Gaps.horizontalGapOf(10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // _buildProgressBar(),
                  Gaps.horizontalGapOf(10),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Dynamic Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        return Expanded(
          child: Container(
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isFilled ? Colors.amber : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child:
                index == totalSteps - 1
                    ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : null,
          ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgHelper.fromSource(path: icon, height: 28, width: 28),
            if (isSelected) ...[
              Gaps.verticalGapOf(4),
              Text(label, style: AppStyles.text8PxRegular),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(160);
}
