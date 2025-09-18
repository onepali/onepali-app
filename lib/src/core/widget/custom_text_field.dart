import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../src.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validation;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final bool isPasswordField;
  final FocusNode? focusNode;
  final bool isNumberField;
  final String? icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool contentPadding;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double marginBottom;
  final double borderRadius;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final bool? isReadOnly;
  final bool? expand;
  final List<TextInputFormatter>? inputFormatter;
  final VoidCallback? onEditingComplete;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.isPasswordField = false,
    this.focusNode,
    this.isNumberField = false,
    this.controller,
    this.validation,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = true,
    this.paddingHorizontal,
    this.marginBottom = 19,
    this.borderRadius = 8,
    this.paddingVertical,
    this.maxLines,
    this.isReadOnly = false,
    this.minLines,
    this.expand,
    this.inputFormatter,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double responsiveBorderRadius =
        isTabletPortrait ? 12.0 : borderRadius;
    final double responsivePaddingHorizontal =
        paddingHorizontal ?? (isTabletPortrait ? 16.0 : 0.0);
    final double responsivePaddingVertical =
        paddingVertical ?? (isTabletPortrait ? 16.0 : 0.0);
    final double iconHeight = isTabletPortrait ? 28.0 : 22.0;
    final double iconWidth = isTabletPortrait ? 48.0 : 40.0;
    final double focusedBorderWidth = isTabletPortrait ? 2.5 : 2.0;

    final TextStyle textStyle =
        isTabletPortrait
            ? AppStyles.text18PxRegular
            : AppStyles.text14PxRegular;
    final TextStyle hintStyle = (isTabletPortrait
            ? AppStyles.text16PxRegular
            : AppStyles.text14PxRegular)
        .copyWith(color: AppColors.kGrey);
    final TextStyle errorStyle = (isTabletPortrait
            ? AppStyles.text14PxRegular
            : AppStyles.text12PxRegular)
        .copyWith(color: AppColors.kRed);
    return TextFormField(
      controller: controller,
      keyboardType:
          keyboardType ??
          (isNumberField ? TextInputType.number : TextInputType.text),
      focusNode: focusNode,
      onChanged: onChanged,
      readOnly: isReadOnly!,
      expands: expand ?? false,
      maxLines: maxLines ?? 1,
      minLines: minLines,
      validator: validation,
      onEditingComplete: onEditingComplete,
      inputFormatters: inputFormatter,
      autofillHints:
          keyboardType == TextInputType.name
              ? [AutofillHints.name]
              : keyboardType == TextInputType.emailAddress
              ? [AutofillHints.email]
              : keyboardType == TextInputType.phone
              ? [AutofillHints.telephoneNumber]
              : keyboardType == TextInputType.streetAddress
              ? [AutofillHints.fullStreetAddress]
              : keyboardType == TextInputType.url
              ? [AutofillHints.url]
              : keyboardType == TextInputType.visiblePassword
              ? [AutofillHints.password]
              : null,
      autofocus: false,
      textInputAction: textInputAction,
      obscureText: isPasswordField,
      obscuringCharacter: '*',
      style: textStyle,
      decoration: InputDecoration(
        fillColor: AppColors.kLightGrey.withValues(alpha: 0.2),
        hintStyle: hintStyle,
        filled: true,
        isDense: true,
        errorStyle: errorStyle,
        prefixIcon:
            prefixIcon ??
            (icon != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: iconHeight,
                      width: iconWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(icon!),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                )
                : null),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.kTransparentColor),
          borderRadius: BorderRadius.circular(responsiveBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.kButtonGreen,
            width: focusedBorderWidth,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(responsiveBorderRadius),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.kRed),
          borderRadius: BorderRadius.all(
            Radius.circular(responsiveBorderRadius),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.kButtonGreen),
          borderRadius: BorderRadius.all(
            Radius.circular(responsiveBorderRadius),
          ),
        ),
        hintText: hintText,
        contentPadding:
            contentPadding
                ? EdgeInsets.symmetric(
                  horizontal: responsivePaddingHorizontal,
                  vertical: responsivePaddingVertical,
                )
                : EdgeInsets.all(isTabletPortrait ? 16.0 : 12.0),
      ),
    );
  }
}
