import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

enum CircularButtonType { leftArrow, rightArrow, sound, close, closeGrey }

class CircularButtonWidget extends StatefulWidget {
  final CircularButtonType type;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? margin;
  final Color? iconColor;
  final bool enabled;

  const CircularButtonWidget({
    super.key,
    required this.type,
    required this.onPressed,
    this.margin = const EdgeInsets.symmetric(horizontal: 0),
    this.iconColor,
    this.enabled = true,
  });

  @override
  State<CircularButtonWidget> createState() => _CircularButtonWidgetState();
}

class _CircularButtonWidgetState extends State<CircularButtonWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Icon path
    final String iconPath = switch (widget.type) {
      CircularButtonType.leftArrow => Assets.leftArrow,
      CircularButtonType.rightArrow => Assets.rightArrow,
      CircularButtonType.sound => Assets.sound,
      CircularButtonType.close => Assets.wrong,
      CircularButtonType.closeGrey => Assets.closeGreyIcon,
    };

    // Only arrow buttons get darker shadow when pressed
    final isArrowButton =
        widget.type == CircularButtonType.leftArrow ||
        widget.type == CircularButtonType.rightArrow;

    return GestureDetector(
      onTapDown: isArrowButton && widget.enabled && widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: isArrowButton && widget.enabled && widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: isArrowButton
          ? () => setState(() => _isPressed = false)
          : null,
      child: Container(
        padding: EdgeInsets.zero,
        decoration: isArrowButton
            ? BoxDecoration(
                color: AppColors.kWhite,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isPressed
                      ? AppColors.kBlack.withValues(
                          alpha: 0.3,
                        ) // Darker border when pressed
                      : AppColors.kBlack.withValues(
                          alpha: 0.05,
                        ), // Very light border when not pressed
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              )
            : null,
        child: IconButton(
          constraints: const BoxConstraints(),
          icon: SvgHelper.fromSource(
            path: iconPath,
            height: Dimensions.kIconSize(context),
            width: Dimensions.kIconSize(context),
            color: widget.enabled ? widget.iconColor : AppColors.kGrey,
          ),
          onPressed: widget.enabled ? widget.onPressed : null,
        ),
      ),
    );
  }
}
