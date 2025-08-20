import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:onepali/src/src.dart';

class RS6Screen extends StatefulWidget {
  const RS6Screen({super.key});

  @override
  State<RS6Screen> createState() => _RS6ScreenState();
}

class _RS6ScreenState extends State<RS6Screen>
    with SingleTickerProviderStateMixin {
  final TextEditingController codeController = TextEditingController();
  late final AnimationController _lottieController;
  bool _showSvg = false;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Misc.onLayoutRendered(() {
          setState(() {
            _showSvg = true;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double lottieSize = isTabletPortrait ? 200.0 : 150.0;
    final double svgSize = isTabletPortrait ? 240.0 : 180.0;
    final double titleGap = isTabletPortrait ? 40.0 : 30.0;
    final double subtitleGap = isTabletPortrait ? 16.0 : 10.0;
    final double bottomPadding = isTabletPortrait ? 24.0 : 16.0;

    final TextStyle titleStyle =
        isTabletPortrait
            ? AppStyles.text24PxSemiBold
            : AppStyles.text20PxSemiBold;

    final TextStyle descriptionStyle =
        isTabletPortrait
            ? AppStyles.text16PxRegular
            : AppStyles.text14PxRegular;

    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 6),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showSvg)
              Lottie.asset(
                Assets.successLottie,
                height: lottieSize,
                width: lottieSize,
                repeat: false,
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController.duration = composition.duration;
                  _lottieController.forward();
                },
              ),
            if (_showSvg)
              SvgHelper.fromSource(
                path: Assets.successSvg,
                height: svgSize,
                width: svgSize,
              ),
            Gaps.verticalGapOf(titleGap),
            Text('Account Setup Complete!', style: titleStyle),
            Gaps.verticalGapOf(subtitleGap),
            Text(
              'You\'re now part of a community helping children connect with their Nepali roots. Let the learning begin!',
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(bottomPadding),
        child: _buildNextButton(context, isTabletPortrait),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, bool isTabletPortrait) {
    final TextStyle buttonTextStyle =
        isTabletPortrait ? AppStyles.text18PxMedium : AppStyles.text16PxMedium;

    return CustomMaterialButton(
      label: 'Get Started',
      onTap: () {
        Utility.navigate(context, AppRoutes.loginScreen);
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      textStyle: buttonTextStyle,
      elevation: 0,
    );
  }
}
