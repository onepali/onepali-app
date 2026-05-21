import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final String dynamicValue;
  final VoidCallback? onTap;
  final double? fixedHeight;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.dynamicValue,
    this.onTap,
    this.fixedHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Get screen dimensions for calculations
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Container height is 80% of screen height (from achievement_screen.dart)
    final containerHeight = screenHeight * 0.8;

    // Responsive values based on screen dimensions (relative sizing)
    double cardWidth;
    double cardHeight;
    if (isMobileLandscape) {
      cardWidth =
          screenWidth * 0.20; // ~20% of screen width (equivalent to 20.w)
      cardHeight = double.infinity; // Fill container height
    } else if (isTabletLandscape) {
      cardWidth = screenWidth * 0.15; // Relative to screen
      cardHeight = double.infinity; // Fill container height
    } else {
      cardWidth = screenWidth * 0.45; // ~45% of screen width for portrait
      cardHeight = double.infinity; // Fill container height
    }

    // Calculate all sizes as percentages of container height (80% of screen)
    final valueFontSize = containerHeight * 0.12;
    final subtitleFontSize = containerHeight * 0.05;
    final titleFontSize =
        containerHeight * 0.045; // Reduced to prevent overflow
    final imageSize = containerHeight * 0.25;
    final padding = containerHeight * 0.04;
    final gapSize = containerHeight * 0.02;
    final marginHorizontal = cardWidth * 0.05;
    final marginVertical = containerHeight * 0.01;
    final double borderRadius = cardWidth * 0.06;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
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
              // Subtitle
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
  }
}
