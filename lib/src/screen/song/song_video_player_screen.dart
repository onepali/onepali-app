import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../src.dart';

class SongVideoPlayerScreen extends StatefulWidget {
  final String youtubeUrl;
  final String? title;
  final String? subtitle;
  final bool isLocked;
  final String? info;
  final String? songId;
  final double? initialPosition;
  final String? image;
  // final int? childId;

  const SongVideoPlayerScreen({
    super.key,
    required this.youtubeUrl,
    this.title,
    this.subtitle,
    this.isLocked = false,
    this.info,
    this.songId,
    this.initialPosition,
    this.image,
    // this.childId,
  });

  @override
  State<SongVideoPlayerScreen> createState() => _SongVideoPlayerScreenState();
}

class _SongVideoPlayerScreenState extends State<SongVideoPlayerScreen> {
  double _lastProgress = 0.0;
  bool _lastCompleted = false;

  void _onProgress(double progress, bool isCompleted) {
    _lastProgress = progress;
    _lastCompleted = isCompleted;
    if (widget.songId != null && widget.songId!.isNotEmpty) {
      context.read<RcmSongProvider>().saveOrUpdateSongProgress(
        songId: widget.songId!,
        progress: progress,
        isCompleted: isCompleted,
        title: widget.title ?? '',
        youtubeLink: widget.youtubeUrl,
        image: widget.image ?? '',
        // childId: widget.childId ?? 0,
      );
    }
  }

  @override
  void dispose() {
    // Save last known progress on exit
    logger.d(
      'SongVideoPlayerScreen: Saving progress on exit: songId=${widget.songId}, progress=$_lastProgress, isCompleted=$_lastCompleted',
    );
    if (widget.songId != null && widget.songId!.isNotEmpty) {
      context.read<RcmSongProvider>().saveOrUpdateSongProgress(
        songId: widget.songId!,
        progress: _lastProgress,
        isCompleted: _lastCompleted,
        title: widget.title ?? '',
        youtubeLink: widget.youtubeUrl,
        image: widget.image ?? '',
        // childId: widget.childId ?? 0,
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d(
      'SongVideoPlayerScreen: Building with songId=${widget.songId}, youtubeUrl=${widget.youtubeUrl}',
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: YoutubeVideoWidget(
          youtubeUrl: widget.youtubeUrl,
          title: widget.title,
          subtitle: widget.subtitle,
          isLocked: widget.isLocked,
          info: widget.info,
          initialPosition: widget.initialPosition,
          onProgress: _onProgress,
        ),
      ),
    );
  }
}
