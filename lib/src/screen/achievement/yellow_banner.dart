import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

/// Yellow banner with message text + celebration image (tablet top row)
class YellowBanner extends StatelessWidget {
  final double height;
  const YellowBanner({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            height: height,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.sunshineYellow,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kBlack.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Text(
                'Your Nepali is improving!',
                style: AppStyles.text24PxBold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Transform.scale(
                scale: 1.2,
                child: Image.asset(
                  Assets.achievementTab,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.celebration, size: 60),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
