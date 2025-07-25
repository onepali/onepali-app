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
    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 5),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Check your email',
                style: AppStyles.text24PxSemiBold,
                textAlign: TextAlign.center,
              ),
              Gaps.verticalGapOf(50),

              SvgHelper.fromSource(path: Assets.email, height: 40, width: 40),

              Gaps.verticalGapOf(50),
              Text(
                'We sent a verification link to your email. Click the link to get started!',
                style: AppStyles.text14PxRegular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Can\'t find it? Check your spam folder.',
              style: AppStyles.text12PxRegular.copyWith(
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.verticalGapOf(8),
            CustomTextButton(
              text: 'Resend Verification Email',
              onPressed: () => _handleResend(context),
            ),
            Gaps.verticalGapOf(16),
            CustomMaterialButton(
              label: 'I\'ve verified, Continue',
              elevation: 0,
              backgroundColor: AppColors.kButtonGreen,
              onTap: () => _handleNext(context),
            ),
          ],
        ),
      ),
    );
  }
}
