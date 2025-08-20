import 'package:flutter/material.dart';

import '../../src.dart';

InkWell customInkwell({
  Widget? child,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
}) {
  return InkWell(
    onLongPress: onLongPress,
    splashColor: AppColors.kTransparentColor,
    focusColor: AppColors.kTransparentColor,
    hoverColor: AppColors.kTransparentColor,
    highlightColor: AppColors.kTransparentColor,
    onTap: onTap,
    child: child,
  );
}
