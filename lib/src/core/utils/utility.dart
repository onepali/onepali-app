import 'package:flutter/material.dart';

import '../../src.dart';

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

  static horizontalDividerTitle({String? title, TextStyle? titleStyle}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            indent: 20.0,
            endIndent: 12.0,
            color: AppColors.kGrey,
            thickness: 1,
          ),
        ),
        Text(
          title ?? "Or Continue with",
          style:
              titleStyle ??
              AppStyles.text12PxRegular.copyWith(color: AppColors.kPitchBlack),
        ),
        Expanded(
          child: Divider(
            indent: 12.0,
            endIndent: 20.0,
            color: AppColors.kGrey,
            thickness: 1,
          ),
        ),
      ],
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
