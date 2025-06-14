import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;
  final bool? isRadius;
  final double? progressPercent;
  final bool isRecommended;
  const StoryCard({
    super.key,
    required this.story,
    this.isRadius = true,
    this.progressPercent,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    logger.d('StoryCard: \\${story.thumbnail}');

    return customInkwell(
      onTap: () {
        Utility.navigateMaterialRoute(
          context,
          StoryContentScreen(story: story),
        );
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.sunshineYellow,
              borderRadius:
                  isRadius == true
                      ? BorderRadius.circular(20)
                      : BorderRadius.zero,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (story.thumbnail.isNotEmpty)
                  SvgHelper.fromSource(
                    path: story.thumbnail,
                    height:
                        isRecommended
                            ? 40.h(context)
                            : AppCardResponsive.getThumbnailHeight(context),
                    width:
                        isRecommended
                            ? 40.w(context)
                            : AppCardResponsive.getThumbnailWidth(context),
                    type: SvgSourceType.network,
                  ),
                Gaps.verticalGapOf(isRecommended ? 8.h(context) : 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      story.nameNp,
                      style:
                          isRecommended
                              ? AppStyles.text22PxRegular.copyWith(
                                fontWeight: FontWeight.bold,
                              )
                              : AppStyles.text18PxRegular.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Gaps.verticalGapOf(4),
                    Text(
                      story.nameEn,
                      style:
                          isRecommended
                              ? AppStyles.text16PxRegular.copyWith(
                                color: AppColors.kGrey,
                              )
                              : AppStyles.text14PxRegular.copyWith(
                                color: AppColors.kGrey,
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (progressPercent != null && progressPercent! > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: -7.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  backgroundColor: Colors.grey.shade300,
                  color: AppColors.kButtonGreen,
                  minHeight: 2.5,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
