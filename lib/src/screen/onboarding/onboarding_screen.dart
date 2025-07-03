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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (index, value) {
        doubleTapTrigger();
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          padding: 20.p,
          child: Column(
            children: [
              Gaps.verticalGapOf(100),
              Container(
                height: 150,
                width: 150,
                padding: 30.p,
                // decoration: BoxDecoration(
                //   color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                //   shape: BoxShape.circle,
                // ),
                child: SvgHelper.fromSource(
                  path: Assets.leoSvg,
                  width: 100,
                  height: 100,
                ),
              ),
              SvgHelper.fromSource(
                path: Assets.logoSvg,
                width: 40,
                height: 35,
                color: AppColors.kBlack,
              ),
              Gaps.verticalGapOf(8),
              Text(context.tr('tagline'), style: AppStyles.text14PxMedium),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomMaterialButton(
                    label: context.tr('login'),
                    onTap: () {
                      Utility.navigate(context, AppRoutes.loginScreen);
                    },
                    elevation: 0,

                    width: double.infinity,
                    textStyle: AppStyles.text16PxMedium,
                    showBorder: false,
                    backgroundColor: AppColors.kButtonGreen,
                    radius: 8,
                  ),
                  Gaps.verticalGapOf(10),
                  CustomMaterialButton(
                    label: context.tr('create_account'),
                    onTap: () {
                      Utility.navigate(context, AppRoutes.registerScreen);
                    },
                    elevation: 0,

                    width: double.infinity,
                    showBorder: false,
                    textStyle: AppStyles.text16PxMedium,
                    backgroundColor: AppColors.kButtonGrey,
                    radius: 8,
                  ),
                  Gaps.verticalGapOf(10),

                  CustomMaterialButton(
                    label: context.tr('try_lesson_guest'),
                    onTap: () {},
                    elevation: 0,

                    width: double.infinity,
                    textStyle: AppStyles.text16PxMedium,
                    showBorder: false,
                    backgroundColor: AppColors.kButtonGrey,
                    radius: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
