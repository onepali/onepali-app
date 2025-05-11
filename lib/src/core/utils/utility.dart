import 'package:flutter/material.dart';

class Utility {
  static Future navigate(
    BuildContext context,
    String route, {
    dynamic arguments,
  }) {
    return Navigator.of(context).pushNamed(route, arguments: arguments);
  }

  static navigateMaterialRoute(BuildContext context, screen) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static List<Color> parseHexColors(String hexString) {
    final hexParts = hexString.split('/');
    return hexParts.map((hex) {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }).toList();
  }

  static String formatMoney(double amount) {
    if (amount >= 1e9) {
      return '\$${(amount / 1e9).toStringAsFixed(1)}B';
    } else if (amount >= 1e6) {
      return '\$${(amount / 1e6).toStringAsFixed(1)}M';
    } else if (amount >= 1e3) {
      return '\$${(amount / 1e3).toStringAsFixed(1)}K';
    } else {
      return '\$${amount.toStringAsFixed(2)}';
    }
  }
}
