// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:onepali/src/core/core.dart';
// import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
// import 'package:onepali/src/features/lessons/blocs/info_lesson_content_bloc/info_lesson_content_bloc.dart';
// import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
// import 'package:onepali/src/features/lessons/models/lesson.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';

// class InfoLessonView extends StatefulWidget {
//   const InfoLessonView({super.key, required this.lessonInformation});
//   final InfoLessonContent lessonInformation;

//   @override
//   State<InfoLessonView> createState() => _InfoLessonViewState();
// }

// class _InfoLessonViewState extends State<InfoLessonView> {
//   VideoPlayerController? _controller;
//   // late CacheManager _videoCacheManager;
//   // String? cachedVideoPath;

//   @override
//   void initState() {
//     super.initState();
//     // print("----- initstate");
//     // context.read<LessonBloc>().add(
//     //   LessonEvent.playInfo(widget.lessonInformation.index),
//     // );

//     // _videoCacheManager = CacheManager(
//     //   Config(
//     //     AppConstants.lessonVideoCacheDB,
//     //     stalePeriod: const Duration(days: AppConstants.lessonVideoCacheDays),
//     //     maxNrOfCacheObjects: AppConstants.lessonVideoCacheMaxObjects,
//     //     repo: JsonCacheInfoRepository(
//     //       databaseName: AppConstants.lessonVideoCacheDB,
//     //     ),
//     //     fileService: HttpFileService(),
//     //   ),
//     // );

//     // WidgetsBinding.instance.addPostFrameCallback((_) async {
//     //   _playVideo();
//     // });
//   }

//   // void _playVideo() async {
//   //   setState(() {
//   //     _isVideoFinished = false;
//   //   });
//   //   if (widget.lessonInformation.video == null) {
//   //     return;
//   //   }
//   //   final file = await _videoCacheManager.getSingleFile(
//   //     widget.lessonInformation.video!,
//   //     headers: {'Cache-Control': 'max-age=604800'},
//   //   );

//   //   cachedVideoPath = file.path;

//   //   _controller = VideoPlayerController.file(file)
//   //     ..initialize().then((_) {
//   //       setState(() {});
//   //       _controller?.play();
//   //     });

//   //   _controller?.addListener(_videoListener);
//   // }

//   // void _videoListener() {
//   //   if (_controller == null || !_controller!.value.isInitialized) return;

//   //   final isFinished =
//   //       _controller!.value.position >= _controller!.value.duration;

//   //   if (isFinished && !_isVideoFinished) {
//   //     setState(() {
//   //       _isVideoFinished = true;
//   //     });
//   //     _controller!.pause();
//   //     context.read<LessonBloc>().add(LessonEvent.playItemAudio());
//   //   }
//   // }

//   // @override
//   // void dispose() {
//   //   _controller?.removeListener(_videoListener);
//   //   _controller?.dispose();
//   //   super.dispose();
//   // }

//   // @override
//   // void didUpdateWidget(covariant InfoLessonView oldWidget) {
//   //   print("----- didUpdateWidget");
//   //   super.didUpdateWidget(oldWidget);
//   //   _playVideo();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     return BlocProvider(
//       create: (context) =>
//           InfoLessonContentBloc()
//             ..add(InfoLessonContentEvent.started(widget.lessonInformation)),
//       child: BlocBuilder<InfoLessonContentBloc, InfoLessonContentState>(
//         builder: (context, state) {
//           if (state.lessonContent == null) {
//             return Center(child: CircularProgressIndicator());
//           }
//           final content = state.lessonContent!;
//           return Center(
//             child: Stack(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: InkWell(
//                         onTap: () async {
//                           // _controller?.pause();
//                           // context.read<LessonBloc>().add(
//                           //   LessonEvent.previousContent(),
//                           // );
//                         },
//                         child: SvgHelper.fromSource(path: Assets.leftArrow),
//                       ),
//                     ),

//                     // 👇 VIDEO OR IMAGE
//                     Expanded(
//                       flex: 4,
//                       child: LayoutBuilder(
//                         builder: (context, constraints) {
//                           return AspectRatio(
//                             aspectRatio:
//                                 _controller != null &&
//                                     _controller!.value.isInitialized
//                                 ? _controller!.value.aspectRatio
//                                 : 16 / 9,
//                             child: Stack(
//                               fit: StackFit.expand,
//                               children: [
//                                 // 1️⃣ Image as background
//                                 InkWell(
//                                   onTap: () {
//                                     // if (_controller != null) {
//                                     //   // setState(() {
//                                     //   //   _isVideoFinished = false;
//                                     //   // });
//                                     //   _controller!.seekTo(Duration.zero);
//                                     //   _controller!.play();
//                                     // }
//                                   },
//                                   child: CustomCachedImage(
//                                     imageUrl: widget.lessonInformation.image,
//                                     fit: BoxFit.contain, // cover the container
//                                   ),
//                                 ),

//                                 // 2️⃣ Video player on top if playing
//                                 // if (widget.lessonInformation.video != null &&
//                                 //     _controller != null &&
//                                 //     _controller!.value.isInitialized &&
//                                 //     !_isVideoFinished)
//                                 //   VideoPlayer(_controller!),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     // Information Section
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             widget.lessonInformation.nameNp,
//                             style: AppStyles.text32PxBold,
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             widget.lessonInformation.nameEn,
//                             style: AppStyles.text20PxMedium,
//                           ),
//                           const SizedBox(height: 20),
//                           InkWell(
//                             onTap: () {
//                               context.read<LessonBloc>().add(
//                                 LessonEvent.playItemAudio(),
//                               );
//                             },
//                             child: SizedBox(
//                               width: size.width * 0.08,
//                               height: size.width * 0.08,
//                               child: SvgHelper.fromSource(path: Assets.sound),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     Expanded(
//                       flex: 1,
//                       child: InkWell(
//                         onTap: () {
//                           _controller?.pause();
//                           context.read<LessonBloc>().add(
//                             LessonEvent.nextContent(),
//                           );
//                         },
//                         child: SvgHelper.fromSource(path: Assets.rightArrow),
//                       ),
//                     ),
//                   ],
//                 ),

//                 Positioned(
//                   top: size.height * 0.05,
//                   right: size.width * 0.05,
//                   child: SvgHelper.fromSource(path: Assets.wrong),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

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
    _initializeMedia();
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
          _videoController!.play();
        }

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
                    child: InkWell(
                      onTap: () async {
                        context.read<LessonBloc>().add(
                          const LessonEvent.previousContent(),
                        );
                      },
                      child: SvgHelper.fromSource(path: Assets.leftArrow),
                    ),
                  ),

                  // 👇 VIDEO OR IMAGE
                  Expanded(
                    flex: 4,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // 1️⃣ Image as background
                              InkWell(
                                onTap: showVideo ? null : _replayVideo,
                                child: CustomCachedImage(
                                  imageUrl: content.image,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              // 2️⃣ Video player on top if playing
                              if (showVideo) VideoPlayer(_videoController!),
                            ],
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
                        Text(content.nameNp, style: AppStyles.text32PxBold),
                        const SizedBox(height: 20),
                        Text(content.nameEn, style: AppStyles.text20PxMedium),
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
                    child: InkWell(
                      onTap: () {
                        context.read<LessonBloc>().add(
                          LessonEvent.nextContent(),
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
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
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
