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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final gAuthStatus = context.watch<GoogleAuthProvider>().status;
    final aAuthStatus = context.watch<AAuthProvider>().status;
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final double fieldVerticalPadding =
        AuthCredentialLayout.fieldVerticalPadding(context);
    final double fieldHorizontalPadding = isTabletPortrait ? 16.0 : 12.0;

    return Scaffold(
      appBar: CustomAppBar(title: ''),
      backgroundColor: AppColors.kWhite,
      body: AuthCredentialLayout(
        formKey: _formKey,
        title: 'Log In',
        isPrimaryLoading: authProvider.status == DataFetchStatus.loading,
        isGoogleLoading: gAuthStatus == DataFetchStatus.loading,
        isAppleLoading: aAuthStatus == DataFetchStatus.loading,
        onGoogleTap: () async {
          final googleAuthProvider = context.read<GoogleAuthProvider>();
          await googleAuthProvider.signInWithGoogle(context, isLogin: true);
        },
        onAppleTap: () async {
          final appleAuthProvider = context.read<AAuthProvider>();
          await appleAuthProvider.signInWithApple(context);
        },
        emailField: CustomTextField(
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          prefixIcon: Icon(Icons.email_outlined),
          paddingHorizontal: fieldHorizontalPadding,
          paddingVertical: fieldVerticalPadding,
          validation: (value) => Validator.email(value ?? ""),
        ),
        passwordField: CustomTextField(
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
          paddingHorizontal: fieldHorizontalPadding,
          paddingVertical: fieldVerticalPadding,
          textInputAction: TextInputAction.done,
          validation: (value) => Validator.password(value ?? ""),
        ),
        afterPassword: Center(
          child: TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              Utility.navigate(
                context,
                AppRoutes.forgotPasswordScreen,
                arguments: {'email': emailController.text.trim()},
              );
            },
            child: Text(
              'Forgot password?',
              textAlign: TextAlign.center,
              style:
                  (isTabletPortrait
                          ? AppStyles.text16PxRegular
                          : AppStyles.text14PxRegular)
                      .copyWith(color: AppColors.kButtonGreen),
            ),
          ),
        ),
        primaryLabel: 'Log in',
        onPrimaryTap: () async {
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
        afterPrimary: const AuthSignUpFooter(
          horizontalPadding: 0,
          bottomPadding: 0,
        ),
      ),
    );
  }
}
