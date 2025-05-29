import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/youtube_video_widget.dart';

class SongVideoPlayerScreen extends StatelessWidget {
  final String youtubeUrl;
  final String? title;
  final String? subtitle;
  final bool isLocked;
  final String? info;

  const SongVideoPlayerScreen({
    super.key,
    required this.youtubeUrl,
    this.title,
    this.subtitle,
    this.isLocked = false,
    this.info,
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
        ),
      ),
    );
  }
}
