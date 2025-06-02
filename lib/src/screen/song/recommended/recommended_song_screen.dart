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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecommendedSongProvider>().fetchRecommendedSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RecommendedSongProvider>(
        builder: (context, provider, child) {
          if (provider.recommendedSongs.isEmpty) {
            return const Center(child: Text('No recommended songs yet.'));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.recommendedSongs.length,
            itemBuilder: (context, index) {
              final rec = provider.recommendedSongs[index];
              final song = context.read<SongProvider>().songs.firstWhere(
                (s) => s.id == rec.songId,
                orElse:
                    () => SongModel(
                      id: rec.songId,
                      titleEn: '',
                      titleNe: '',
                      youtubeTitleEn: '',
                      youtubeTitleNe: '',
                      ageGroup: '',
                      type: '',
                      language: [],
                      media: Media(youtubeLink: ''),
                      rank: 0,
                      tags: [],
                      categoryName: '',
                    ),
              );
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.43,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => SongVideoPlayerScreen(
                                  youtubeUrl: song.media.youtubeLink,
                                  title: song.titleEn,
                                  subtitle:
                                      song.youtubeTitleEn.isNotEmpty
                                          ? song.youtubeTitleEn
                                          : null,
                                  isLocked: false,
                                  info:
                                      song.titleEn +
                                      (song.categoryName.isNotEmpty
                                          ? '\nCategory: ${song.categoryName}'
                                          : ''),
                                  songId: song.id,
                                  initialPosition: rec.progress,
                                ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Expanded(child: SongCard(index: index, data: song)),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 9,
                      right: 5,
                      bottom: 0.3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 15.7,
                        ),
                        child: LinearProgressIndicator(
                          value: rec.progress.clamp(0.0, 1.0),
                          minHeight: 3,
                          borderRadius: BorderRadius.circular(30),
                          backgroundColor: AppColors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            rec.isCompleted ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    if (!rec.isCompleted)
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
