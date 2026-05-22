import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Ingredient extends StatelessWidget {
  const Ingredient({
    super.key,
    required this.isSelected,
    required this.ingredient,
  });
  final String ingredient;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(ingredient);
  }
}
