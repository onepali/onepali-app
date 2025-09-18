import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class RS5Screen extends StatelessWidget {
  final bool isLogin;
  const RS5Screen({super.key, this.isLogin = false});

  Future<void> _handleNext(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final isVerified = await authProvider.checkEmailVerified();
    if (isVerified) {
      if (!context.mounted) return;
      showCustomToaster(isLogin ? "Login successful!" : "Account created!");
      if (isLogin) {
        Utility.navigate(context, AppRoutes.dashboardScreen);
      } else {
        Utility.navigate(context, AppRoutes.rs6Screen);
      }
    } else {
      if (!context.mounted) return;
      showCustomToaster(
        "Please verify your email before continuing.",
        isError: true,
      );
    }
  }

  Future<void> _handleResend(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.resendEmailVerification(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 24.0;
    final double titleBottomGap = isTabletPortrait ? 60.0 : 50.0;
    final double iconSize = isTabletPortrait ? 60.0 : 40.0;
    final double iconBottomGap = isTabletPortrait ? 60.0 : 50.0;
    final double bottomPadding = isTabletPortrait ? 24.0 : 16.0;
    final double textGap = isTabletPortrait ? 12.0 : 8.0;
    final double buttonGap = isTabletPortrait ? 20.0 : 16.0;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;

    final TextStyle titleStyle =
        isTabletPortrait
            ? AppStyles.text28PxSemiBold
            : AppStyles.text24PxSemiBold;

    final TextStyle descriptionStyle =
        isTabletPortrait
            ? AppStyles.text16PxRegular
            : AppStyles.text14PxRegular;

    final TextStyle spamTextStyle =
        isTabletPortrait
            ? AppStyles.text14PxRegular
            : AppStyles.text12PxRegular;

    final TextStyle buttonTextStyle =
        isTabletPortrait ? AppStyles.text20PxMedium : AppStyles.text16PxMedium;

    final TextStyle resendButtonTextStyle =
        isTabletPortrait
            ? AppStyles.text18PxRegular
            : AppStyles.text14PxRegular;

    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 5),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Check your email',
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
              Gaps.verticalGapOf(titleBottomGap),

              SvgHelper.fromSource(
                path: Assets.email,
                height: iconSize,
                width: iconSize,
              ),

              Gaps.verticalGapOf(iconBottomGap),
              Text(
                'We sent a verification link to your email. Click the link to get started!',
                style: descriptionStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Can\'t find it? Check your spam folder.',
                style: spamTextStyle.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              Gaps.verticalGapOf(textGap),
              CustomTextButton(
                text: 'Resend Verification Email',
                textStyle: resendButtonTextStyle,
                onPressed: () => _handleResend(context),
              ),
              Gaps.verticalGapOf(buttonGap),
              CustomMaterialButton(
                label: 'I\'ve verified, Continue',
                elevation: 0,
                backgroundColor: AppColors.kButtonGreen,
                onTap: () => _handleNext(context),
                textStyle: buttonTextStyle,
                height: buttonHeight,
                radius: buttonRadius,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
