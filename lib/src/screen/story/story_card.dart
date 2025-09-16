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
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    return customInkwell(
      onTap: () {
        if (isGuestUser && isLocked) {
          // Show guest account prompt for locked stories
          GuestUtil.showGuestAccountPrompt(context);
        } else {
          Utility.navigateMaterialRoute(
            context,
            StoryContentScreen(story: story),
          );
        }
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,

            decoration: BoxDecoration(
              color: AppColors.sunshineYellow,
              borderRadius:
                  isRadius == true
                      ? BorderRadius.circular(20)
                      : BorderRadius.zero,
            ),
            margin: !isIntro ? const EdgeInsets.symmetric(horizontal: 8) : null,
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
                Gaps.verticalGapOf(isRecommended ? 8.h(context) : 30),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    story.nameEn,
                    style: AppStyles.text16PxMedium.copyWith(
                      fontSize: isTabletLandscape ? 24 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
      ),
    );
  }
}
