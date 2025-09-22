import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

enum CircularButtonType { leftArrow, rightArrow, sound, close }

class CircularButtonWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Icon path
    final String iconPath = switch (type) {
      CircularButtonType.leftArrow => Assets.leftArrow,
      CircularButtonType.rightArrow => Assets.rightArrow,
      CircularButtonType.sound => Assets.sound,
      CircularButtonType.close => Assets.wrong,
    };

    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.kBlack.withValues(alpha: 0.025),
            blurRadius: 3.24,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        constraints: const BoxConstraints(),
        icon: SvgHelper.fromSource(
          path: iconPath,
          height: Dimensions.kIconSize(context),
          width: Dimensions.kIconSize(context),
          color: enabled ? iconColor : AppColors.kGrey,
        ),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}
