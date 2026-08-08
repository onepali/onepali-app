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
  String _sentEmail = '';

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
    final double logoWidth = isTabletPortrait ? 240.0 : 180.0;
    final double logoHeight = isTabletPortrait ? 38.0 : 28.0;
    final double verticalSpacing = isTabletPortrait ? 40.0 : 30.0;
    final double titleBottomGap = isTabletPortrait ? 16.0 : 12.0;
    final double fieldSpacing = isTabletPortrait ? 24.0 : 20.0;
    final double buttonTopGap = isTabletPortrait ? 45.0 : 35.0;
    final double bottomPadding = isTabletPortrait ? 24.0 : 16.0;
    final double iconSize = isTabletPortrait ? 84.0 : 64.0;
    final double emailSentTopGap = isTabletPortrait ? 64.0 : 48.0;
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
    final children = _isEmailSent
        ? _buildEmailSentContent(
            titleStyle: titleStyle,
            descriptionStyle: descriptionStyle,
            buttonTextStyle: buttonTextStyle,
            buttonHeight: isTabletPortrait ? 56.0 : 48.0,
            buttonRadius: isTabletPortrait ? 12.0 : 8.0,
            iconSize: iconSize,
            titleBottomGap: titleBottomGap,
            buttonTopGap: buttonTopGap,
          )
        : _buildResetFormContent(
            isLoading: isLoading,
            titleStyle: titleStyle,
            descriptionStyle: descriptionStyle,
            buttonTextStyle: buttonTextStyle,
            buttonHeight: isTabletPortrait ? 56.0 : 48.0,
            buttonRadius: isTabletPortrait ? 12.0 : 8.0,
            titleBottomGap: titleBottomGap,
            fieldSpacing: fieldSpacing,
            buttonTopGap: buttonTopGap,
          );

    return Scaffold(
      appBar: CustomAppBar(title: ''),
      backgroundColor: AppColors.kWhite,
      body: Container(
        color: AppColors.kWhite,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SvgHelper.fromSource(
                        path: Assets.logoSvg,
                        width: logoWidth,
                        height: logoHeight,
                        color: AppColors.kDrawerBgColor,
                      ),
                    ),
                    Gaps.verticalGapOf(verticalSpacing),
                    if (_isEmailSent) Gaps.verticalGapOf(emailSentTopGap),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AuthSignUpFooter(
        horizontalPadding: horizontalPadding,
        bottomPadding: bottomPadding,
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
      _sentEmail = email;
    });
  }

  List<Widget> _buildResetFormContent({
    required bool isLoading,
    required TextStyle titleStyle,
    required TextStyle descriptionStyle,
    required TextStyle buttonTextStyle,
    required double buttonHeight,
    required double buttonRadius,
    required double titleBottomGap,
    required double fieldSpacing,
    required double buttonTopGap,
  }) {
    return [
      Text('Reset password', style: titleStyle),
      Gaps.verticalGapOf(titleBottomGap),
      Text(
        'Enter your email and we will send a password reset link.',
        style: descriptionStyle,
      ),
      Gaps.verticalGapOf(fieldSpacing),
      CustomTextField(
        hintText: 'Email',
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        prefixIcon: const Icon(Icons.email_outlined),
        textInputAction: TextInputAction.done,
        validation: (value) => Validator.email(value ?? ""),
        onEditingComplete: isLoading ? null : _sendResetLink,
      ),
      Gaps.verticalGapOf(buttonTopGap),
      CustomMaterialButton(
        label: 'Send reset link',
        isLoading: isLoading,
        onTap: isLoading ? null : _sendResetLink,
        backgroundColor: AppColors.kButtonGreen,
        width: double.infinity,
        elevation: 0,
        textStyle: buttonTextStyle,
        height: buttonHeight,
        radius: buttonRadius,
      ),
    ];
  }

  List<Widget> _buildEmailSentContent({
    required TextStyle titleStyle,
    required TextStyle descriptionStyle,
    required TextStyle buttonTextStyle,
    required double buttonHeight,
    required double buttonRadius,
    required double iconSize,
    required double titleBottomGap,
    required double buttonTopGap,
  }) {
    return [
      Center(
        child: SizedBox(
          height: iconSize,
          width: iconSize,
          child: SvgHelper.fromSource(
            path: Assets.email,
            width: iconSize,
            height: iconSize,
          ),
        ),
      ),
      Gaps.verticalGapOf(titleBottomGap),
      Center(child: Text('Email sent', style: titleStyle)),
      Gaps.verticalGapOf(titleBottomGap),
      Text(
        'If an account exists for $_sentEmail, a password reset link is on its way.',
        style: descriptionStyle,
        textAlign: TextAlign.center,
      ),
      Gaps.verticalGapOf(buttonTopGap),
      CustomMaterialButton(
        label: 'Back to login',
        onTap: () => Navigator.of(context).pop(),
        backgroundColor: AppColors.kButtonGreen,
        width: double.infinity,
        elevation: 0,
        textStyle: buttonTextStyle,
        height: buttonHeight,
        radius: buttonRadius,
      ),
    ];
  }
}
