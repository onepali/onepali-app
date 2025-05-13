import 'package:flutter/material.dart';
import 'package:onepali/src/data/data.dart';
import 'package:onepali/src/presentation/presentation.dart';

class LessonCard extends StatelessWidget {
  final Category subcategory;

  const LessonCard({super.key, required this.subcategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImage(
          subcategory.image,
          height: 80,
          width: 80,
          boxFit: BoxFit.cover,
        ),
        Gaps.verticalGapOf(8),
        Text(
          subcategory.nameEn,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
