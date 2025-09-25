import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'horizontal_stepper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double elevation;
  final int? currentStep;
  final int totalSteps;
  final bool showStepper;
  final bool showBackButton;
  final TextStyle? titleStyle;
  final bool? automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.backgroundColor = AppColors.kWhite,
    this.elevation = 0.0,
    this.currentStep,
    this.totalSteps = 6,
    this.showStepper = false,
    this.showBackButton = true,
    this.titleStyle,
    this.automaticallyImplyLeading,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    // Responsive sizing
    final double stepperHorizontalPadding = isTablet ? 24.0 : 16.0;
    final double iconSize = isTablet ? 28.0 : 24.0;

    // Responsive text style
    final TextStyle responsiveTitleStyle =
        titleStyle ??
        (isTabletPortrait
            ? AppStyles.text22PxMedium.copyWith(
                color: AppColors.kBlack,
                fontFamily: AppConstants.kPoppinsFont,
              )
            : isTabletLandscape
            ? AppStyles.text20PxMedium.copyWith(
                color: AppColors.kBlack,
                fontFamily: AppConstants.kPoppinsFont,
              )
            : AppStyles.text18PxMedium.copyWith(
                color: AppColors.kBlack,
                fontFamily: AppConstants.kPoppinsFont,
              ));

    return AppBar(
      title: (showStepper && currentStep != null)
          ? Padding(
              padding: EdgeInsets.symmetric(
                horizontal: stepperHorizontalPadding,
              ),
              child: HorizontalStepper(
                currentStep: currentStep!,
                totalSteps: totalSteps,
              ),
            )
          : titleWidget ??
                (title != null
                    ? Text(title!, style: responsiveTitleStyle)
                    : null),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      leading: showBackButton
          ? (leading ??
                IconButton(
                  iconSize: iconSize,
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.kBlack,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ))
          : null,
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize {
    // Default toolbar height is 56.0, but we can adjust for tablets
    final double toolbarHeight = kToolbarHeight;
    return Size.fromHeight(toolbarHeight);
  }
}
