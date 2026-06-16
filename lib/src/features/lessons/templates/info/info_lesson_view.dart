import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/core/widget/common/speaker_icon.dart';
import 'package:onepali/src/features/lessons/templates/info/info_lesson_content_bloc/info_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:video_player/video_player.dart';

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
    print('InfoLessonView didChangeDependencies');
  }

  Future<void> _initializeMedia() async {
    try {
      // If video is present, cache and initialize it
      if (widget.content.video != null) {
        final videoFile = await MediaCacheManager.instance.getSingleFile(
          widget.content.video!,
        );

        _videoController = VideoPlayerController.file(videoFile);
        await _videoController!.initialize();

        if (mounted) {
          _videoController?.play();
        }
        setState(() {});
        // Listen for video completion
        _videoController!.addListener(_videoListener);
      } else {
        // No video, mark as initialized and play audio immediately
        if (mounted) {}
        await _playAudio();
      }
    } catch (e) {
      log('Error initializing media: $e');
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

      _audioPlayer = AudioPlayer();
      bloc.add(const InfoLessonContentEvent.audioStarted());

      await _audioPlayer!.play(DeviceFileSource(audioFile.path));
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocBuilder<InfoLessonContentBloc, InfoLessonContentState>(
      builder: (context, state) {
        if (state.lessonContent == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final showVideo =
            widget.content.video != null && !state.isVideoCompleted;
        final content = state.lessonContent!;

        return Stack(
          children: [
            Row(
              children: [
                Expanded(flex: 1, child: SizedBox.shrink()),
                // 👇 VIDEO OR IMAGE
                Expanded(
                  flex: 4,
                  child: widget.content.video != null
                      ? LayoutBuilder(
                          builder: (context, constraints) {
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
                                      children: [
                                        // 2️⃣ Video player on top if playing
                                        if (showVideoWidget)
                                          VideoPlayer(_videoController!),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: content.isImageSvg
                                ? SvgHelper.fromSource(
                                    path: content.image,
                                    type: SvgSourceType.network,
                                    fit: BoxFit.contain,
                                  )
                                : CustomCachedImage(
                                    imageUrl: content.image,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
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
                Expanded(flex: 1, child: SizedBox.shrink()),
              ],
            ),
            // Close button
            TopRightPositionedCloseButton(
              onTap: () => Navigator.pop(context),
            ),
        
            //  LEFT ARROW
            CenterLeftAlignedBackButton(
              onTap: () {
                context.read<LessonBloc>().add(
                  const LessonEvent.previousContent(),
                );
              },
            ),
            // Forward button
            CenterRightAlignedForwardButton(
              onTap: () {
                context.read<LessonBloc>().add(LessonEvent.nextContent());
              },
            ),
          ],
        );
      },
    );
  }
}
