import 'package:flutter/material.dart';
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
  late int currentIndex;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void playContentAudio() async {
    final audioPath = widget.lesson.lessonContent[currentIndex].audio;
    if (audioPath.isNotEmpty) {
      setState(() => isPlaying = true);
      final audioWidget = CustomAudioWidget(audioPath: audioPath);
      await audioWidget.play();
      setState(() => isPlaying = false);
    }
  }

  void navigateToNext() {
    if (currentIndex < widget.lesson.lessonContent.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void navigateToPrevious() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.lesson.lessonContent[currentIndex];
    final isFirst = currentIndex == 0;
    final isLast = currentIndex == widget.lesson.lessonContent.length - 1;
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: CircleAvatar(
                backgroundColor: AppColors.kSecondaryColor,
                radius: 22,
                child: IconButton(
                  icon: SvgHelper.fromSource(
                    path: Assets.wrong,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgHelper.fromSource(
                      path: Assets.leftArrow,
                      height: 48,
                      width: 48,
                      color:
                          isFirst ? AppColors.kGrey : AppColors.kSecondaryColor,
                    ),
                    onPressed: isFirst || isPlaying ? null : navigateToPrevious,
                  ),
                  Expanded(
                    child: LessonContentCard(
                      content: content,
                      isPlaying: isPlaying,
                      hasSound: widget.hasSound,
                      onPlay: isPlaying ? null : playContentAudio,
                    ),
                  ),
                  IconButton(
                    icon: SvgHelper.fromSource(
                      path: Assets.rightArrow,
                      height: 48,
                      width: 48,
                      color:
                          isLast ? AppColors.kGrey : AppColors.kSecondaryColor,
                    ),
                    onPressed: isLast || isPlaying ? null : navigateToNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
