import 'package:flutter/material.dart';
import 'package:onepali/src/core/utils/platform_utility.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';

typedef LessonContentFrameBuilder =
    Widget Function(BuildContext context, BoxConstraints constraints);

double lessonControlButtonSize(BuildContext context) {
  final isMobile = PlatformUtility.isMobile(context);
  return isMobile ? closeBtnIconSizeMobile : closeBtnIconSizeTablet;
}

double lessonControlEdgePadding(BuildContext context) {
  final isMobile = PlatformUtility.isMobile(context);
  return isMobile ? closeBtnPositionMobile : closeBtnPositionTablet;
}

double lessonContentInsetStart(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final safeInset = mediaQuery.padding.left > mediaQuery.viewPadding.left
      ? mediaQuery.padding.left
      : mediaQuery.viewPadding.left;
  return safeInset +
      leftAlignedBackButtonPadding(context) +
      lessonControlButtonSize(context);
}

double lessonContentInsetEnd(BuildContext context) {
  return lessonControlEdgePadding(context) + lessonControlButtonSize(context);
}

double lessonCloseButtonInsetEnd(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final safeInset = mediaQuery.padding.right > mediaQuery.viewPadding.right
      ? mediaQuery.padding.right
      : mediaQuery.viewPadding.right;
  return safeInset +
      lessonControlEdgePadding(context) +
      lessonControlButtonSize(context);
}

double lessonSafeAreaInsetStart(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  return mediaQuery.padding.left > mediaQuery.viewPadding.left
      ? mediaQuery.padding.left
      : mediaQuery.viewPadding.left;
}

double lessonSafeAreaInsetEnd(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  return mediaQuery.padding.right > mediaQuery.viewPadding.right
      ? mediaQuery.padding.right
      : mediaQuery.viewPadding.right;
}

double lessonSafeAreaInsetBottom(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  return mediaQuery.padding.bottom > mediaQuery.viewPadding.bottom
      ? mediaQuery.padding.bottom
      : mediaQuery.viewPadding.bottom;
}

double lessonTopControlInset(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final safeInset = mediaQuery.padding.top > mediaQuery.viewPadding.top
      ? mediaQuery.padding.top
      : mediaQuery.viewPadding.top;
  return safeInset +
      lessonControlEdgePadding(context) +
      lessonControlButtonSize(context) +
      lessonControlEdgePadding(context);
}

class LessonContentFrame extends StatelessWidget {
  const LessonContentFrame({
    super.key,
    required this.builder,
    this.reserveLeftControl = true,
    this.reserveRightControl = true,
    this.reserveTopControl = false,
    this.reserveBottomSafeArea = false,
  });

  final LessonContentFrameBuilder builder;
  final bool reserveLeftControl;
  final bool reserveRightControl;
  final bool reserveTopControl;
  final bool reserveBottomSafeArea;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: reserveLeftControl
          ? lessonContentInsetStart(context)
          : lessonSafeAreaInsetStart(context),
      right: reserveRightControl
          ? lessonContentInsetEnd(context)
          : lessonSafeAreaInsetEnd(context),
      top: reserveTopControl ? lessonTopControlInset(context) : 0,
      bottom: reserveBottomSafeArea ? lessonSafeAreaInsetBottom(context) : 0,
      child: LayoutBuilder(
        builder: (context, constraints) => builder(context, constraints),
      ),
    );
  }
}
