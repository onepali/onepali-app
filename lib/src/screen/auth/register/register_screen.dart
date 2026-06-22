import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../src.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _player = AudioPlayer();
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double topPadding = isTabletPortrait ? 48.0 : 32.0;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;
    final double titleGap = isTabletPortrait ? 12.0 : 8.0;
    final double subtitleGap = isTabletPortrait ? 32.0 : 24.0;
    final double stepGap = isTabletPortrait ? 28.0 : 18.0;
    final double charactersGap = isTabletPortrait ? 200.0 : 100.0;
    final double characterHeight = isTabletPortrait ? 380.0 : 220.0;
    final double stepIconSize = isTabletPortrait ? 20.0 : 16.0;
    final double stepLineWidth = isTabletPortrait ? 5.0 : 4.0;
    final double stepLineHeight = isTabletPortrait ? 40.0 : 25.0;
    final double stepTextSpacing = isTabletPortrait ? 20.0 : 16.0;
    final double bottomPadding = isTabletPortrait ? 24.0 : 16.0;

    final TextStyle buttonTextStyle = isTabletPortrait
        ? AppStyles.text20PxMedium
        : AppStyles.text16PxMedium;
    final TextStyle titleStyle = isTabletPortrait
        ? AppStyles.text32PxBold
        : AppStyles.text24PxSemiBold;
    final TextStyle subtitleStyle =
        (isTabletPortrait ? AppStyles.text18PxMedium : AppStyles.text14PxMedium)
            .copyWith(color: AppColors.kPitchBlack);
    final TextStyle stepTextStyle =
        (isTabletPortrait
                ? AppStyles.text18PxRegular
                : AppStyles.text14PxRegular)
            .copyWith(color: AppColors.kPitchBlack);
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
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            Gaps.verticalGapOf(titleGap),
            Text(
              "Let's get started in 2 simple steps",
              style: subtitleStyle,
              textAlign: TextAlign.center,
            ),
            Gaps.verticalGapOf(subtitleGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.circle,
                      color: AppColors.kButtonGreen,
                      size: stepIconSize,
                    ),
                    Container(
                      width: stepLineWidth,
                      height: stepLineHeight,
                      color: AppColors.kLightGrey,
                    ),
                    Icon(
                      Icons.circle,
                      color: AppColors.kButtonGreen,
                      size: stepIconSize,
                    ),
                  ],
                ),
                Gaps.horizontalGapOf(stepTextSpacing),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Understand your journey', style: stepTextStyle),
                    Gaps.verticalGapOf(stepGap),
                    Text('Create your account', style: stepTextStyle),
                  ],
                ),
              ],
            ),
            Gaps.verticalGapOf(charactersGap),
            SvgHelper.fromSource(
              path: Assets.leoChracterSvg,
              height: characterHeight,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: bottomPadding,
            vertical: bottomPadding,
          ),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            // boxShadow: [
            //   BoxShadow(
            //     color: AppColors.kGrey.withValues(alpha: 0.2),
            //     spreadRadius: 0,
            //     blurRadius: 2,
            //     offset: Offset(0, -1),
            //   ),
            // ],
          ),
          child: Builder(
            builder: (context) => CustomMaterialButton(
              label: 'Continue',
              onTap: () {
                Utility.navigate(context, AppRoutes.rs1Screen);
              },
              elevation: 0,
              radius: buttonRadius,
              height: buttonHeight,
              showBorder: false,
              backgroundColor: AppColors.kButtonGreen,
              width: double.infinity,
              textStyle: buttonTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
