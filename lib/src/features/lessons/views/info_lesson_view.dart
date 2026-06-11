import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
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

        return Center(
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: GestureDetector(
                          onTap: () async {
                            context.read<LessonBloc>().add(
                              const LessonEvent.previousContent(),
                            );
                          },
                          child: SvgHelper.fromSource(path: Assets.leftArrow),
                        ),
                      ),
                    ),
                  ),

                  // 👇 VIDEO OR IMAGE
                  Expanded(
                    flex: 4,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // 1️⃣ Image as background
                                InkWell(
                                  onTap: showVideo ? null : _replayVideo,
                                  child: CustomCachedImage(
                                    imageUrl: content.image,
                                    // fit: BoxFit.cover,
                                  ),
                                ),

                                // 2️⃣ Video player on top if playing
                                if (showVideo &&
                                    _videoController != null &&
                                    _videoController!.value.isInitialized)
                                  VideoPlayer(_videoController!),
                              ],
                            ),
                          ),
                        );
                      },
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
                        InkWell(
                          onTap: _replayAudio,
                          child: SizedBox(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            child: SvgHelper.fromSource(path: Assets.sound),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            context.read<LessonBloc>().add(
                              LessonEvent.nextContent(),
                            );
                          },
                          child: SvgHelper.fromSource(path: Assets.rightArrow),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                    child: SvgHelper.fromSource(
                      path: Assets.wrong,
                      // height: isMobile ? 48 : null,
                      // width: isMobile ? 48 : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
