import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final String dynamicValue;
  final VoidCallback? onTap;
  final bool useFullHeight;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.dynamicValue,
    this.onTap,
    this.useFullHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Responsive values
    final double cardWidth = isMobileLandscape ? 130 : 320;
    final double cardHeight =
        useFullHeight ? double.infinity : (isMobileLandscape ? 180 : 220);
    final double titleFontSize = isMobileLandscape ? 16 : 18;
    final double valueFontSize = isMobileLandscape ? 28 : 32;
    final double imageSize = isMobileLandscape ? 50 : 60;
    final double padding = isMobileLandscape ? 16 : 20;
    final double borderRadius = 12.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: useFullHeight ? null : cardHeight,
        margin: EdgeInsets.symmetric(
          horizontal: isMobileLandscape ? 8 : 12,
          vertical: isMobileLandscape ? 8 : 12,
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

              // Middle - Icon (takes remaining space)
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
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
              Gaps.verticalGapOf(40),
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
