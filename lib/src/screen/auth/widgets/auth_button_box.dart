import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class AuthContentBox extends StatelessWidget {
  const AuthContentBox({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = PlatformUtility.isTabletPortrait(context)
              ? constraints.maxWidth * 0.5
              : constraints.maxWidth;

          return Align(
            alignment: Alignment.center,
            child: SizedBox(width: width, child: child),
          );
        },
      ),
    );
  }
}

class AuthButtonBox extends StatelessWidget {
  const AuthButtonBox({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => AuthContentBox(child: child);
}

class AuthOnboardingLayout extends StatelessWidget {
  const AuthOnboardingLayout({
    required this.body,
    this.bottomAction,
    this.constrainBottomActionWidth = true,
    this.topPadding,
    this.bottomPadding,
    this.horizontalPadding,
    this.bottomActionGap,
    super.key,
  });

  final Widget body;
  final Widget? bottomAction;
  final bool constrainBottomActionWidth;
  final double? topPadding;
  final double? bottomPadding;
  final double? horizontalPadding;
  final double? bottomActionGap;

  static double pageHorizontalPadding(BuildContext context) {
    return PlatformUtility.isTabletPortrait(context) ? 32.0 : 16.0;
  }

  static double pageBottomPadding(BuildContext context) {
    return PlatformUtility.isTabletPortrait(context) ? 24.0 : 16.0;
  }

  static double buttonHeight(BuildContext context) {
    return PlatformUtility.isTabletPortrait(context) ? 56.0 : 48.0;
  }

  static double buttonRadius(BuildContext context) {
    return PlatformUtility.isTabletPortrait(context) ? 12.0 : 8.0;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final double resolvedHorizontalPadding =
        horizontalPadding ?? pageHorizontalPadding(context);
    final double resolvedTopPadding =
        topPadding ?? (isTabletPortrait ? 32.0 : 16.0);
    final double resolvedBottomPadding =
        bottomPadding ?? pageBottomPadding(context);
    final double resolvedBottomActionGap =
        bottomActionGap ?? (isTabletPortrait ? 24.0 : 16.0);

    return Container(
      color: AppColors.kWhite,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            resolvedHorizontalPadding,
            resolvedTopPadding,
            resolvedHorizontalPadding,
            resolvedBottomPadding,
          ),
          child: Column(
            children: [
              Expanded(child: body),
              if (bottomAction != null) ...[
                Gaps.verticalGapOf(resolvedBottomActionGap),
                constrainBottomActionWidth
                    ? AuthContentBox(child: bottomAction!)
                    : bottomAction!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AuthLogoContent extends StatelessWidget {
  const AuthLogoContent({required this.child, this.logoBottomGap, super.key});

  final Widget child;
  final double? logoBottomGap;

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final double logoWidth = isTabletPortrait ? 240.0 : 180.0;
    final double logoHeight = isTabletPortrait ? 38.0 : 28.0;
    final double resolvedLogoBottomGap =
        logoBottomGap ?? (isTabletPortrait ? 44.0 : 34.0);

    return Column(
      children: [
        Center(
          child: SvgHelper.fromSource(
            path: Assets.logoSvg,
            width: logoWidth,
            height: logoHeight,
            color: AppColors.kDrawerBgColor,
          ),
        ),
        Gaps.verticalGapOf(resolvedLogoBottomGap),
        Expanded(child: child),
      ],
    );
  }
}

class AuthBottomFooter extends StatelessWidget {
  const AuthBottomFooter({
    required this.child,
    this.footer,
    this.footerGap,
    super.key,
  });

  final Widget child;
  final Widget? footer;
  final double? footerGap;

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final double resolvedFooterGap =
        footerGap ?? (isTabletPortrait ? 18.0 : 14.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        if (footer != null) ...[Gaps.verticalGapOf(resolvedFooterGap), footer!],
      ],
    );
  }
}

class AuthCredentialLayout extends StatelessWidget {
  const AuthCredentialLayout({
    required this.formKey,
    required this.title,
    required this.emailField,
    required this.passwordField,
    required this.primaryLabel,
    required this.onPrimaryTap,
    required this.onGoogleTap,
    required this.onAppleTap,
    this.isPrimaryLoading = false,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.afterPassword,
    this.afterPrimary,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final Widget emailField;
  final Widget passwordField;
  final String primaryLabel;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;
  final bool isPrimaryLoading;
  final bool isGoogleLoading;
  final bool isAppleLoading;
  final Widget? afterPassword;
  final Widget? afterPrimary;

  static double fieldVerticalPadding(BuildContext context) {
    return PlatformUtility.isTabletPortrait(context) ? 16.0 : 12.0;
  }

  static double pageTopPadding(BuildContext context) {
    return PlatformUtility.isTabletPortrait(context) ? 12.0 : 8.0;
  }

  static double pageBottomPadding(BuildContext context) {
    return PlatformUtility.isTabletPortrait(context) ? 40.0 : 30.0;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double topPadding = pageTopPadding(context);
    final double bottomPadding = pageBottomPadding(context);
    final double sectionSpacing = isTabletPortrait ? 34.0 : 28.0;
    final double controlSpacing = isTabletPortrait ? 22.0 : 18.0;
    final double dividerSpacing = isTabletPortrait ? 42.0 : 34.0;
    final double afterPasswordSpacing = isTabletPortrait ? 8.0 : 6.0;
    final double afterPrimarySpacing = isTabletPortrait ? 18.0 : 14.0;
    final double bottomActionGap = isTabletPortrait ? 24.0 : 16.0;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;
    final double loadingIndicatorSize = isTabletPortrait ? 20.0 : 16.0;
    final double logoWidth = isTabletPortrait ? 240.0 : 180.0;
    final double logoHeight = isTabletPortrait ? 38.0 : 28.0;
    final double logoBottomGap = isTabletPortrait ? 56.0 : 44.0;

    final TextStyle titleStyle =
        (isTabletPortrait
                ? AppStyles.text24PxSemiBold
                : AppStyles.text20PxSemiBold)
            .copyWith(color: AppColors.kPitchBlack);
    final TextStyle primaryButtonTextStyle =
        (isTabletPortrait ? AppStyles.text20PxMedium : AppStyles.text16PxMedium)
            .copyWith(color: AppColors.kPitchBlack);
    final TextStyle socialButtonTextStyle =
        (isTabletPortrait
                ? AppStyles.text18PxRegular
                : AppStyles.text16PxRegular)
            .copyWith(color: AppColors.kPitchBlack);
    final double socialIconSize = socialButtonTextStyle.fontSize ?? 16.0;

    return Container(
      color: AppColors.kWhite,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topPadding,
            horizontalPadding,
            bottomPadding,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: SvgHelper.fromSource(
                          path: Assets.logoSvg,
                          width: logoWidth,
                          height: logoHeight,
                          color: AppColors.kDrawerBgColor,
                        ),
                      ),
                      Gaps.verticalGapOf(logoBottomGap),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Center(child: Text(title, style: titleStyle)),
                            Gaps.verticalGapOf(sectionSpacing),
                            AuthContentBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _socialButton(
                                    context,
                                    title: 'Continue with Google',
                                    icon: Assets.google,
                                    iconSize: socialIconSize,
                                    textStyle: socialButtonTextStyle,
                                    height: buttonHeight,
                                    loaderSize: loadingIndicatorSize,
                                    isLoading: isGoogleLoading,
                                    onTap: onGoogleTap,
                                  ),
                                  Gaps.verticalGapOf(controlSpacing),
                                  _socialButton(
                                    context,
                                    title: 'Continue with Apple',
                                    iconData: Icons.apple,
                                    iconSize: socialIconSize,
                                    textStyle: socialButtonTextStyle,
                                    height: buttonHeight,
                                    loaderSize: loadingIndicatorSize,
                                    isLoading: isAppleLoading,
                                    onTap: onAppleTap,
                                  ),
                                  Gaps.verticalGapOf(dividerSpacing),
                                  Utility.horizontalDividerTitle(
                                    title: 'OR',
                                    edgeIndent: 0,
                                  ),
                                  Gaps.verticalGapOf(dividerSpacing),
                                  emailField,
                                  Gaps.verticalGapOf(controlSpacing),
                                  passwordField,
                                  if (afterPassword != null) ...[
                                    Gaps.verticalGapOf(afterPasswordSpacing),
                                    afterPassword!,
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.verticalGapOf(bottomActionGap),
              AuthContentBox(
                child: AuthBottomFooter(
                  footerGap: afterPrimarySpacing,
                  footer: afterPrimary,
                  child: CustomMaterialButton(
                    label: primaryLabel,
                    isLoading: isPrimaryLoading,
                    onTap: isPrimaryLoading ? null : onPrimaryTap,
                    backgroundColor: AppColors.kButtonGreen,
                    width: double.infinity,
                    elevation: 0,
                    textStyle: primaryButtonTextStyle,
                    height: buttonHeight,
                    radius: buttonRadius,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(
    BuildContext context, {
    required String title,
    required double height,
    required double loaderSize,
    required double iconSize,
    required TextStyle textStyle,
    String? icon,
    IconData? iconData,
    bool isLoading = false,
    VoidCallback? onTap,
  }) {
    if (isLoading) {
      return Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.kGrey.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: loaderSize,
            width: loaderSize,
            child: const CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.kButtonGreen),
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    return ReusableWidget.horizontalIconTitle(
      title: title,
      icon: icon,
      iconData: iconData,
      iconSize: iconSize,
      height: height,
      textStyle: textStyle,
      onTap: onTap,
    );
  }
}
