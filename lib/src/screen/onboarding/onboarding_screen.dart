import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        padding: 20.p,
        child: Column(
          children: [
            Gaps.verticalGapOf(100),
            AnimatedSolidColorBorder(
              size: 150,
              borderWidth: 6,
              child: Container(
                height: 138,
                width: 138,
                padding: 30.p,
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgHelper.fromSource(
                  path: Assets.leoSvg,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Gaps.verticalGapOf(30),
            SvgHelper.fromSource(path: Assets.logoSvg, width: 40, height: 30),
            Gaps.verticalGapOf(8),
            Text(context.tr('tagline'), style: AppStyles.text14PxRegular),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomMaterialButton(
                  label: context.tr('login'),
                  onTap: () {},
                  elevation: 0,

                  width: double.infinity,
                  textStyle: AppStyles.text16PxMedium.copyWith(
                    color: AppColors.kWhite,
                  ),
                  showBorder: false,
                  backgroundColor: AppColors.kButtonGreen,
                  radius: 8,
                ),
                Gaps.verticalGapOf(10),
                CustomMaterialButton(
                  label: context.tr('create_account'),
                  onTap: () {},
                  elevation: 0,

                  width: double.infinity,
                  showBorder: false,
                  textStyle: AppStyles.text16PxMedium.copyWith(
                    color: AppColors.kPitchBlack,
                  ),
                  backgroundColor: AppColors.kButtonGrey,
                  radius: 8,
                ),
                Gaps.verticalGapOf(10),

                CustomMaterialButton(
                  label: context.tr('try_lesson_guest'),
                  onTap: () {},
                  elevation: 0,

                  width: double.infinity,
                  textStyle: AppStyles.text16PxMedium.copyWith(
                    color: AppColors.kPitchBlack,
                  ),
                  showBorder: false,
                  backgroundColor: AppColors.kButtonGrey,
                  radius: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
