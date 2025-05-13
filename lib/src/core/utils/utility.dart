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

  static IconData? getProgressTypeIcon(String type) {
    switch (type) {
      case 'completed':
        return Icons.check_circle;
      case 'locked':
        return Icons.lock;
      case 'in-progress':
        return Icons.hourglass_bottom;
      default:
        return null;
    }
  }
}
