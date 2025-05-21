import 'package:flutter/material.dart';

import '../../src.dart';

class CustomMaterialButton extends StatelessWidget {
  /// Callback function when the button is tapped.
  final VoidCallback? onTap;

  /// The text label of the button.
  final String label;

  /// show or hide the button border.
  final bool showBorder;

  /// Elevation of the button.
  final double elevation;

  /// Loading indicator
  final bool isLoading;

  /// Loader Size
  final double loaderSize;

  /// Radius of the button corners.
  final double radius;

  /// Height of the button.
  final double height;

  /// Width of the button.
  final double width;

  /// Icon displayed on the button.
  final dynamic icon;

  /// Icon type ['icon' or 'svg']
  final String iconType;

  /// Flag to show or hide the primary border color.
  final bool isBorderPrimary;

  /// Flag to fill the button or not.
  final bool fillButton;

  final bool lessOpacityButton;

  final bool islowOpBorder;

  /// Color of the text
  final Color color;

  /// Color of the button
  final Color backgroundColor;

  /// Flag to disable the button.
  final bool isDisabled;

  /// Flag to show small button
  final bool smallbutton;

  /// Title TextStyle
  final TextStyle? textStyle;

  /// Icon Sized
  final double? iconSize;

  const CustomMaterialButton({
    super.key,
    this.onTap,
    required this.label,
    this.showBorder = false,
    this.elevation = 2.0,
    this.radius = 8.0,
    this.height = 45.0,
    this.width = double.infinity,
    this.icon,
    this.fillButton = true,
    this.lessOpacityButton = false,
    this.isLoading = false,
    this.loaderSize = 20,
    this.islowOpBorder = false,
    this.isBorderPrimary = true,
    this.backgroundColor = AppColors.kPrimaryColor,
    this.color = AppColors.kPrimaryColor,
    this.isDisabled = false,
    this.smallbutton = false,
    this.iconType = 'icon',
    this.textStyle,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isDisabled || isLoading ? null : onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side:
            showBorder
                ? BorderSide(
                  color:
                      islowOpBorder
                          ? isBorderPrimary
                              ? const Color.fromARGB(72, 153, 29, 60)
                              : backgroundColor
                          : isBorderPrimary
                          ? AppColors.kPrimaryColor
                          : backgroundColor,
                )
                : BorderSide.none,
      ),
      elevation: elevation,
      height: height,
      minWidth: width,
      color: !isDisabled && fillButton ? backgroundColor : AppColors.kWhite,
      disabledColor: isDisabled ? AppColors.kGrey : null,
      child:
          isLoading
              ? SizedBox(
                height: loaderSize,
                width: loaderSize,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    iconType == 'svg'
                        ? SvgHelper.fromSource(
                          path: icon,
                          height: 16,
                          width: 16,
                        )
                        : Icon(
                          icon,
                          color: fillButton ? AppColors.kWhite : color,
                          size: iconSize ?? 16,
                        ),
                  if (icon != null) Gaps.horizontalGapOf(8.0),
                  Text(
                    label,
                    style:
                        smallbutton
                            ? AppStyles.text12PxRegular.copyWith(
                              color:
                                  fillButton ? AppColors.kPrimaryColor : color,
                            )
                            : textStyle ??
                                AppStyles.text16PxMedium.copyWith(
                                  color: fillButton ? AppColors.kWhite : color,
                                ),
                  ),
                ],
              ),
    );
  }
}
