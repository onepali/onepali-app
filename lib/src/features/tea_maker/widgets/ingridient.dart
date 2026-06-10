import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Ingridient extends StatelessWidget {
  const Ingridient({
    super.key,
    required this.isSelected,
    required this.ingridient,
  });
  final String ingridient;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(ingridient);
  }
}
