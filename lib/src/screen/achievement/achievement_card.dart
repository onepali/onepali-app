import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final String dynamicValue;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.dynamicValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        
        // Responsive values based on available space
        double cardWidth;
        if (isMobileLandscape) {
          cardWidth = (availableWidth * 0.25).clamp(150.0, 200.0);
        } else if (isTabletLandscape) {
          cardWidth = (availableWidth * 0.20).clamp(180.0, 220.0);
        } else {
          cardWidth = (availableWidth * 0.45).clamp(180.0, 220.0);
        }
        
        // Calculate font sizes as percentages of available height
        final valueFontSize = (availableHeight * 0.12).clamp(20.0, 32.0);
        final subtitleFontSize = (availableHeight * 0.04).clamp(12.0, 18.0);
        final titleFontSize = (availableHeight * 0.05).clamp(14.0, 20.0);
        final imageSize = (availableHeight * 0.25).clamp(40.0, 80.0);
        final padding = (availableHeight * 0.03).clamp(12.0, 20.0);
        final gapSize = (availableHeight * 0.02).clamp(4.0, 16.0);
        final marginHorizontal = 8.0;
        final marginVertical = 5.0;
        final double borderRadius = 12.0;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: cardWidth,
            constraints: BoxConstraints(
              maxHeight: availableHeight - (marginVertical * 2),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: marginHorizontal,
              vertical: marginVertical,
            ),
            decoration: BoxDecoration(
              color: achievement.color ?? AppColors.kPrimaryColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color:
                      achievement.color?.withValues(alpha: 0.3) ??
                      AppColors.kPrimaryColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top section with value
                  Flexible(
                    child: Text(
                      dynamicValue,
                      textAlign: TextAlign.center,
                      style: AppStyles.text30PxSemiBold.copyWith(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: gapSize),
                  Flexible(
                    child: Text(
                      achievement.subtitle,
                      textAlign: TextAlign.center,
                      style: AppStyles.text16PxRegular.copyWith(
                        fontSize: subtitleFontSize,
                        fontFamily: AppConstants.kDMSansFont,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Middle - Icon (takes remaining space)
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: CustomImage(
                        achievement.imageUrl,
                        boxFit: BoxFit.contain,
                        width: imageSize,
                        height: imageSize,
                        imageType: CustomImageType.local,
                      ),
                    ),
                  ),

                  // Bottom section with title
                  SizedBox(height: gapSize),
                  Flexible(
                    child: Text(
                      achievement.title,
                      style: AppStyles.text18PxMedium.copyWith(
                        fontSize: titleFontSize,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
