import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';

class LessonContentScreen extends StatefulWidget {
  final Lesson lesson;
  final List<Lesson> lessons;
  final int initialIndex;
  final bool hasSound;
  const LessonContentScreen({
    super.key,
    required this.lesson,
    required this.lessons,
    this.initialIndex = 0,
    this.hasSound = true,
  });

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  bool _showGoodRemark = false;

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<LessonAudioProvider>();
    final content = widget.lesson.lessonContent[audioProvider.currentIndex];
    final isFirst = audioProvider.currentIndex == 0;
    final isLast =
        audioProvider.currentIndex == widget.lesson.lessonContent.length - 1;
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: SvgHelper.fromSource(
                  path: Assets.wrong,
                  height: 40,
                  width: 40,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isFirst)
                    Container(
                      height: 17.h(context),
                      width: 17.h(context),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kBlack.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.leftArrow,
                          height: 48,
                          width: 48,
                          color: AppColors.kSecondaryColor,
                        ),
                        onPressed:
                            audioProvider.isPlaying
                                ? null
                                : audioProvider.navigateToPreviousContent,
                      ),
                    ),
                  Expanded(
                    child: LessonContentCard(
                      content: content,
                      isPlaying: audioProvider.isPlaying,
                      hasSound: widget.hasSound,
                      onPlay:
                          audioProvider.isPlaying
                              ? null
                              : () async {
                                await audioProvider.playContentAudio(
                                  widget.lesson.lessonContent,
                                  audioSourceType: AudioSourceType.network,
                                );
                                // Show good remark only after audio played at last index
                                if (audioProvider.currentIndex ==
                                    widget.lesson.lessonContent.length - 1) {
                                  setState(() {
                                    _showGoodRemark = true;
                                  });
                                }
                              },
                      index: audioProvider.currentIndex,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      height: 17.h(context),
                      width: 17.h(context),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kBlack.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.rightArrow,
                          height: 48,
                          width: 48,
                          color: AppColors.kSecondaryColor,
                        ),
                        onPressed:
                            audioProvider.isPlaying
                                ? null
                                : () => audioProvider.navigateToNextContent(
                                  widget.lesson.lessonContent,
                                ),
                      ),
                    ),
                ],
              ),
            ),
            // Show good remark image at last index only after audio played
            if (_showGoodRemark && isLast)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                bottom: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: 1.0,
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
