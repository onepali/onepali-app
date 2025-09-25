import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../../../src.dart';

class LessonContentCard extends StatefulWidget {
  final LessonContent content;
  final bool isPlaying;
  final bool hasSound;
  final VoidCallback? onPlay;
  final int index;
  const LessonContentCard({
    super.key,
    required this.content,
    required this.isPlaying,
    required this.hasSound,
    this.onPlay,
    this.index = 0,
  });

  @override
  State<LessonContentCard> createState() => _LessonContentCardState();
}

class _LessonContentCardState extends State<LessonContentCard>
    with TickerProviderStateMixin {
  bool _showLottie = true;
  late AnimationController _lottieController;
  String? _cachedVideoPath;
  bool _isVideoLoading = false;

  // Custom cache manager for videos with longer duration
  static final _videoCacheManager = CacheManager(
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

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);

    // Preload video if available
    if (widget.content.lottie?.isNotEmpty == true) {
      _preloadVideo();
    }

    // Auto-play video/animation when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playLottieAnimation();
    });
  }

  @override
  void didUpdateWidget(LessonContentCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if content changed (different index)
    if (oldWidget.content != widget.content) {
      // Reset states for new content
      _showLottie = true;
      _cachedVideoPath = null;
      _isVideoLoading = false;

      // Preload new video
      if (widget.content.lottie?.isNotEmpty == true) {
        _preloadVideo();
      }

      // Auto-play new content
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _playLottieAnimation();
      });
    }
  }

  Future<void> _preloadVideo() async {
    if (widget.content.lottie?.isEmpty != false) return;

    setState(() {
      _isVideoLoading = true;
    });

    try {
      // Download and cache the video
      final file = await _videoCacheManager.getSingleFile(
        widget.content.lottie!,
        headers: {
          'Cache-Control': 'max-age=604800', // Cache for 1 week
        },
      );

      if (mounted) {
        setState(() {
          _cachedVideoPath = file.path;
          _isVideoLoading = false;
        });
        logger.d('Video cached successfully: ${file.path}');
      }
    } catch (e) {
      logger.e('Error preloading video: $e');
      if (mounted) {
        setState(() {
          _isVideoLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _playLottieAnimation() async {
    if (widget.content.lottie?.isNotEmpty == true) {
      setState(() {
        _showLottie = true;
      });

      // Since lottie field contains MP4 videos, the CustomVideoPlayer will handle the timing
      // via its onVideoEnd callback, so we don't need to do anything here
      return;
    }
  }

  void _onImageTap() {
    // Replay video when image is tapped
    if (widget.content.lottie?.isNotEmpty == true) {
      _playLottieAnimation();
    }
  }

  void _onSoundTap() {
    // Play wordAudio when sound icon is tapped (for subsequent plays)
    if (widget.content.wordAudio?.isNotEmpty == true) {
      final audioProvider = context.read<LessonAudioProvider>();
      audioProvider.playWordAudio(widget.content.wordAudio!);
    }
    // Also call the original onPlay callback if provided
    widget.onPlay?.call();
  }

  Widget _buildImageOrLottie({
    required double width,
    required double height,
    required bool isMobile,
  }) {
    // Detect tablet landscape mode
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.shortestSide >= 600;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    if (_showLottie && widget.content.lottie?.isNotEmpty == true) {
      // Only increase video size and add padding for tablet landscape
      double videoWidth = width;
      double videoHeight = height;
      EdgeInsetsGeometry videoPadding = EdgeInsets.zero;
      if (isTablet && isLandscape) {
        videoWidth = mediaQuery.size.width * 0.5;
        videoHeight = mediaQuery.size.height * 0.7;
        videoPadding = const EdgeInsets.all(24.0);
      }

      // Show loading indicator while video is being cached
      if (_isVideoLoading) {
        return Padding(
          padding: videoPadding,
          child: Container(
            width: videoWidth,
            height: videoHeight,
            decoration: BoxDecoration(
              color: AppColors.kTransparentColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 2),
                  Gaps.verticalGapOf(8),
                  Text(
                    'Loading video...',
                    style: AppStyles.text12PxRegular.copyWith(
                      color: AppColors.kWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Use cached video path if available, otherwise use network URL
      String videoPath;
      VideoSourceType sourceType;

      if (_cachedVideoPath != null) {
        // For cached files, use file:// protocol
        videoPath = 'file://$_cachedVideoPath';
        sourceType = VideoSourceType.network;
      } else {
        // Use network URL directly
        videoPath = widget.content.lottie!;
        sourceType = VideoSourceType.network;
      }

      // Show MP4 video (lottie field contains video paths)
      return Padding(
        padding: videoPadding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: videoWidth,
            height: videoHeight,
            child: CustomVideoPlayer(
              videoPath: videoPath,
              sourceType: sourceType,
              autoPlay: true,
              loop: false,
              showControls: false,
              fit: BoxFit.cover,
              enableCaching: true,
              optimizeForPerformance: true,
              placeholder: Container(
                width: videoWidth,
                height: videoHeight,
                decoration: BoxDecoration(
                  color: AppColors.kTransparentColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              onVideoStart: () {
                logger.d('Video started playing');
              },
              onVideoEnd: () {
                // When video ends, switch to image
                setState(() {
                  _showLottie = false;
                });

                // Always play wordAudio after video ends
                if (widget.content.wordAudio?.isNotEmpty == true) {
                  final audioProvider = context.read<LessonAudioProvider>();
                  audioProvider.playWordAudio(widget.content.wordAudio!);
                }
              },
              aspectRatio: videoWidth / videoHeight,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: _onImageTap,
        child: CustomImage(
          widget.content.image,
          borderRadius: 16,
          height: height,
          width: width,
          cover: false,
          boxFit: BoxFit.cover,
          circular: false,
          imageType: CustomImageType.network,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    if (!isMobile) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70.h(context),
            height: 50.h(context),
            decoration: BoxDecoration(
              color: Utility.isAccessible(widget.content.color)
                  ? Utility.parseHexColors(widget.content.color ?? '').first
                  : AppColors.learningColors[widget.index %
                        AppColors.learningColors.length],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: _buildImageOrLottie(
                width: 40.h(context),
                height: 25.h(context),
                isMobile: false,
              ),
            ),
          ),
          Gaps.verticalGapOf(20),
          Text(
            (widget.content.nameNp?.isNotEmpty == true)
                ? widget.content.nameNp!
                : 'चरा',
            style: AppStyles.text32PxBold.copyWith(
              color: AppColors.kDrawerBgColor,
              fontFamily: AppConstants.kMuktaFont,
              fontSize: 64,
            ),
          ),
          Text(
            (widget.content.nameEn?.isNotEmpty == true)
                ? widget.content.nameEn!
                : 'Bird',
            style: AppStyles.text20PxMedium.copyWith(fontSize: 32),
          ),
          Gaps.verticalGapOf(16),
          if (widget.hasSound)
            CustomAvatarGlow(
              glowColor: AppColors.kDrawerBgColor,
              glowShape: BoxShape.circle,
              visible: widget.isPlaying,
              glowRadiusFactor: 0.2,
              child: CircularButtonWidget(
                type: CircularButtonType.sound,
                onPressed: _onSoundTap,
              ),
            ),
        ],
      );
    } else {
      // Mobile: Use fixed-width sections for consistent layout
      return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Fixed-size image section (40% of screen width for better balance)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Center(
                child: Container(
                  width: 35.w(context),
                  height: 50.h(context),
                  decoration: BoxDecoration(
                    color:
                        widget.content.color != null &&
                            widget.content.color!.isNotEmpty
                        ? Utility.parseHexColors(widget.content.color!).first
                        : AppColors.learningColors[widget.index %
                              AppColors.learningColors.length],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: _buildImageOrLottie(
                      width: 30.w(context),
                      height: 40.h(context),
                      isMobile: true,
                    ),
                  ),
                ),
              ),
            ),
            // Fixed-size text section (60% of screen width for better balance)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        (widget.content.nameNp?.isNotEmpty == true)
                            ? widget.content.nameNp!
                            : 'चरा',
                        style: AppStyles.text32PxBold.copyWith(
                          color: AppColors.kDrawerBgColor,
                          fontSize: 64,
                          fontFamily: AppConstants.kMuktaFont,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        (widget.content.nameEn?.isNotEmpty == true)
                            ? widget.content.nameEn!
                            : 'Bird',
                        style: AppStyles.text20PxMedium,
                        textAlign: TextAlign.center,
                      ),
                      Gaps.verticalGapOf(16),
                      if (widget.hasSound)
                        CustomAvatarGlow(
                          glowColor: AppColors.kSecondaryColor,
                          glowShape: BoxShape.circle,
                          visible: widget.isPlaying,
                          glowRadiusFactor: 0.2,
                          child: CircularButtonWidget(
                            type: CircularButtonType.sound,
                            onPressed: _onSoundTap,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
