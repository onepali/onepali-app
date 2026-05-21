import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;
  final bool? isRadius;
  final double? progressPercent;
  final bool isRecommended;
  final bool isGuestUser;
  final bool isLocked;
  final bool isIntro;
  const StoryCard({
    super.key,
    required this.story,
    this.isRadius = true,
    this.progressPercent,
    this.isRecommended = false,
    this.isGuestUser = false,
    this.isLocked = false,
    this.isIntro = false,
  });

  @override
  Widget build(BuildContext context) {
    logger.d('StoryCard: \\${story.thumbnail}');

    return customInkwell(
      onTap: () {
        if (isGuestUser && isLocked) {
          // Show guest account prompt for locked stories
          GuestUtil.showGuestAccountPrompt(context);
        } else {
          Utility.navigateMaterialRoute(
            context,
            StoryContentScreen(story: story, isFromRecommended: isRecommended),
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, outerConstraints) {
          final cardHeight = outerConstraints.maxHeight.isFinite
              ? outerConstraints.maxHeight
              : AppCardResponsive.getCardHeight(context);

          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: cardHeight,
                decoration: BoxDecoration(
                  color: AppColors.sunshineYellow,
                  borderRadius: isRadius == true
                      ? BorderRadius.circular(20)
                      : BorderRadius.zero,
                ),
                margin: !isIntro
                    ? const EdgeInsets.symmetric(horizontal: 8)
                    : null,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableHeight = constraints.maxHeight.isFinite
                        ? constraints.maxHeight
                        : cardHeight;

                    // Calculate sizes based on card height (availableHeight = card height)
                    // Percentages are relative to card height:
                    // - Thumbnail: 65% of card height
                    // - Gap: 0.5% of card height
                    // - Text: 27% of card height
                    // Total: 92.5% of card height - well within bounds, no overflow possible
                    // These percentages match AppCardResponsive for consistency across mobile and tablet
                    final thumbnailHeight = availableHeight * 0.65;
                    final thumbnailWidth = thumbnailHeight;
                    final gapHeight = availableHeight * 0.005;
                    final textHeight = availableHeight * 0.27;

                    return ClipRect(
                      child: SizedBox(
                        height: availableHeight,
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (story.thumbnail.isNotEmpty)
                                ClipRect(
                                  child: SizedBox(
                                    height: thumbnailHeight,
                                    width: thumbnailWidth,
                                    child: SvgHelper.fromSource(
                                      path: story.thumbnail,
                                      height: thumbnailHeight,
                                      width: thumbnailWidth,
                                      type: SvgSourceType.network,
                                    ),
                                  ),
                                ),
                              SizedBox(height: gapHeight),
                              SizedBox(
                                height: textHeight,
                                child: Center(
                                  child: Text(
                                    story.nameEn,
                                    style: AppStyles.text16PxMedium.copyWith(
                                      fontSize:
                                          PlatformUtility.isTablet(context) &&
                                              PlatformUtility.isLandscape(
                                                context,
                                              )
                                          ? 18
                                          : 14,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (progressPercent != null && progressPercent! > 0)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -7.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: LinearProgressIndicator(
                      value: progressPercent,
                      backgroundColor: Colors.grey.shade300,
                      color: AppColors.kRed,
                      minHeight: 2.5,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              if (isGuestUser && isLocked)
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: AppColors.kWhite.withValues(alpha: 0.8),
                    radius: 14,
                    child: Icon(Icons.lock, color: AppColors.kBlack, size: 18),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
