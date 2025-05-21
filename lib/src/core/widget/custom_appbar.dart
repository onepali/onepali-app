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
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          (showStepper && currentStep != null)
              ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: HorizontalStepper(
                  currentStep: currentStep!,
                  totalSteps: totalSteps,
                ),
              )
              : titleWidget ??
                  (title != null
                      ? Text(
                        title!,
                        style: AppStyles.text16PxMedium.copyWith(
                          color: AppColors.kBlack,
                        ),
                      )
                      : null),
      centerTitle: centerTitle,
      leading:
          leading ??
          IconButton(
            icon: Icon(Icons.arrow_back_outlined, color: AppColors.kBlack),
            onPressed: () => Navigator.of(context).pop(),
          ),
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
