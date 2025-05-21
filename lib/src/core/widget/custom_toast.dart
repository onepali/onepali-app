import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class CustomToast {
  static void showToast(
    BuildContext context,
    String message, {
    Color backgroundColor = AppColors.kButtonGreen,
    Color textColor = AppColors.kWhite,
    Duration duration = const Duration(seconds: 2),
    double borderRadius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 8,
    ),
    double fontSize = 12,
    bool isError = false,
  }) {
    final overlay = Overlay.of(context);

    final Color bgColor = isError ? AppColors.kRed : backgroundColor;

    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 80,
            left: 24,
            right: 24,
            child: Material(
              color: AppColors.transparent,
              child: _ToastWidget(
                message: message,
                backgroundColor: bgColor,
                textColor: bgColor,
                borderRadius: borderRadius,
                padding: padding,
                fontSize: fontSize,
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class _ToastWidget extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const _ToastWidget({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.padding,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 200),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.1),
          border: Border.all(color: backgroundColor, width: 1.2),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: backgroundColor, size: 20),
            Gaps.horizontalGapOf(8),
            Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
