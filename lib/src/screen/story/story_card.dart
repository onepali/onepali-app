import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;
  const StoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    logger.d('StoryCard: ${story.thumbnail}');
    final isTablet = PlatformUtility.isTablet(context);
    final isWeb = PlatformUtility.isWeb(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    double cardWidth;
    if (isWeb) {
      cardWidth = 400;
    } else if (isTablet) {
      cardWidth = isLandscape ? 350 : 300;
    } else {
      cardWidth = isLandscape ? 320 : 260;
    }
    return customInkwell(
      onTap: () {
        Utility.navigateMaterialRoute(
          context,
          StoryContentScreen(story: story),
        );
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: AppColors.sunshineYellow,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (story.thumbnail.isNotEmpty)
              SvgHelper.fromSource(
                path: story.thumbnail,
                height: 80,
                width: 80,
                type: SvgSourceType.network,
              ),
            Gaps.verticalGapOf(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    story.nameNp,
                    style: AppStyles.text18PxRegular.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.verticalGapOf(4),
                  Text(
                    story.nameEn,
                    style: AppStyles.text14PxRegular.copyWith(
                      color: AppColors.kGrey,
                    ),
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
