import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AuthSignUpFooter extends StatelessWidget {
  const AuthSignUpFooter({
    required this.horizontalPadding,
    required this.bottomPadding,
    super.key,
  });

  final double horizontalPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final textStyle =
        (isTabletPortrait
                ? AppStyles.text16PxRegular
                : AppStyles.text14PxRegular)
            .copyWith(
              color: AppColors.kPitchBlack,
              fontFamily: AppConstants.kPoppinsFont,
            );
    final linkTextStyle =
        (isTabletPortrait
                ? AppStyles.text16PxSemiBold
                : AppStyles.text14PxSemiBold)
            .copyWith(
              color: AppColors.kButtonGreen,
              fontFamily: AppConstants.kPoppinsFont,
            );

    return Container(
      color: AppColors.kWhite,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: bottomPadding,
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Don\'t have an account? ',
              style: textStyle,
              children: [
                TextSpan(
                  text: 'Sign up',
                  style: linkTextStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Utility.navigate(context, AppRoutes.registerScreen);
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
