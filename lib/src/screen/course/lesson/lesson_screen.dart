import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class LessonScreen extends StatelessWidget {
  final Course chapter;
  const LessonScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isWeb = PlatformUtility.isWeb(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final isMobile = PlatformUtility.isMobile(context);
    double cardWidth;
    double listHeight;
    if (isWeb) {
      cardWidth = 400;
      listHeight = 320;
    } else if (isTablet) {
      cardWidth = isLandscape ? 350 : 300;
      listHeight = isLandscape ? 260 : 350;
    } else if (isMobile) {
      cardWidth = AppCardResponsive.getCardWidth(context);
      listHeight = AppCardResponsive.getLessonCardHeight(context);
    } else {
      // Desktop/other platforms
      cardWidth = 400;
      listHeight = 320;
    }

    // Get additional responsive values for comparison
    final cardHeight = AppCardResponsive.getCardHeight(context);
    final lessonCardHeight = AppCardResponsive.getLessonCardHeight(context);
    final thumbnailWidth = AppCardResponsive.getThumbnailWidth(context);
    final thumbnailHeight = AppCardResponsive.getThumbnailHeight(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    logger.d(
      'LessonScreen Dimensions: cardWidth: $cardWidth, listHeight: $listHeight, isTablet: $isTablet, isMobile: $isMobile, isWeb: $isWeb, isLandscape: $isLandscape',
    );
    logger.d(
      'LessonScreen Responsive Values: cardHeight: $cardHeight, lessonCardHeight: $lessonCardHeight, thumbnailWidth: $thumbnailWidth, thumbnailHeight: $thumbnailHeight, screenWidth: $screenWidth, screenHeight: $screenHeight',
    );
    return Scaffold(
      appBar: CustomAppBar(
        title: chapter.nameEn.isNotEmpty ? chapter.nameEn : chapter.nameNp,
        centerTitle: false,
      ),
      body: SizedBox(
        height: listHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: chapter.lessons.length,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemBuilder: (context, idx) {
            final lesson = chapter.lessons[idx];
            return SizedBox(
              width: cardWidth,
              child: LessonCard(
                data: lesson,
                color: AppColors.lessonBgColor,
                isLocked: lesson.progress == 'locked',
                isCompleted: lesson.progress == 'completed',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => LessonContentScreen(
                            lesson: lesson,
                            lessons: chapter.lessons,
                            initialIndex: 0,
                            hasSound: true,
                            nameNp: chapter.nameNp,
                            nameEn: chapter.nameEn,
                          ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
