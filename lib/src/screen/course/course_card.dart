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
      child: LayoutBuilder(
        builder: (context, outerConstraints) {
          final cardHeight = outerConstraints.maxHeight.isFinite
              ? outerConstraints.maxHeight
              : AppCardResponsive.getLessonCardHeight(context);
          
          return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
            height: cardHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableHeight = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : cardHeight;
            
            // Calculate sizes based on card height (availableHeight = card height)
            // Percentages are relative to card height:
            // - Thumbnail: 65% of card height
            // - Gap: 0.5% of card height  
            // - Text: 27% of card height
            // Total: 92.5% of card height - well within bounds, no overflow possible
            // These percentages match AppCardResponsive for consistency across mobile and tablet
            final thumbnailHeight = availableHeight * 0.65;
            final thumbnailWidth = thumbnailHeight;
            final gapHeight = availableHeight * 0.005;
            final textHeight = availableHeight * 0.27;
            
            return Stack(
          children: [
                ClipRect(
                  child: SizedBox(
                    height: availableHeight,
                    width: double.infinity,
                    child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                children: [
                  if (thumbnail != null)
                            ClipRect(
                              child: SizedBox(
                                height: thumbnailHeight,
                                width: thumbnailWidth,
                                child: CustomImage(
                      thumbnail!,
                                  width: thumbnailWidth,
                      cover: false,
                                  height: thumbnailHeight,
                      imageType: CustomImageType.network,
                      circular: false,
                    ),
                    ),
                    ),
                          SizedBox(height: gapHeight),
                          SizedBox(
                            height: textHeight,
                            child: Center(
                    child: Text(
                      title,
                      style: AppStyles.text16PxMedium.copyWith(
                        fontSize: isTabletLandscape ? 24 : 16,
                      ),
                      textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                    ),
                  ),
                ],
                      ),
                    ),
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
            );
              },
        ),
          );
        },
      ),
    );
  }
}
