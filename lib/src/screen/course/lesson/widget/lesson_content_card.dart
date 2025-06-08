import 'package:flutter/material.dart';
import '../../../../src.dart';

class LessonContentCard extends StatelessWidget {
  final LessonContent content;
  final bool isPlaying;
  final bool hasSound;
  final VoidCallback? onPlay;
  const LessonContentCard({
    super.key,
    required this.content,
    required this.isPlaying,
    required this.hasSound,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.kTeal.withValues(alpha:0.2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: CustomImage(
              content.image,
              borderRadius: 16,
              imageType: CustomImageType.network, // Use network image type
              boxFit: BoxFit.contain,
            ),
          ),
        ),
        Gaps.horizontalGapOf(24),
        // Details
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content.nameNp.isNotEmpty ? content.nameNp : 'चरा',
              style: AppStyles.text32PxBold.copyWith(
                color: AppColors.kSecondaryColor,
                fontFamily: 'Mukta',
              ),
            ),
            Text(
              content.nameEn.isNotEmpty ? content.nameEn : 'Bird',
              style: AppStyles.text20PxBold,
            ),
            Gaps.verticalGapOf(16),
            if (content.tooltip.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.kTeal.withValues(alpha:0.1),
                  border: Border.all(color: AppColors.kTeal),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: AppColors.kTeal),
                    Gaps.horizontalGapOf(8),
                    Text(
                      content.tooltip,
                      style: AppStyles.text16PxMedium.copyWith(
                        color: AppColors.kTeal,
                        fontFamily: 'Mukta',
                      ),
                    ),
                  ],
                ),
              ),
            Gaps.verticalGapOf(16),
            if (hasSound)
              IconButton(
                icon: SvgHelper.fromSource(
                  path: Assets.sound,
                  height: 36,
                  width: 36,
                  color: Colors.red,
                ),
                onPressed: onPlay,
              ),
          ],
        ),
      ],
    );
  }
}
