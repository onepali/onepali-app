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

    // double valueFontSize = isTablet ? 48 : 30;
    double imageSize = isTablet ? 100 : 55;
    double padding = isTablet ? 24 : 18;
    // double marginHorizontal = isTablet ? 50 : 10;
    // double marginVertical = isTablet ? 0 : 10;
    double borderRadius = isTablet ? 20.0 : 12.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1, // 10% of screen width
          right: MediaQuery.of(context).size.width * 0.1, // 10% of screen width
          top: 0,
          bottom: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
        ),
        width: 20.h(context),
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
            children: [
              // Top section with value
              Text(
                dynamicValue,
                textAlign: TextAlign.center,
                style: AppStyles.text30PxSemiBold.copyWith(
                  fontSize: 64,
                  // fontWeight: FontWeight.bold,
                  color: AppColors.kBlack,
                ),
              ),
              Text(
                achievement.subtitle,
                textAlign: TextAlign.center,
                style: AppStyles.text24PxMedium.copyWith(
                  // fontSize: subtitleFontSize,
                  fontFamily: AppConstants.kDMSansFont,
                  color: AppColors.kBlack,
                ),
              ),

              Gaps.verticalGapOf(45),

              // Middle - Icon
              Center(
                child: CustomImage(
                  achievement.imageUrl,
                  boxFit: BoxFit.contain,
                  width: imageSize,
                  height: imageSize,
                  imageType: CustomImageType.local,
                ),
              ),

              const Spacer(),

              // Bottom section with title
              Text(
                achievement.title,
                style: AppStyles.text24PxBold.copyWith(
                  // fontSize: titleFontSize,
                  height: 1.3,
                  color: AppColors.kBlack,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
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
