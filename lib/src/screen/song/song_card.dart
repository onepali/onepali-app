import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class SongCard extends StatelessWidget {
  final int index;
  final SongModel data;
  const SongCard({super.key, required this.index, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final isLocked = false;
        final subtitle =
            data.youtubeTitleEn.isNotEmpty ? data.youtubeTitleEn : null;
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => SongVideoPlayerScreen(
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
                ),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        margin: EdgeInsets.only(
          left: index == 0 ? 16 : 8,
          right: 8,
          top: 8,
          bottom: 16.0,
        ),
        width: MediaQuery.of(context).size.width * 0.48,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              Utility.generateYoutubeThumbnailUrl(data.media.youtubeLink) ?? '',
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
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              data.titleEn,
              style: AppStyles.text14PxMedium.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
