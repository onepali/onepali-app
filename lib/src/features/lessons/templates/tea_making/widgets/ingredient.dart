import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Ingredient extends StatelessWidget {
  const Ingredient({
    super.key,
    required this.isSelected,
    required this.ingredient,
    this.colorFilter,
  });
  final String ingredient;
  final bool isSelected;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: SvgPicture.network(
          ingredient,
          fit: BoxFit.contain,
          colorFilter: colorFilter,
        ),
      ),
    );
  }
}
