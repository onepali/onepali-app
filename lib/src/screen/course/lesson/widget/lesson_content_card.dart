import 'package:flutter/material.dart';
import '../../../../src.dart';

class LessonContentCard extends StatelessWidget {
  final LessonContent content;
  final bool isPlaying;
  final bool hasSound;
  final VoidCallback? onPlay;
  final int index;
  const LessonContentCard({
    super.key,
    required this.content,
    required this.isPlaying,
    required this.hasSound,
    this.onPlay,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    if (!isMobile) {
      // Tablet/Desktop: Use Column layout
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50.h(context),
            height: 40.h(context),
            decoration: BoxDecoration(
              color:
                  Utility.isAccessible(content.color)
                      ? Utility.parseHexColors(content.color ?? '').first
                      : AppColors.learningColors[index %
                          AppColors.learningColors.length],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: CustomImage(
                content.image,
                borderRadius: 16,
                height: 120,
                width: 120,
                cover: false,
                boxFit: BoxFit.cover,
                circular: false,
                imageType: CustomImageType.network,
              ),
            ),
          ),
          Gaps.verticalGapOf(20),
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
          if (hasSound)
            CustomAvatarGlow(
              glowColor: AppColors.kSecondaryColor,
              glowShape: BoxShape.circle,
              visible: isPlaying,
              glowRadiusFactor: 0.2,
              child: IconButton(
                icon: SvgHelper.fromSource(
                  path: Assets.sound,
                  height: 48,
                  width: 48,
                ),
                onPressed: onPlay,
              ),
            ),
        ],
      );
    } else {
      // Mobile: Use Row layout
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 35.w(context),
            height: 50.h(context),
            decoration: BoxDecoration(
              color:
                  content.color != null && content.color!.isNotEmpty
                      ? Utility.parseHexColors(content.color!).first
                      : AppColors.learningColors[index %
                          AppColors.learningColors.length],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: CustomImage(
                content.image,
                borderRadius: 16,
                height: 40.h(context),
                width: 30.w(context),
                cover: false,
                boxFit: BoxFit.cover,
                circular: false,
                imageType: CustomImageType.network,
              ),
            ),
          ),
          Gaps.horizontalGapOf(100),
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
              if (hasSound)
                CustomAvatarGlow(
                  glowColor: AppColors.kSecondaryColor,
                  glowShape: BoxShape.circle,
                  visible: isPlaying,
                  glowRadiusFactor: 0.2,
                  child: IconButton(
                    icon: SvgHelper.fromSource(
                      path: Assets.sound,
                      height: 36,
                      width: 36,
                    ),
                    onPressed: onPlay,
                  ),
                ),
            ],
          ),
        ],
      );
    }
  }
}
