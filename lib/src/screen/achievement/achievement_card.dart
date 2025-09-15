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

    // Responsive values based on device and orientation
    double cardWidth;
    double cardHeight;
    double titleFontSize;
    double valueFontSize;
    double imageSize;
    double padding;
    double marginHorizontal;
    double marginVertical;

    if (isMobileLandscape) {
      cardWidth = 20.w(context);
      cardHeight = double.infinity;
      titleFontSize = 16;
      valueFontSize = 28;
      imageSize = 65;
      padding = 16;
      marginHorizontal = 8;
      marginVertical = 5;
    } else if (isTabletLandscape) {
      cardWidth = 200;
      cardHeight = double.infinity;
      titleFontSize = 17;
      valueFontSize = 30;
      imageSize = 55;
      padding = 18;
      marginHorizontal = 10;
      marginVertical = 10;
    } else {
      cardWidth = 200;
      cardHeight = double.infinity;
      titleFontSize = 17;
      valueFontSize = 30;
      imageSize = 55;
      padding = 18;
      marginHorizontal = 10;
      marginVertical = 10;
    }

    final double borderRadius = 12.0;

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
              Text(
                dynamicValue,
                textAlign: TextAlign.center,
                style: AppStyles.text30PxSemiBold.copyWith(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.verticalGapOf(isMobileLandscape ? 8 : 12),
              Text(
                achievement.subtitle,
                textAlign: TextAlign.center,
                style: AppStyles.text16PxRegular.copyWith(
                  fontFamily: AppConstants.kDMSansFont,
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
              Gaps.verticalGapOf(16),
              Text(
                achievement.title,
                style: AppStyles.text18PxMedium.copyWith(
                  fontSize: titleFontSize,
                  height: 1.3,
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
