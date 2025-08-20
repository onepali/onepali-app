import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class DrawerCard extends StatelessWidget {
  final String title;
  final String? icon;
  final String? avatarUrl;
  final VoidCallback onTap;
  final bool isChild;
  final bool isSelected;

  const DrawerCard({
    super.key,
    required this.title,
    this.icon,
    this.avatarUrl,
    required this.onTap,
    this.isChild = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.kSecondaryColor.withValues(alpha: 0.1)
                  : AppColors.kTransparentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon or Avatar
            if (isChild)
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.kSecondaryColor
                            : AppColors.kTransparentColor,
                    width: 2,
                  ),
                ),
                child:
                    avatarUrl != null && avatarUrl!.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: Image.network(
                            avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return CircleAvatar(
                                backgroundColor: AppColors.kPrimaryColor
                                    .withValues(alpha: 0.2),
                                child: Text(
                                  title.isNotEmpty
                                      ? title[0].toUpperCase()
                                      : "?",
                                  style: AppStyles.text18PxBold.copyWith(
                                    color: AppColors.kPrimaryColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        : CircleAvatar(
                          backgroundColor: AppColors.kPrimaryColor.withValues(
                            alpha: 0.2,
                          ),
                          child: Text(
                            title.isNotEmpty ? title[0].toUpperCase() : "?",
                            style: AppStyles.text18PxBold.copyWith(
                              color: AppColors.kPrimaryColor,
                            ),
                          ),
                        ),
              )
            else
              SvgHelper.fromSource(
                path: icon ?? Assets.profile,
                height: 32,
                width: 32,
                color: isSelected ? AppColors.kSecondaryColor : null,
              ),

            Gaps.horizontalGapOf(16),

            // Title
            Expanded(
              child: Text(
                title,
                style: AppStyles.text14PxMedium.copyWith(
                  color:
                      isSelected
                          ? AppColors.kSecondaryColor
                          : AppColors.kPitchBlack,
                ),
              ),
            ),

            // Show arrow icon for non-child items
            if (!isChild)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.kGrey,
              ),

            // For child items, show yellow badge
            if (isChild && isSelected)
              Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(
                  color: AppColors.kYellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  size: 16,
                  color: AppColors.kWhite,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
