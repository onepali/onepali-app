import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:onepali/src/core/core.dart';

class BottomRightCat extends StatelessWidget {
  const BottomRightCat({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.bottomRight,
      child: Animate(
        effects: [ScaleEffect(), ShakeEffect()],
        child: Image.asset(Assets.goodRemark1, height: size.height * 0.4),
      ),
    );
  }
}
