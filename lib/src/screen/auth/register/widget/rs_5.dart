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
        Utility.navigateMaterialRoute(context, RS6Screen());
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
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 60,
                  color: AppColors.kPrimaryColor,
                ),
              ),
              Gaps.verticalGapOf(32),
              Text(
                'Check your email',
                style: AppStyles.text24PxSemiBold,
                textAlign: TextAlign.center,
              ),
              Gaps.verticalGapOf(16),
              Text(
                'We have sent a verification link to your email address. Please check your inbox and click the link to verify your email.',
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
              'Didn\'t receive the email?\nCheck your spam folder or tap the button below to resend.',
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
