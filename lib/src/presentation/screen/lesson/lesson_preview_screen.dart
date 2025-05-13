import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../src.dart';

class LessonPreviewScreen extends StatelessWidget {
  final Lesson lesson;
  final List<Lesson> lessons;
  final bool hasSound;
  const LessonPreviewScreen({
    super.key,
    required this.lesson,
    required this.lessons,
    required this.hasSound,
  });

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<LessonAudioProvider>();

    final lesson = lessons[audioProvider.currentIndex];

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: Stack(
          children: [
            // Home button top right
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                padding: const EdgeInsets.all(8),
                icon: SvgHelper.fromSource(
                  path: Assets.redo,
                  height: 50,
                  width: 50,
                ),
                color: AppColors.kSecondaryColor,
                alignment: Alignment.center,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Left card
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.kGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.kGreen),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Category tag
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.kGreen,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.park,
                                          size: 16,
                                          color: AppColors.kWhite,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          lesson.type ?? 'जंगली',
                                          style: AppStyles.text14PxSemiBold
                                              .copyWith(
                                                color: AppColors.kWhite,
                                                fontFamily: 'Mukta',
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Gaps.verticalGapOf(20),
                                // Image
                                Expanded(
                                  child:
                                      audioProvider.isPlaying
                                          ? LottieHelper.fromSource(
                                            path: lesson.lottie,
                                          )
                                          : CustomImage(
                                            lesson.image,
                                            borderRadius: 8,
                                            imageType: CustomImageType.local,
                                            boxFit: BoxFit.contain,
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Right card
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.kSecondaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.kSecondaryColor,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  lesson.nameNp,
                                  style: AppStyles.text32PxBold.copyWith(
                                    color: AppColors.kSecondaryColor,
                                    fontFamily: 'Mukta',
                                  ),
                                ),
                                Gaps.verticalGapOf(12),
                                Text(
                                  lesson.nameEn,
                                  style: AppStyles.text20PxBold,
                                ),
                                Gaps.verticalGapOf(20),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.kTeal.withValues(
                                      alpha: 0.1,
                                    ),
                                    border: Border.all(color: AppColors.kTeal),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.pets_outlined,
                                        color: AppColors.kTeal,
                                      ),
                                      Gaps.horizontalGapOf(8),
                                      Expanded(
                                        child: Text(
                                          lesson.tooltip ??
                                              'यो जंगली जनावर हो!',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.text16PxMedium
                                              .copyWith(
                                                color: AppColors.kTeal,
                                                fontFamily: 'Mukta',
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation & Audio
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.leftArrow,
                          height: 48,
                          width: 48,
                          color:
                              audioProvider.isPlaying ||
                                      audioProvider.currentIndex == 0
                                  ? AppColors.kGrey
                                  : AppColors.kSecondaryColor,
                        ),
                        onPressed:
                            audioProvider.isPlaying ||
                                    audioProvider.currentIndex == 0
                                ? null
                                : audioProvider.navigateToPrevious,
                      ),
                      Gaps.horizontalGapOf(24),
                      if (hasSound) ...[
                        CustomAvatarGlow(
                          glowColor: AppColors.kSecondaryColor,
                          glowShape: BoxShape.circle,
                          visible: audioProvider.isPlaying,
                          glowRadiusFactor: 0.2,
                          child: IconButton(
                            icon: SvgHelper.fromSource(
                              path: Assets.sound,
                              height: 55,
                              width: 55,
                              color: AppColors.kPrimaryColor,
                            ),
                            onPressed:
                                audioProvider.isPlaying
                                    ? null
                                    : () => audioProvider.playAudio(lessons),
                          ),
                        ),
                        Gaps.horizontalGapOf(24),
                      ],
                      IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.rightArrow,
                          height: 48,
                          width: 48,
                          color:
                              audioProvider.isPlaying ||
                                      audioProvider.currentIndex ==
                                          lessons.length - 1
                                  ? AppColors.kGrey
                                  : AppColors.kSecondaryColor,
                        ),
                        onPressed:
                            audioProvider.isPlaying ||
                                    audioProvider.currentIndex ==
                                        lessons.length - 1
                                ? null
                                : () => audioProvider.navigateToNext(lessons),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Animated Good Remark
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              bottom:
                  audioProvider.currentIndex == lessons.length - 1 ? 0 : -100,
              right:
                  audioProvider.currentIndex == lessons.length - 1 ? 0 : -100,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity:
                    audioProvider.currentIndex == lessons.length - 1
                        ? 1.0
                        : 0.0,
                child: CustomImage(
                  Assets.goodRemark,
                  height: 150,
                  width: 150,
                  imageType: CustomImageType.local,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
