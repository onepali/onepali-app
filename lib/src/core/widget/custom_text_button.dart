import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? borderRadius;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.padding,
    this.backgroundColor = AppColors.transparent,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: Text(
        text,
        style: AppStyles.text14PxMedium.copyWith(color: AppColors.kButtonGreen),
      ),
    );
  }
}
