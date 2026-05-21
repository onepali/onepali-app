import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class SongCard extends StatelessWidget {
  final int index;
  final SongModel data;
  // final int childId;
  final double? initialPosition;
  final bool isGuestUser;
  const SongCard({
    super.key,
    required this.index,
    required this.data,
    this.initialPosition,
    this.isGuestUser = false,
    // this.childId = 0,
  });

  @override
  Widget build(BuildContext context) {
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    return GestureDetector(
      onTap: () async {
        logger.d(
          'SongCard: Tapped on song: ${data.id}, youtubeLink: ${data.media.youtubeLink}',
        );

        if (isGuestUser) {
          // Show guest account prompt for songs
          GuestUtil.showGuestAccountPrompt(context);
          return;
        }

        final isLocked = false;
        final subtitle = data.youtubeTitleEn.isNotEmpty
            ? data.youtubeTitleEn
            : null;
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SongVideoPlayerScreen(
              youtubeUrl: data.media.youtubeLink,
              title: data.titleEn,
              subtitle: subtitle,
              isLocked: isLocked,
              info:
                  data.titleEn +
                  (data.categoryName.isNotEmpty
                      ? '\nCategory: ${data.categoryName}'
                      : ''),
              songId: data.id,
              initialPosition: initialPosition,
              image: Utility.generateYoutubeThumbnailUrl(
                data.media.youtubeLink,
              ),
              // childId: childId,
            ),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use parent constraints (from SongScreen's SizedBox) for consistent sizing
          // Width and height are set by parent using AppCardResponsive
          final cardWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : AppCardResponsive.getCardWidth(context);
          final cardHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : AppCardResponsive.getCardHeight(context);

          return Stack(
            children: [
              Container(
                height: cardHeight,
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: 8,
                  top: 8,
                  bottom: 16.0,
                ),
                width: cardWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      Utility.generateYoutubeThumbnailUrl(
                        data.media.youtubeLink,
                      ),
                    ),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      logger.e('Error loading image: $exception');
                      AssetImage(Assets.placeholder);
                    },
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kBlack.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: isTabletLandscape ? 24 : 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kWhite.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      data.titleEn,
                      style: AppStyles.text16PxMedium.copyWith(
                        fontSize: isTabletLandscape ? 24 : 16,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              if (isGuestUser)
                Positioned(
                  top: 20,
                  right: 20,
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
