import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/core/widget/common/speaker_icon.dart';
import 'package:onepali/src/features/lessons/blocs/info_lesson_content_bloc/info_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:video_player/video_player.dart';

class MediaCacheManager {
  static const key = 'mediaCache';

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30), // Cache for 30 days
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

class InfoLessonView extends StatefulWidget {
  final InfoLessonContent content;

  const InfoLessonView({super.key, required this.content});

  @override
  State<InfoLessonView> createState() => _InfoLessonViewState();
}

class _InfoLessonViewState extends State<InfoLessonView> {
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    context.read<InfoLessonContentBloc>().add(
      InfoLessonContentEvent.started(widget.content),
    );
    _initializeMedia();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log('InfoLessonView didChangeDependencies');
  }

  Future<void> _initializeMedia() async {
    try {
      // If video is present, cache and initialize it
      final videoUrl = widget.content.video;
      if (videoUrl?.isNotEmpty == true) {
        final videoFile = await MediaCacheManager.instance.getSingleFile(
          videoUrl!,
        );

        if (!mounted) return;

        final videoController = VideoPlayerController.file(videoFile);
        await videoController.initialize();

        if (!mounted) {
          await videoController.dispose();
          return;
        }

        _videoController = videoController;
        _videoController!.addListener(_videoListener);

        setState(() {});
        await _videoController!.play();
      } else {
        // No video, mark as initialized and play audio immediately
        await _playAudio();
      }
    } catch (e) {
      log('Error initializing media: $e');
      if (mounted) {
        await _playAudio();
      }
    }
  }

  void _videoListener() {
    if (_videoController == null) return;

    final position = _videoController!.value.position;
    final duration = _videoController!.value.duration;

    // Check if video has finished playing
    if (duration.inMilliseconds > 0 &&
        position >= duration - const Duration(milliseconds: 100)) {
      // Remove listener to prevent multiple calls
      _videoController!.removeListener(_videoListener);

      final bloc = context.read<InfoLessonContentBloc>();
      bloc.add(const InfoLessonContentEvent.videoCompleted());
      _playAudio();
    }
  }

  Future<void> _playAudio() async {
    final bloc = context.read<InfoLessonContentBloc>();

    try {
      // Dispose previous audio player if exists
      await _audioPlayer?.dispose();

      // Cache the audio file
      final audioFile = await MediaCacheManager.instance.getSingleFile(
        widget.content.audioWord,
      );

      if (!mounted) return;

      final audioPlayer = AudioPlayer();
      _audioPlayer = audioPlayer;
      bloc.add(const InfoLessonContentEvent.audioStarted());

      await audioPlayer.play(DeviceFileSource(audioFile.path));
    } catch (e) {
      log('Error playing audio: $e');
    }
  }

  Future<void> _replayVideo() async {
    if (_videoController != null && _videoController!.value.isInitialized) {
      final bloc = context.read<InfoLessonContentBloc>();

      // Reset state to show video again
      bloc.add(InfoLessonContentEvent.started(widget.content));

      // Re-add listener
      _videoController!.removeListener(_videoListener);
      _videoController!.addListener(_videoListener);

      // Seek to beginning and play
      await _videoController!.seekTo(Duration.zero);
      await _videoController!.play();
    }
  }

  Future<void> _replayAudio() async {
    await _playAudio();
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  Widget _buildMediaContent(InfoLessonContent content, bool showVideo) {
    final hasVideo = content.video != null && content.video!.isNotEmpty;

    if (hasVideo) {
      final showVideoWidget =
          showVideo &&
          _videoController != null &&
          _videoController!.value.isInitialized;

      return Stack(
        children: [
          if (!showVideoWidget)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GestureDetector(
                  onTap: _replayVideo,
                  child: content.isImageSvg
                      ? SvgHelper.fromSource(
                          path: content.image,
                          type: SvgSourceType.network,
                          fit: BoxFit.cover,
                        )
                      : CustomCachedImage(
                          imageUrl: content.image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [if (showVideoWidget) VideoPlayer(_videoController!)],
              ),
            ),
          ),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: content.isImageSvg
            ? SvgHelper.fromSource(
                path: content.image,
                type: SvgSourceType.network,
                fit: BoxFit.contain,
              )
            : CustomCachedImage(imageUrl: content.image, fit: BoxFit.contain),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoLessonContentBloc, InfoLessonContentState>(
      builder: (context, state) {
        if (state.lessonContent == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final showVideo =
            widget.content.video?.isNotEmpty == true && !state.isVideoCompleted;
        final content = state.lessonContent!;

        return Center(
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CenterLeftAlignedBackButton(
                      onTap: () {
                        context.read<LessonBloc>().add(
                          const LessonEvent.previousContent(),
                        );
                      },
                    ),
                  ),

                  Expanded(
                    flex: 4,
                    child: _buildMediaContent(content, showVideo),
                  ),

                  // Information Section
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          content.nameNp,
                          style: AppStyles.text32PxBold.copyWith(
                            color: AppColors.kDrawerBgColor,
                            fontFamily: AppConstants.kMuktaFont,
                            fontSize: 64,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          content.nameEn,
                          style: AppStyles.text20PxMedium.copyWith(
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SpeakerIcon(onTap: _replayAudio),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: CenterRightAlignedForwardButton(
                      onTap: () {
                        context.read<LessonBloc>().add(
                          const LessonEvent.nextContent(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              TopRightPositionedCloseButton(
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
