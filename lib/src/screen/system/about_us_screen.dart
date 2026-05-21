import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AboutUsScreen extends StatelessWidget {
  final AboutModel? aboutData;

  const AboutUsScreen({super.key, this.aboutData});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = PlatformUtility.isMobile(context);
    final bool isMobilePortrait =
        isMobile && PlatformUtility.isPortrait(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double containerPadding = isMobile
        ? (isMobilePortrait ? 16.0 : 32.0)
        : 40.0;

    final TextStyle noDataStyle = isMobile
        ? (isMobilePortrait
              ? AppStyles.text16PxRegular.copyWith(
                  color: Colors.grey,
                  fontFamily: AppConstants.kDMSansFont,
                )
              : AppStyles.text20PxRegular.copyWith(
                  color: Colors.grey,
                  fontFamily: AppConstants.kDMSansFont,
                ))
        : AppStyles.text24PxRegular.copyWith(
            color: Colors.grey,
            fontFamily: AppConstants.kDMSansFont,
          );

    final TextStyle infoStyle = isMobile
        ? (isMobilePortrait
              ? AppStyles.text16PxRegular.copyWith(
                  height: 1.6,
                  color: AppColors.kDrawerBgColor,
                  fontFamily: AppConstants.kDMSansFont,
                )
              : AppStyles.text20PxRegular.copyWith(
                  height: 1.6,
                  color: AppColors.kDrawerBgColor,
                  fontFamily: AppConstants.kDMSansFont,
                ))
        : AppStyles.text22PxRegular.copyWith(
            height: 1.7,
            color: AppColors.kDrawerBgColor,
            fontFamily: AppConstants.kDMSansFont,
          );

    if (aboutData == null) {
      return Center(
        child: Text('No about information available', style: noDataStyle),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   aboutData?.title ?? 'Hello from O Nepali!',
          //   style:
          //       isMobilePortrait
          //           ? AppStyles.text24PxBold.copyWith(
          //             color: AppColors.kSecondaryColor,
          //           )
          //           : AppStyles.text32PxBold.copyWith(
          //             color: AppColors.kSecondaryColor,
          //           ),
          // ),
          // Gaps.verticalGapOf(isMobilePortrait ? 16 : 24),
          Text(aboutData?.info ?? "", style: infoStyle),

          // Gaps.verticalGapOf(isMobilePortrait ? 24 : 32),
          // Container(
          //   width: double.infinity,
          //   padding: EdgeInsets.all(isMobilePortrait ? 16 : 24),
          //   decoration: BoxDecoration(
          //     color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
          //     borderRadius: BorderRadius.circular(isMobilePortrait ? 12 : 16),
          //     border: Border.all(
          //       color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
          //     ),
          //   ),
          //   child: Text(
          //     aboutData?.tip ?? "Thank you for being a part of our community!",
          //     style:
          //         isMobilePortrait
          //             ? AppStyles.text16PxMedium.copyWith(
          //               color: AppColors.kSecondaryColor,
          //             )
          //             : AppStyles.text20PxMedium.copyWith(
          //               color: AppColors.kSecondaryColor,
          //             ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
        ],
      ),
    );
  }
}
