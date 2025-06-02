import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../src.dart';

class SongVideoPlayerScreen extends StatelessWidget {
  final String youtubeUrl;
  final String? title;
  final String? subtitle;
  final bool isLocked;
  final String? info;
  final String? songId;
  final double? initialPosition;

  const SongVideoPlayerScreen({
    super.key,
    required this.youtubeUrl,
    this.title,
    this.subtitle,
    this.isLocked = false,
    this.info,
    this.songId,
    this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: YoutubeVideoWidget(
          youtubeUrl: youtubeUrl,
          title: title,
          subtitle: subtitle,
          isLocked: isLocked,
          info: info,
          initialPosition: initialPosition,
          onProgress:
              songId != null
                  ? (progress, isCompleted) {
                    context
                        .read<RecommendedSongProvider>()
                        .saveOrUpdateSongProgress(
                          songId: songId!,
                          progress: progress,
                          isCompleted: isCompleted,
                        );
                  }
                  : null,
        ),
      ),
    );
  }
}
