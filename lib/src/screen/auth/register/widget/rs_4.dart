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
    final authProvider = context.watch<AuthProvider>();
    final gAuthStatus = context.watch<GoogleAuthProvider>().status;
    final fAuthStatus = context.watch<FAuthProvider>().status;
    final isLoading = authProvider.status == DataFetchStatus.loading;

    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 4),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create your Account', style: AppStyles.text20PxSemiBold),
                SizedBox(height: 24),
                TitleActionChild(
                  titlePadding: EdgeInsets.only(bottom: 8),
                  title: 'Email',
                  child: CustomTextField(
                    hintText: 'Enter your Email Address',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    prefixIcon: Icon(Icons.email_outlined),
                    validation: (value) => Validator.email(value ?? ""),
                  ),
                ),
                Gaps.verticalGapOf(20),
                TitleActionChild(
                  title: 'Password',
                  titlePadding: EdgeInsets.only(bottom: 8),
                  child: CustomTextField(
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
                ),
                SizedBox(height: 35),
                _buildNextButton(context, isLoading),

                Gaps.verticalGapOf(50),
                Utility.horizontalDividerTitle(),
                Gaps.verticalGapOf(20),
                gAuthStatus == DataFetchStatus.loading
                    ? Center(
                      child: SizedBox(
                        height: 16,
                        width: 16,
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
                        await googleAuthProvider.signInWithGoogle(context);
                      },
                    ),
                Gaps.verticalGapOf(15),
                fAuthStatus == DataFetchStatus.loading
                    ? Center(
                      child: SizedBox(
                        height: 16,
                        width: 16,
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

  Widget _buildNextButton(BuildContext context, bool isLoading) {
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
      elevation: 0,
    );
  }
}
