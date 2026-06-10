import 'package:flutter/material.dart';

Color? colorFromHex(String? hexColor) {
  if (hexColor == null) return null;
  try {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  } catch (e) {
    return null;
  }
}
