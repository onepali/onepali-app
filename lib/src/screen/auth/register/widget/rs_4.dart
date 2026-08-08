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
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 4),
      backgroundColor: AppColors.kWhite,
      body: AuthCredentialLayout(
        formKey: _formKey,
        title: 'Create your account',
        isPrimaryLoading: authProvider.status == DataFetchStatus.loading,
        isGoogleLoading: gAuthStatus == DataFetchStatus.loading,
        isAppleLoading: aAuthStatus == DataFetchStatus.loading,
        onGoogleTap: () async {
          final googleAuthProvider = context.read<GoogleAuthProvider>();
          await googleAuthProvider.signInWithGoogle(context, isLogin: false);
        },
        onAppleTap: () async {
          final appleAuthProvider = context.read<AAuthProvider>();
          await appleAuthProvider.signInWithApple(context);
        },
        emailField: CustomTextField(
          hintText: 'Enter your Email Address',
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          prefixIcon: Icon(Icons.email_outlined),
          paddingHorizontal: fieldHorizontalPadding,
          paddingVertical: fieldVerticalPadding,
          validation: (value) => Validator.email(value ?? ""),
        ),
        passwordField: CustomTextField(
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
          paddingHorizontal: fieldHorizontalPadding,
          paddingVertical: fieldVerticalPadding,
          textInputAction: TextInputAction.done,
          validation: (value) => Validator.password(value ?? ""),
        ),
        primaryLabel: 'Create account',
        onPrimaryTap: () async {
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
      ),
    );
  }
}
