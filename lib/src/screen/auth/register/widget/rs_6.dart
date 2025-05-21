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
    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 6),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showSvg)
              Lottie.asset(
                Assets.successLottie,
                height: 150,
                width: 150,
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
                height: 180,
                width: 180,
              ),
            Gaps.verticalGapOf(30),
            Text('Account Setup Complete!', style: AppStyles.text20PxSemiBold),
            Gaps.verticalGapOf(10),
            Text(
              'You\'re now part of a community helping children connect with their Nepali roots. Let the learning begin!',
              style: AppStyles.text14PxRegular,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildNextButton(context),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return CustomMaterialButton(
      label: 'Get Started',
      onTap: () {
        Utility.navigateMaterialRoute(context, RS6Screen());
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
