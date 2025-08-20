import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class RS4Screen extends StatefulWidget {
  const RS4Screen({super.key});

  @override
  State<RS4Screen> createState() => _RS4ScreenState();
}

class _RS4ScreenState extends State<RS4Screen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double titleBottomGap = isTabletPortrait ? 32.0 : 24.0;
    final double fieldGap = isTabletPortrait ? 24.0 : 20.0;
    final double buttonTopGap = isTabletPortrait ? 40.0 : 35.0;
    final double dividerTopGap = isTabletPortrait ? 60.0 : 50.0;
    final double socialButtonGap = isTabletPortrait ? 20.0 : 15.0;

    final TextStyle titleStyle =
        isTabletPortrait
            ? AppStyles.text24PxSemiBold
            : AppStyles.text20PxSemiBold;

    final authProvider = context.watch<AuthProvider>();
    final gAuthStatus = context.watch<GoogleAuthProvider>().status;
    final fAuthStatus = context.watch<FAuthProvider>().status;
    final isLoading = authProvider.status == DataFetchStatus.loading;

    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 4),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create your account', style: titleStyle),
                Gaps.verticalGapOf(titleBottomGap),
                CustomTextField(
                  hintText: 'Enter your Email Address',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  prefixIcon: Icon(Icons.email_outlined),
                  validation: (value) => Validator.email(value ?? ""),
                ),
                Gaps.verticalGapOf(fieldGap),
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
                Gaps.verticalGapOf(buttonTopGap),
                _buildNextButton(context, isLoading, isTabletPortrait),

                Gaps.verticalGapOf(dividerTopGap),
                Utility.horizontalDividerTitle(),
                Gaps.verticalGapOf(socialButtonGap),
                gAuthStatus == DataFetchStatus.loading
                    ? Center(
                      child: SizedBox(
                        height: isTabletPortrait ? 20 : 16,
                        width: isTabletPortrait ? 20 : 16,
                        child: const CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.kButtonGreen,
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                    : ReusableWidget.horizontalIconTitle(
                      title: 'Continue with Google',
                      icon: Assets.google,
                      onTap: () async {
                        final googleAuthProvider =
                            context.read<GoogleAuthProvider>();
                        await googleAuthProvider.signInWithGoogle(
                          context,
                          isLogin: false,
                        );
                      },
                    ),
                Gaps.verticalGapOf(socialButtonGap),
                fAuthStatus == DataFetchStatus.loading
                    ? Center(
                      child: SizedBox(
                        height: isTabletPortrait ? 20 : 16,
                        width: isTabletPortrait ? 20 : 16,
                        child: const CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.kButtonGreen,
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                    : ReusableWidget.horizontalIconTitle(
                      title: 'Continue with Facebook',
                      icon: Assets.facebook,
                      onTap: () async {
                        final facebookAuthProvider =
                            context.read<FAuthProvider>();
                        await facebookAuthProvider.signInWithFacebook(context);
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    bool isLoading,
    bool isTabletPortrait,
  ) {
    final TextStyle buttonTextStyle =
        isTabletPortrait ? AppStyles.text18PxMedium : AppStyles.text16PxMedium;

    return CustomMaterialButton(
      label: 'Next',
      isLoading: isLoading,
      onTap:
          isLoading
              ? null
              : () async {
                if (_formKey.currentState!.validate()) {
                  final authProvider = context.read<AuthProvider>();
                  await authProvider.register(
                    context: context,
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    fullName: context.read<AuthState>().fullName ?? "",
                    yearOfBirth: context.read<AuthState>().yearOfBirth,
                    heardAbout: context.read<AuthState>().heardAbout,
                    learningReason: context.read<AuthState>().learningReason,
                  );
                }
              },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      textStyle: buttonTextStyle,
      elevation: 0,
    );
  }
}
