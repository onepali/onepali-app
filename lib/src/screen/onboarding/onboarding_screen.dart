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
    // Responsive variables
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final topSpacing = isTabletPortrait ? 120.0 : 100.0;
    final logoContainerSize = isTabletPortrait ? 240.0 : 150.0;
    final logoSize = isTabletPortrait ? 200.0 : 100.0;
    final brandLogoWidth = isTabletPortrait ? 120.0 : 40.0;
    final brandLogoHeight = isTabletPortrait ? 70.0 : 35.0;
    final taglineGap = isTabletPortrait ? 12.0 : 8.0;
    final buttonGap = isTabletPortrait ? 16.0 : 10.0;
    final containerPadding = isTabletPortrait ? 32.0 : 20.0;
    final buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final buttonRadius = isTabletPortrait ? 12.0 : 8.0;
    final taglineStyle =
        isTabletPortrait ? AppStyles.text24PxMedium : AppStyles.text14PxMedium;
    final buttonTextStyle =
        isTabletPortrait ? AppStyles.text20PxMedium : AppStyles.text16PxMedium;

    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (index, value) {
          doubleTapTrigger();
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.kWhite),
            padding: EdgeInsets.all(containerPadding),
            child: Column(
              children: [
                Gaps.verticalGapOf(topSpacing),
                Container(
                  height: logoContainerSize,
                  width: logoContainerSize,
                  padding: EdgeInsets.all(isTabletPortrait ? 40.0 : 30.0),
                  // decoration: BoxDecoration(
                  //   color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                  //   shape: BoxShape.circle,
                  // ),
                  child: SvgHelper.fromSource(
                    path: Assets.leoSvg,
                    width: logoSize,
                    height: logoSize,
                  ),
                ),
                SvgHelper.fromSource(
                  path: Assets.logoSvg,
                  width: brandLogoWidth,
                  height: brandLogoHeight,
                  color: AppColors.kBlack,
                ),
                Gaps.verticalGapOf(taglineGap),
                Text(
                  context.tr('tagline'),
                  style: taglineStyle.copyWith(color: AppColors.kPrimaryColor),
                  textAlign: TextAlign.center,
                ),
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
                      height: buttonHeight,
                      width: double.infinity,
                      textStyle: buttonTextStyle,
                      showBorder: false,
                      backgroundColor: AppColors.kButtonGreen,
                      radius: buttonRadius,
                    ),
                    Gaps.verticalGapOf(buttonGap),
                    CustomMaterialButton(
                      label: context.tr('create_account'),
                      onTap: () {
                        Utility.navigate(context, AppRoutes.registerScreen);
                      },
                      elevation: 0,
                      height: buttonHeight,
                      width: double.infinity,
                      showBorder: false,
                      textStyle: buttonTextStyle,
                      backgroundColor: AppColors.kButtonGrey,
                      radius: buttonRadius,
                    ),
                    Gaps.verticalGapOf(buttonGap),

                    CustomMaterialButton(
                      label: context.tr('try_lesson_guest'),
                      onTap: () {
                        UserAppBar.setTabIndex(0);
                        Utility.navigate(
                          context,
                          AppRoutes.guestDashboardScreen,
                        );
                      },
                      elevation: 0,
                      height: buttonHeight,
                      width: double.infinity,
                      textStyle: buttonTextStyle,
                      showBorder: false,
                      backgroundColor: AppColors.kButtonGrey,
                      radius: buttonRadius,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
