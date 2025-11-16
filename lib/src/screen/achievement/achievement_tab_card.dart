import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AchievementTabCard extends StatelessWidget {
  final AchievementModel achievement;
  final String dynamicValue;
  final VoidCallback? onTap;

  const AchievementTabCard({
    super.key,
    required this.achievement,
    required this.dynamicValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        
        // Responsive sizing based on available space
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        
        // Calculate font sizes as percentages of available height
        final valueFontSize = (availableHeight * 0.15).clamp(24.0, 64.0);
        final subtitleFontSize = (availableHeight * 0.05).clamp(12.0, 24.0);
        final titleFontSize = (availableHeight * 0.06).clamp(14.0, 24.0);
        final imageSize = (availableHeight * 0.20).clamp(40.0, 100.0);
        final padding = (availableHeight * 0.03).clamp(12.0, 24.0);
        final gapSize = (availableHeight * 0.06).clamp(8.0, 45.0);
        final borderRadius = isTablet ? 20.0 : 12.0;
        
        // Calculate margins as percentages
        final marginHorizontal = screenWidth * 0.1;
        final marginVertical = screenHeight * 0.05;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(
              left: marginHorizontal,
              right: marginHorizontal,
              top: 0,
              bottom: marginVertical,
            ),
            constraints: BoxConstraints(
              maxHeight: availableHeight - marginVertical,
              maxWidth: availableWidth - (marginHorizontal * 2),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                        color: AppColors.kBlack,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      achievement.subtitle,
                      textAlign: TextAlign.center,
                      style: AppStyles.text24PxMedium.copyWith(
                        fontSize: subtitleFontSize,
                        fontFamily: AppConstants.kDMSansFont,
                        color: AppColors.kBlack,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: gapSize),

                  // Middle - Icon
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: CustomImage(
                        achievement.imageUrl,
                        boxFit: BoxFit.contain,
                        width: imageSize,
                        height: imageSize,
                        imageType: CustomImageType.local,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom section with title
                  Flexible(
                    child: Text(
                      achievement.title,
                      style: AppStyles.text24PxBold.copyWith(
                        fontSize: titleFontSize,
                        height: 1.3,
                        color: AppColors.kBlack,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
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
