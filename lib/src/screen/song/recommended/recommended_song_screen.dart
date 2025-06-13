import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class RecommendedSongScreen extends StatefulWidget {
  const RecommendedSongScreen({super.key});

  @override
  State<RecommendedSongScreen> createState() => _RecommendedSongScreenState();
}

class _RecommendedSongScreenState extends State<RecommendedSongScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<RcmSongProvider>().fetchRecommendedSongs();
    });
  }

  double _getCardWidth(BuildContext context) {
    return AppCardResponsive.getCardWidth(context);
  }

  double _getCardHeight(BuildContext context) {
    return AppCardResponsive.getCardHeight(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RcmSongProvider>(
        builder: (context, provider, child) {
          if (provider.recommendedSongs.isEmpty) {
            return const Center(child: Text('No recommended songs yet.'));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.recommendedSongs.length,
            itemBuilder: (context, index) {
              final rec = provider.recommendedSongs[index];
              logger.d(
                'RecommendedSongScreen: songId: ${rec.songId}, progress: ${rec.progress}, isCompleted: ${rec.isCompleted}',
              );
              final songList =
                  context
                      .read<SongProvider>()
                      .songs
                      .where(
                        (s) =>
                            s.id == rec.songId &&
                            s.media.youtubeLink.isNotEmpty,
                      )
                      .toList();
              final song =
                  songList.isNotEmpty
                      ? songList.first
                      : SongModel(
                        id: rec.songId,
                        titleEn: rec.title,
                        titleNe: '',
                        youtubeTitleEn: '',
                        youtubeTitleNe: '',
                        ageGroup: '',
                        type: '',
                        language: [],
                        media: Media(youtubeLink: rec.youtubeLink),
                        rank: 0,
                        tags: [],
                        categoryName: '',
                      );
              return SizedBox(
                width: _getCardWidth(context),
                height: _getCardHeight(context),
                child: Stack(
                  children: [
                    SongCard(
                      index: index,
                      data: song,
                      initialPosition: rec.progress,
                    ),
                    Positioned(
                      left: 9,
                      right: 5,
                      bottom: 0.25,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 15.7,
                        ),
                        child: LinearProgressIndicator(
                          value: rec.progress.clamp(0.0, 1.0),
                          minHeight: 3,
                          borderRadius: BorderRadius.circular(30),
                          backgroundColor: AppColors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            (rec.isCompleted == 1)
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    if (rec.isCompleted != 1)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
