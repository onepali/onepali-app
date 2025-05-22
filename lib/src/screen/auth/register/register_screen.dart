import 'package:flutter/material.dart';

import '../../../src.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 32.0,
          bottom: 0.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to O Nepali!',
              style: AppStyles.text24PxSemiBold,
              textAlign: TextAlign.center,
            ),
            Gaps.verticalGapOf(8),
            Text(
              "Let's get started in 2 simple steps",
              style: AppStyles.text14PxMedium.copyWith(
                color: AppColors.kPitchBlack,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.verticalGapOf(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(Icons.circle, color: AppColors.kButtonGreen, size: 16),
                    Container(
                      width: 4,
                      height: 25,
                      color: AppColors.kLightGrey,
                    ),
                    Icon(Icons.circle, color: AppColors.kButtonGreen, size: 16),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Understand your journey',
                      style: AppStyles.text14PxRegular.copyWith(
                        color: AppColors.kPitchBlack,
                      ),
                    ),
                    Gaps.verticalGapOf(18),
                    Text(
                      'Create your account',
                      style: AppStyles.text14PxRegular.copyWith(
                        color: AppColors.kPitchBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            SvgHelper.fromSource(path: Assets.leoChracterSvg, height: 220),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
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
                  Utility.navigateMaterialRoute(context, RS1Screen());
                },
                elevation: 0,
                showBorder: false,
                backgroundColor: AppColors.kButtonGreen,
                width: double.infinity,
              ),
        ),
      ),
    );
  }
}
