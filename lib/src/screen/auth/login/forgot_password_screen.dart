import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _isEmailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.status == DataFetchStatus.loading;
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double titleBottomGap = isTabletPortrait ? 16.0 : 12.0;
    final double fieldSpacing = isTabletPortrait ? 24.0 : 20.0;
    final double titleFieldGap = fieldSpacing + titleBottomGap;
    final double logoBottomGap = isTabletPortrait ? 64.0 : 48.0;
    final double footerGap = isTabletPortrait ? 18.0 : 14.0;
    final double iconSize = isTabletPortrait ? 84.0 : 64.0;
    final double buttonHeight = AuthOnboardingLayout.buttonHeight(context);
    final double buttonRadius = AuthOnboardingLayout.buttonRadius(context);
    final double fieldVerticalPadding =
        AuthCredentialLayout.fieldVerticalPadding(context);
    final double fieldHorizontalPadding = isTabletPortrait ? 16.0 : 12.0;
    final TextStyle titleStyle =
        (isTabletPortrait
                ? AppStyles.text24PxSemiBold
                : AppStyles.text20PxSemiBold)
            .copyWith(color: AppColors.kPitchBlack);
    final TextStyle descriptionStyle =
        (isTabletPortrait
                ? AppStyles.text16PxRegular
                : AppStyles.text14PxRegular)
            .copyWith(color: AppColors.kPitchBlack);
    final TextStyle buttonTextStyle = isTabletPortrait
        ? AppStyles.text20PxMedium
        : AppStyles.text16PxMedium;
    final Widget content = _isEmailSent
        ? _buildEmailSentContent(
            titleStyle: titleStyle,
            descriptionStyle: descriptionStyle,
            iconSize: iconSize,
            titleBottomGap: titleBottomGap,
          )
        : _buildResetFormContent(
            titleStyle: titleStyle,
            descriptionStyle: descriptionStyle,
            titleFieldGap: titleFieldGap,
            fieldTextGap: fieldSpacing,
            fieldHorizontalPadding: fieldHorizontalPadding,
            fieldVerticalPadding: fieldVerticalPadding,
          );
    final Widget primaryButton = CustomMaterialButton(
      label: _isEmailSent ? 'Back to login' : 'Send reset link',
      isLoading: _isEmailSent ? false : isLoading,
      onTap: _isEmailSent
          ? () => Navigator.of(context).pop()
          : (isLoading ? null : _sendResetLink),
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
      textStyle: buttonTextStyle,
      height: buttonHeight,
      radius: buttonRadius,
    );

    return Scaffold(
      appBar: CustomAppBar(title: ''),
      backgroundColor: AppColors.kWhite,
      body: AuthOnboardingLayout(
        topPadding: AuthCredentialLayout.pageTopPadding(context),
        bottomPadding: AuthCredentialLayout.pageBottomPadding(context),
        horizontalPadding: horizontalPadding,
        body: AuthLogoContent(
          logoBottomGap: logoBottomGap,
          child: Form(key: _formKey, child: content),
        ),
        bottomAction: AuthBottomFooter(
          footerGap: footerGap,
          footer: const AuthSignUpFooter(
            horizontalPadding: 0,
            bottomPadding: 0,
          ),
          child: primaryButton,
        ),
      ),
    );
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final didSend = await authProvider.sendPasswordResetEmail(
      email,
      showSuccessToast: false,
    );
    if (!mounted || !didSend) return;
    setState(() {
      _isEmailSent = true;
    });
  }

  Widget _buildResetFormContent({
    required TextStyle titleStyle,
    required TextStyle descriptionStyle,
    required double titleFieldGap,
    required double fieldTextGap,
    required double fieldHorizontalPadding,
    required double fieldVerticalPadding,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'Reset password',
            style: titleStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Gaps.verticalGapOf(titleFieldGap),
        AuthContentBox(
          child: CustomTextField(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            prefixIcon: const Icon(Icons.email_outlined),
            paddingHorizontal: fieldHorizontalPadding,
            paddingVertical: fieldVerticalPadding,
            textInputAction: TextInputAction.done,
            validation: (value) => Validator.email(value ?? ""),
            onEditingComplete: _sendResetLink,
          ),
        ),
        Gaps.verticalGapOf(fieldTextGap),
        SizedBox(
          width: double.infinity,
          child: Text(
            'We will send a password reset link to your email.',
            style: descriptionStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailSentContent({
    required TextStyle titleStyle,
    required TextStyle descriptionStyle,
    required double iconSize,
    required double titleBottomGap,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: iconSize,
            width: iconSize,
            child: SvgHelper.fromSource(
              path: Assets.email,
              width: iconSize,
              height: iconSize,
            ),
          ),
          Gaps.verticalGapOf(titleBottomGap),
          Text('Email sent', style: titleStyle),
          Gaps.verticalGapOf(titleBottomGap),
          Text(
            'If an account exists, you will receive a password reset link in your email.',
            style: descriptionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
