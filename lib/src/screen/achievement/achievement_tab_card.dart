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
        
        // Calculate fixed card height based on available space
        final cardHeight = availableHeight * 0.95;
        final cardWidth = availableWidth - (availableWidth * 0.1); // Account for margins
        
        // Calculate font sizes as percentages of card height (no hardcoded clamps)
        final valueFontSize = cardHeight * 0.12;
        final subtitleFontSize = cardHeight * 0.05;
        final titleFontSize = cardHeight * 0.038; // Further reduced to prevent overflow
        final imageSize = cardHeight * 0.20;
        final padding = cardHeight * 0.04;
        final gapSize = cardHeight * 0.015; // Reduced gaps
        final borderRadius = cardWidth * 0.06;
        
        // Calculate margins as percentages of screen dimensions - reduced
        final marginHorizontal = screenWidth * 0.03; // Reduced from 0.05
        final marginVertical = screenHeight * 0.015; // Reduced from 0.02

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: marginHorizontal,
          right: marginHorizontal,
          top: 0,
          bottom: marginVertical,
        ),
        height: cardHeight,
        constraints: BoxConstraints(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Top section with value - allocate space for value text
              SizedBox(
                height: valueFontSize * 1.5,
                child: Center(
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
              ),
              SizedBox(height: gapSize),
              // Subtitle - allocate enough space for 2 lines with line height
              SizedBox(
                height: subtitleFontSize * 3.0,
                child: Center(
                  child: Text(
                    achievement.subtitle,
                    textAlign: TextAlign.center,
                    style: AppStyles.text24PxMedium.copyWith(
                      fontSize: subtitleFontSize,
                      fontFamily: AppConstants.kDMSansFont,
                      color: AppColors.kBlack,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(height: gapSize),

              // Middle - Icon - use fixed size, not Expanded to prevent overlap
              SizedBox(
                height: imageSize,
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

              SizedBox(height: gapSize),

              // Bottom section with title - allocate more space for 2 lines
              SizedBox(
                height: titleFontSize * 3.5, // Increased space allocation
                child: Center(
                  child: Text(
                    achievement.title,
                    style: AppStyles.text24PxBold.copyWith(
                      fontSize: titleFontSize,
                      height: 1.15, // Further reduced line height
                      color: AppColors.kBlack,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
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
