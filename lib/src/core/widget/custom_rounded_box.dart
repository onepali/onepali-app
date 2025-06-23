import 'package:flutter/material.dart';

import '../../src.dart';

class CustomRoundedBox extends StatelessWidget {
  final String? title;
  final Color? color;
  final IconData? icon;
  final VoidCallback? onTap;
  final double? radius;
  final TextStyle? style;
  const CustomRoundedBox({
    super.key,
    required this.title,
    this.color = AppColors.kPrimaryColor,
    this.onTap,
    this.style,
    this.radius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 20.0),
            color:
                color?.withValues(alpha: 0.2) ??
                Theme.of(context).primaryColor.withValues(alpha: 0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(icon ?? Icons.history_outlined, size: 14, color: color),
              Gaps.horizontalGapOf(5),
              Text(
                title ?? "",
                style:
                    style ?? AppStyles.text10PxRegular.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
