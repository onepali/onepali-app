import 'package:flutter/material.dart';

import '../../src.dart';

class TitleActionChild extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final EdgeInsets? titlePadding;
  final Widget child;
  final String? subTitle;
  final TextStyle? subTitleStyle;
  final Widget? widget;
  final CrossAxisAlignment? alignment;
  final TextAlign? textAlign;
  final Widget? action;
  final void Function()? onTap;

  const TitleActionChild({
    super.key,
    this.textAlign,
    required this.title,
    this.widget,
    this.alignment,
    this.titleStyle,
    this.titlePadding,
    this.subTitle,
    this.subTitleStyle,
    this.action,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
        children: [
          Padding(
            padding: titlePadding ?? EdgeInsets.zero,
            child: Row(
              children: [
                Text(
                  title,
                  textAlign: textAlign,
                  style: titleStyle ?? AppStyles.text14PxSemiBold,
                ),
                const Spacer(),
                action ?? const SizedBox(),
                Container(
                  child:
                      widget ??
                      InkWell(
                        onTap: onTap,
                        child: Text(
                          subTitle ?? '',
                          textAlign: textAlign,
                          style: subTitleStyle,
                        ),
                      ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
