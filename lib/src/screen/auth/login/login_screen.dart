import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.status == DataFetchStatus.loading;

    // Responsive variables
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double logoWidth = isTabletPortrait ? 240.0 : 180.0;
    final double logoHeight = isTabletPortrait ? 38.0 : 28.0;
    final double verticalSpacing = isTabletPortrait ? 40.0 : 30.0;
    final double fieldSpacing = isTabletPortrait ? 24.0 : 20.0;
    final double socialButtonSpacing = isTabletPortrait ? 20.0 : 15.0;
    final double bottomPadding = isTabletPortrait ? 24.0 : 16.0;

    return Scaffold(
      appBar: CustomAppBar(title: ''),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Welcome', style: AppStyles.text20PxMedium),
                // Row(
                //   children: [
                //     Text(
                //       'to',
                //       style: AppStyles.text20PxMedium.copyWith(
                //         color: AppColors.kPitchBlack,
                //         fontFamily: AppConstants.defaultFontFamily,
                //       ),
                //     ),
                //     Gaps.horizontalGapOf(10),
                Center(
                  child: SvgHelper.fromSource(
                    path: Assets.logoSvg,
                    width: logoWidth,
                    height: logoHeight,
                    color: AppColors.kDrawerBgColor,
                  ),
                ),
                //   ],
                // ),
                Gaps.verticalGapOf(verticalSpacing),
                Text(
                  'Sign in',
                  style:
                      isTabletPortrait
                          ? AppStyles.text16PxRegular
                          : AppStyles.text14PxRegular,
                ),
                Gaps.verticalGapOf(fieldSpacing),
                CustomTextField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  prefixIcon: Icon(Icons.email_outlined),
                  validation: (value) => Validator.email(value ?? ""),
                ),
                Gaps.verticalGapOf(fieldSpacing),
                CustomTextField(
                  hintText: 'Password',
                  isPasswordField: isObscure,
                  controller: passwordController,
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      !isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),
                  textInputAction: TextInputAction.done,
                  validation: (value) => Validator.password(value ?? ""),
                ),
                Gaps.verticalGapOf(isTabletPortrait ? 8.0 : 5.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Utility.navigate(context, AppRoutes.loginScreen);
                    },
                    child: Text(
                      'Forgot password?',
                      textAlign: TextAlign.right,
                      style: (isTabletPortrait
                              ? AppStyles.text16PxRegular
                              : AppStyles.text14PxRegular)
                          .copyWith(color: AppColors.kButtonGreen),
                    ),
                  ),
                ),
                Gaps.verticalGapOf(isTabletPortrait ? 45.0 : 35.0),
                _buildNextButton(context, isLoading),
                Gaps.verticalGapOf(isTabletPortrait ? 45.0 : 35.0),
                Utility.horizontalDividerTitle(title: 'Or sign in with'),
                Gaps.verticalGapOf(fieldSpacing),
                ReusableWidget.horizontalIconTitle(
                  title: 'Continue with Google',
                  icon: Assets.google,
                  onTap: () async {
                    final googleAuthProvider =
                        context.read<GoogleAuthProvider>();
                    await googleAuthProvider.signInWithGoogle(
                      context,
                      isLogin: true,
                    );
                  },
                ),
                Gaps.verticalGapOf(socialButtonSpacing),
                ReusableWidget.horizontalIconTitle(
                  title: 'Continue with Facebook',
                  icon: Assets.facebook,
                  onTap: () async {
                    final facebookAuthProvider = context.read<FAuthProvider>();
                    await facebookAuthProvider.signInWithFacebook(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: bottomPadding,
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Don\'t have an account? ',
            style: (isTabletPortrait
                    ? AppStyles.text16PxRegular
                    : AppStyles.text14PxRegular)
                .copyWith(
                  color: AppColors.kPitchBlack,
                  fontFamily: AppConstants.kPoppinsFont,
                ),
            children: [
              TextSpan(
                text: 'Sign up',
                style: (isTabletPortrait
                        ? AppStyles.text16PxSemiBold
                        : AppStyles.text14PxSemiBold)
                    .copyWith(
                      color: AppColors.kButtonGreen,
                      fontFamily: AppConstants.kPoppinsFont,
                    ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        Utility.navigate(context, AppRoutes.registerScreen);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, bool isLoading) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    return CustomMaterialButton(
      label: 'Log in',
      isLoading: isLoading,
      onTap:
          isLoading
              ? null
              : () async {
                if (_formKey.currentState!.validate()) {
                  GuestUtil.setGuestUser(false);
                  final authProvider = context.read<AuthProvider>();
                  await authProvider.signIn(
                    context,
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                }
              },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
      textStyle:
          isTabletPortrait
              ? AppStyles.text18PxMedium
              : AppStyles.text16PxMedium,
      height: isTabletPortrait ? 56.0 : 48.0,
      radius: isTabletPortrait ? 12.0 : 8.0,
    );
  }
}
