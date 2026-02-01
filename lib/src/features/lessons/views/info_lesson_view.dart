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
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

class InfoLessonView extends StatefulWidget {
  const InfoLessonView({super.key, required this.content});

  final InfoLessonContent content;

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

  Future<void> _initializeMedia() async {
    try {
      final videoUrl = widget.content.video;
      if (videoUrl != null && videoUrl.isNotEmpty) {
        final videoFile = await MediaCacheManager.instance.getSingleFile(
          videoUrl,
        );

        final controller = VideoPlayerController.file(videoFile);
        await controller.initialize();

        if (!mounted) {
          await controller.dispose();
          return;
        }

        _videoController = controller;
        _videoController!.addListener(_videoListener);
        setState(() {});
        await _videoController!.play();
      } else {
        await _playAudio();
      }
    } catch (e) {
      log('Error initializing media: $e');
    }
  }

  void _videoListener() {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;

    final position = controller.value.position;
    final duration = controller.value.duration;

    if (duration.inMilliseconds > 0 &&
        position >= duration - const Duration(milliseconds: 100)) {
      controller.removeListener(_videoListener);

      final bloc = context.read<InfoLessonContentBloc>();
      bloc.add(const InfoLessonContentEvent.videoCompleted());
      _playAudio();
    }
  }

  Future<void> _playAudio() async {
    final bloc = context.read<InfoLessonContentBloc>();

    try {
      await _audioPlayer?.dispose();

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
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;

    final bloc = context.read<InfoLessonContentBloc>();
    bloc.add(InfoLessonContentEvent.started(widget.content));

    controller.removeListener(_videoListener);
    controller.addListener(_videoListener);

    await controller.seekTo(Duration.zero);
    await controller.play();
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

        final content = state.lessonContent!;
        final showVideo =
            widget.content.video != null && !state.isVideoCompleted;
        final videoReady =
            _videoController != null && _videoController!.value.isInitialized;

        return Center(
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        context.read<LessonBloc>().add(
                          const LessonEvent.previousContent(),
                        );
                      },
                      child: SvgHelper.fromSource(path: Assets.leftArrow),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: showVideo && videoReady
                            ? _videoController!.value.aspectRatio
                            : 16 / 9,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            InkWell(
                              onTap: showVideo ? null : _replayVideo,
                              child: CustomCachedImage(
                                imageUrl: content.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (showVideo && videoReady)
                              VideoPlayer(_videoController!)
                            else
                              CustomCachedImage(
                                imageUrl: content.image,
                                fit: BoxFit.cover,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                    child: GestureDetector(
                      onTap: () {
                        context.read<LessonBloc>().add(
                          const LessonEvent.nextContent(),
                        );
                      },
                      child: SvgHelper.fromSource(path: Assets.rightArrow),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: size.height * 0.05,
                right: size.width * 0.05,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: SvgHelper.fromSource(path: Assets.wrong),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
