import 'package:flutter/material.dart';

import '../../src.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String? thumbnail;
  final Color color;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isGuestUser;

  const CourseCard({
    super.key,
    required this.title,
    this.thumbnail,
    required this.color,
    this.isLocked = false,
    this.isCompleted = false,
    this.onTap,
    this.trailing,
    this.isGuestUser = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    logger.d(
      'CourseCard: title: $title, isLocked: $isLocked, isCompleted: $thumbnail',
    );
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (thumbnail != null)
                    CustomImage(
                      thumbnail!,
                      width: AppCardResponsive.getThumbnailWidth(context),
                      cover: false,
                      height: AppCardResponsive.getThumbnailHeight(context),
                      imageType: CustomImageType.network,
                      circular: false,
                    ),
                  Gaps.verticalGapOf(30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kWhite,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      title,
                      style: AppStyles.text16PxMedium.copyWith(
                        fontSize: isTabletLandscape ? 24 : 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: AppColors.kWhite,
                  radius: 14,
                  child: Icon(
                    Icons.check,
                    color: AppColors.kButtonGreen,
                    size: 18,
                  ),
                ),
              ),
            if (isLocked)
              Positioned(
                top: 12,
                right: 12,
                child: Icon(Icons.lock, color: AppColors.kBlack, size: 22),
              ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
