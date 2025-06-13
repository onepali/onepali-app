import 'package:flutter/material.dart';

InkWell customInkwell({
  Widget? child,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
}) {
  return InkWell(
    onLongPress: onLongPress,
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onTap,
    child: child,
  );
}
