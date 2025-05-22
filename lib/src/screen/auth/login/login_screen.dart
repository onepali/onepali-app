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

    return Scaffold(
      appBar: CustomAppBar(title: ''),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome', style: AppStyles.text20PxMedium),
                RichText(
                  text: TextSpan(
                    text: 'to ',
                    style: AppStyles.text20PxMedium.copyWith(
                      color: AppColors.kPitchBlack,
                      fontFamily: AppConstants.defaultFontFamily,
                    ),
                    children: [
                      TextSpan(
                        text: 'O Nepali',
                        style: AppStyles.text20PxSemiBold.copyWith(
                          color: AppColors.kButtonGreen,
                          fontFamily: AppConstants.defaultFontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.verticalGapOf(15),
                Text(
                  'Sign in to your account',
                  style: AppStyles.text14PxRegular,
                ),
                Gaps.verticalGapOf(20),
                CustomTextField(
                  hintText: 'Enter your Email Address',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  prefixIcon: Icon(Icons.email_outlined),
                  validation: (value) => Validator.email(value ?? ""),
                ),
                Gaps.verticalGapOf(20),
                CustomTextField(
                  hintText: 'Enter a Password',
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
                Gaps.verticalGapOf(5),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Utility.navigate(context, AppRoutes.loginScreen);
                    },
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.right,
                      style: AppStyles.text14PxRegular.copyWith(
                        color: AppColors.kButtonGreen,
                      ),
                    ),
                  ),
                ),
                Gaps.verticalGapOf(35),
                _buildNextButton(context, isLoading),
                Gaps.verticalGapOf(50),
                Utility.horizontalDividerTitle(title: 'Or Sign In With'),
                Gaps.verticalGapOf(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReusableWidget.horizontalIconTitle(
                      title: 'Google',
                      icon: Assets.google,
                      onTap: () async {
                        final googleAuthProvider =
                            context.read<GoogleAuthProvider>();
                        await googleAuthProvider.signInWithGoogle(context);
                      },
                    ),
                    Gaps.horizontalGapOf(20),
                    ReusableWidget.horizontalIconTitle(
                      title: 'Facebook',
                      icon: Assets.facebook,
                      onTap: () async {
                        final facebookAuthProvider =
                            context.read<FAuthProvider>();
                        await facebookAuthProvider.signInWithFacebook(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: RichText(
          textAlign: TextAlign.center,

          text: TextSpan(
            text: 'Don\'t have an account? ',
            style: AppStyles.text14PxRegular.copyWith(
              color: AppColors.kPitchBlack,
              fontFamily: AppConstants.defaultFontFamily,
            ),
            children: [
              TextSpan(
                text: 'Sign Up',
                style: AppStyles.text14PxSemiBold.copyWith(
                  color: AppColors.kButtonGreen,
                  fontFamily: AppConstants.defaultFontFamily,
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
    return CustomMaterialButton(
      label: 'Login',
      isLoading: isLoading,
      onTap:
          isLoading
              ? null
              : () async {
                if (_formKey.currentState!.validate()) {
                  final authProvider = context.read<AuthProvider>();
                  try {
                    final result = await authProvider.loginWithEmail(
                      context,
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    // result == true: login success, verified
                    // result == false: either not verified or login failed
                    if (result == true) {
                      if (!context.mounted) return;
                      Utility.navigate(context, AppRoutes.dashboardScreen);
                    } else if (result == 'not_verified') {
                      if (!context.mounted) return;
                      Utility.navigateMaterialRoute(
                        context,
                        RS5Screen(isLogin: true),
                      );
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    showCustomToaster( e.toString(), isError: true);
                  }
                }
              },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
