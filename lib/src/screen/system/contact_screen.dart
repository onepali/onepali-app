import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class ContactScreen extends StatelessWidget {
  final ContactModel? contactData;

  const ContactScreen({super.key, this.contactData});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = PlatformUtility.isMobile(context);
    final bool isMobilePortrait =
        isMobile && PlatformUtility.isPortrait(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double containerPadding =
        isMobile ? (isMobilePortrait ? 16.0 : 32.0) : 40.0;
    final double verticalGap = isMobile ? (isMobilePortrait ? 16 : 24) : 32;

    final TextStyle noDataStyle =
        isMobile
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

    final TextStyle titleStyle =
        isMobile
            ? (isMobilePortrait
                ? AppStyles.text16PxSemiBold.copyWith(
                  height: 1.6,
                  fontFamily: AppConstants.kDMSansFont,
                  color: AppColors.kDrawerBgColor,
                )
                : AppStyles.text20PxBold.copyWith(
                  fontFamily: AppConstants.kDMSansFont,
                  color: AppColors.kDrawerBgColor,
                ))
            : AppStyles.text24PxBold.copyWith(
              fontFamily: AppConstants.kDMSansFont,
              color: AppColors.kDrawerBgColor,
            );

    final TextStyle infoStyle =
        isMobile
            ? (isMobilePortrait
                ? AppStyles.text16PxRegular.copyWith(
                  height: 1.6,
                  fontFamily: AppConstants.kDMSansFont,
                  color: AppColors.kDrawerBgColor,
                )
                : AppStyles.text20PxRegular.copyWith(
                  height: 1.6,
                  fontFamily: AppConstants.kDMSansFont,
                  color: AppColors.kDrawerBgColor,
                ))
            : AppStyles.text22PxRegular.copyWith(
              height: 1.7,
              fontFamily: AppConstants.kDMSansFont,
              color: AppColors.kDrawerBgColor,
            );

    if (contactData == null) {
      return Center(
        child: Text('No contact information available', style: noDataStyle),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contactData?.title ?? 'Need help or have suggestions?',
            style: titleStyle,
          ),
          Gaps.verticalGapOf(verticalGap),
          Text(contactData!.info, style: infoStyle),
          // Gaps.verticalGapOf(isMobilePortrait ? 100 : 150),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Container(
          //     width: isMobilePortrait ? 100 : 140,
          //     height: isMobilePortrait ? 100 : 140,
          //     decoration: BoxDecoration(
          //       color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
          //       borderRadius: BorderRadius.circular(isMobilePortrait ? 50 : 70),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
