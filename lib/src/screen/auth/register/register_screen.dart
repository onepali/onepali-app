import 'package:flutter/material.dart';

import '../../../src.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double topPadding = isTabletPortrait ? 48.0 : 32.0;

    return Scaffold(
      appBar: CustomAppBar(title: ''),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          top: topPadding,
          bottom: 0.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to O Nepali!',
              style:
                  isTabletPortrait
                      ? AppStyles.text28PxBold
                      : AppStyles.text24PxSemiBold,
              textAlign: TextAlign.center,
            ),
            Gaps.verticalGapOf(isTabletPortrait ? 12 : 8),
            Text(
              "Let's get started in 2 simple steps",
              style: (isTabletPortrait
                      ? AppStyles.text16PxMedium
                      : AppStyles.text14PxMedium)
                  .copyWith(color: AppColors.kPitchBlack),
              textAlign: TextAlign.center,
            ),
            Gaps.verticalGapOf(isTabletPortrait ? 32 : 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.circle,
                      color: AppColors.kButtonGreen,
                      size: isTabletPortrait ? 20 : 16,
                    ),
                    Container(
                      width: isTabletPortrait ? 5 : 4,
                      height: isTabletPortrait ? 32 : 25,
                      color: AppColors.kLightGrey,
                    ),
                    Icon(
                      Icons.circle,
                      color: AppColors.kButtonGreen,
                      size: isTabletPortrait ? 20 : 16,
                    ),
                  ],
                ),
                Gaps.horizontalGapOf(isTabletPortrait ? 20 : 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Understand your journey',
                      style: (isTabletPortrait
                              ? AppStyles.text16PxRegular
                              : AppStyles.text14PxRegular)
                          .copyWith(color: AppColors.kPitchBlack),
                    ),
                    Gaps.verticalGapOf(isTabletPortrait ? 24 : 18),
                    Text(
                      'Create your account',
                      style: (isTabletPortrait
                              ? AppStyles.text16PxRegular
                              : AppStyles.text14PxRegular)
                          .copyWith(color: AppColors.kPitchBlack),
                    ),
                  ],
                ),
              ],
            ),
            Gaps.verticalGapOf(isTabletPortrait ? 120 : 100),
            SvgHelper.fromSource(
              path: Assets.leoChracterSvg,
              height: isTabletPortrait ? 280 : 220,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(isTabletPortrait ? 24.0 : 16.0),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            boxShadow: [
              BoxShadow(
                color: AppColors.kGrey.withValues(alpha: 0.2),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: Builder(
            builder:
                (context) => CustomMaterialButton(
                  label: 'Continue',
                  onTap: () {
                    Utility.navigate(context, AppRoutes.rs1Screen);
                  },
                  elevation: 0,
                  showBorder: false,
                  backgroundColor: AppColors.kButtonGreen,
                  width: double.infinity,
                  textStyle:
                      isTabletPortrait
                          ? AppStyles.text18PxMedium
                          : AppStyles.text16PxMedium,
                ),
          ),
        ),
      ),
    );
  }
}
