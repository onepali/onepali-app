import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AboutUsScreen extends StatelessWidget {
  final AboutModel? aboutData;

  const AboutUsScreen({super.key, this.aboutData});

  @override
  Widget build(BuildContext context) {
    final bool isMobilePortrait =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isPortrait(context);

    if (aboutData == null) {
      return Center(
        child: Text(
          'No about information available',
          style:
              isMobilePortrait
                  ? AppStyles.text16PxRegular.copyWith(
                    color: Colors.grey,
                    fontFamily: AppConstants.kDMSansFont,
                  )
                  : AppStyles.text20PxRegular.copyWith(
                    color: Colors.grey,
                    fontFamily: AppConstants.kDMSansFont,
                  ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobilePortrait ? 16.0 : 32.0),
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
          Text(
            aboutData?.info ?? "",
            style:
                isMobilePortrait
                    ? AppStyles.text16PxRegular.copyWith(
                      height: 1.6,
                      color: AppColors.kDrawerBgColor,
                      fontFamily: AppConstants.kDMSansFont,
                    )
                    : AppStyles.text20PxRegular.copyWith(
                      height: 1.6,
                      color: AppColors.kDrawerBgColor,
                      fontFamily: AppConstants.kDMSansFont,
                    ),
          ),

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
