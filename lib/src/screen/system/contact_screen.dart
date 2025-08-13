import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class ContactScreen extends StatelessWidget {
  final ContactModel? contactData;

  const ContactScreen({super.key, this.contactData});

  @override
  Widget build(BuildContext context) {
    final bool isMobilePortrait =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isPortrait(context);

    if (contactData == null) {
      return Center(
        child: Text(
          'No contact information available',
          style:
              isMobilePortrait
                  ? AppStyles.text16PxRegular.copyWith(color: Colors.grey)
                  : AppStyles.text20PxRegular.copyWith(color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobilePortrait ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contactData?.title ?? 'Need help or have suggestions?',
            style:
                isMobilePortrait
                    ? AppStyles.text16PxSemiBold.copyWith(
                      height: 1.6,
                      color: AppColors.kBlack,
                    )
                    : AppStyles.text20PxBold.copyWith(
                      color: AppColors.kSecondaryColor,
                    ),
          ),
          Gaps.verticalGapOf(isMobilePortrait ? 16 : 24),
          Text(
            contactData!.info,
            style:
                isMobilePortrait
                    ? AppStyles.text16PxRegular.copyWith(
                      height: 1.6,
                      color: AppColors.kBlack,
                    )
                    : AppStyles.text20PxRegular.copyWith(
                      height: 1.6,
                      color: AppColors.kBlack,
                    ),
          ),
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
