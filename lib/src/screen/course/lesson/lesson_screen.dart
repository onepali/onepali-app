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
    final isMobileLandScape = PlatformUtility.isMobile(context) && isLandscape;
    double cardWidth;
    double listHeight;
    if (isWeb) {
      cardWidth = 400;
      listHeight = 320;
    } else if (isTablet) {
      cardWidth = isLandscape ? 350 : 300;
      listHeight = isLandscape ? 260 : 350;
    } else {
      cardWidth =
          isMobileLandScape ? AppCardResponsive.getCardWidth(context) : 260;
      listHeight =
          isMobileLandScape
              ? AppCardResponsive.getLessonCardHeight(context) + 50
              : 320;
    }
    logger.d(
      'LessonScreen: cardWidth: $cardWidth, listHeight: $listHeight, isTablet: $isTablet, isMobileLandScape: $isMobileLandScape, isWeb: $isWeb, isLandscape: $isLandscape',
    );
    return Scaffold(
      appBar: CustomAppBar(
        title: chapter.nameEn.isNotEmpty ? chapter.nameEn : chapter.nameNp,
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chapter.lessons.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, idx) {
          final lesson = chapter.lessons[idx];
          return SizedBox(
            width: cardWidth,
            height: listHeight,

            child: LessonCard(
              data: lesson,
              color: Colors.teal[200]!,
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
    );
  }
}
