import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class InfoLessonView extends StatefulWidget {
  const InfoLessonView({super.key, required this.lessonInformation});
  final InfoLessonContent lessonInformation;

  @override
  State<InfoLessonView> createState() => _InfoLessonViewState();
}

class _InfoLessonViewState extends State<InfoLessonView> {
  VideoPlayerController? _controller;
  bool _isVideoFinished = false;
  late CacheManager _videoCacheManager;
  String? cachedVideoPath;

  @override
  void initState() {
    super.initState();

    context.read<LessonBloc>().add(
      LessonEvent.playInfo(widget.lessonInformation.index),
    );

    _videoCacheManager = CacheManager(
      Config(
        AppConstants.lessonVideoCacheDB,
        stalePeriod: const Duration(days: AppConstants.lessonVideoCacheDays),
        maxNrOfCacheObjects: AppConstants.lessonVideoCacheMaxObjects,
        repo: JsonCacheInfoRepository(
          databaseName: AppConstants.lessonVideoCacheDB,
        ),
        fileService: HttpFileService(),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final videoUrl = widget.lessonInformation.video;
      if (videoUrl.isEmpty) return;

      try {
        final file = await _videoCacheManager.getSingleFile(
          videoUrl,
          headers: {'Cache-Control': 'max-age=604800'},
        );
        if (!mounted) return;

        final controller = VideoPlayerController.file(file);
        await controller.initialize();

        if (!mounted) {
          await controller.dispose();
          return;
        }

        _controller = controller;
        _controller!.addListener(_videoListener);

        setState(() {});
        _controller!.play();
      } catch (error) {
        debugPrint('Failed to load lesson video: $error');
        if (!mounted) return;
        setState(() {
          _controller = null;
          _isVideoFinished = true;
        });
        return;
      }
    });
  }

  void _videoListener() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final isFinished =
        _controller!.value.position >= _controller!.value.duration;

    if (isFinished && !_isVideoFinished) {
      if (!mounted) return;
      setState(() {
        _isVideoFinished = true;
      });
      _controller!.pause();
      context.read<LessonBloc>().add(LessonEvent.playItemAudio());
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    context.read<LessonBloc>().add(
                      LessonEvent.previousContent(),
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
                      aspectRatio:
                          _controller != null &&
                              _controller!.value.isInitialized
                          ? _controller!.value.aspectRatio
                          : 16 / 9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // 1️⃣ Image as background
                          InkWell(
                            onTap: () {
                              if (_controller != null) {
                                setState(() {
                                  _isVideoFinished = false;
                                });
                                _controller!.seekTo(Duration.zero);
                                _controller!.play();
                              }
                            },
                            child: CustomCachedImage(
                              imageUrl: widget.lessonInformation.image,
                              fit: BoxFit.contain, // cover the container
                            ),
                          ),

                          // 2️⃣ Video player on top if playing
                          if (_controller != null &&
                              _controller!.value.isInitialized &&
                              !_isVideoFinished)
                            VideoPlayer(_controller!),
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
                    Text(
                      widget.lessonInformation.nameNp,
                      style: AppStyles.text32PxBold,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.lessonInformation.nameEn,
                      style: AppStyles.text20PxMedium,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        context.read<LessonBloc>().add(
                          LessonEvent.playItemAudio(),
                        );
                      },
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
                    context.read<LessonBloc>().add(LessonEvent.nextContent());
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
              onTap: () => Navigator.of(context).pop(),
              child: SvgHelper.fromSource(path: Assets.wrong),
            ),
          ),
        ],
      ),
    );
  }
}
