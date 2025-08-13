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
    if (widget.content.lottie.isNotEmpty) {
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
      if (widget.content.lottie.isNotEmpty) {
        _preloadVideo();
      }

      // Auto-play new content
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _playLottieAnimation();
      });
    }
  }

  Future<void> _preloadVideo() async {
    if (widget.content.lottie.isEmpty) return;

    setState(() {
      _isVideoLoading = true;
    });

    try {
      // Download and cache the video
      final file = await _videoCacheManager.getSingleFile(
        widget.content.lottie,
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
    if (widget.content.lottie.isNotEmpty) {
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
    if (widget.content.lottie.isNotEmpty) {
      _playLottieAnimation();
    }
  }

  void _onSoundTap() {
    // Play wordAudio when sound icon is tapped (for subsequent plays)
    if (widget.content.wordAudio.isNotEmpty) {
      final audioProvider = context.read<LessonAudioProvider>();
      audioProvider.playWordAudio(widget.content.wordAudio);
    }
    // Also call the original onPlay callback if provided
    widget.onPlay?.call();
  }

  Widget _buildImageOrLottie({
    required double width,
    required double height,
    required bool isMobile,
  }) {
    if (_showLottie && widget.content.lottie.isNotEmpty) {
      // Show loading indicator while video is being cached
      if (_isVideoLoading) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[100],
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
                    color: AppColors.kGrey,
                  ),
                ),
              ],
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
        videoPath = widget.content.lottie;
        sourceType = VideoSourceType.network;
      }

      // Show MP4 video (lottie field contains video paths)
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: width,
          height: height,
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
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[100],
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
              if (widget.content.wordAudio.isNotEmpty) {
                final audioProvider = context.read<LessonAudioProvider>();
                audioProvider.playWordAudio(widget.content.wordAudio);
              }
            },
            aspectRatio: 1.0, // Square aspect ratio for consistent layout
          ),
        ),
      );
    } else {
      // Show image with tap functionality
      return GestureDetector(
        onTap: _onImageTap,
        child: CustomImage(
          widget.content.image,
          borderRadius: 16,
          height: isMobile ? height : 120,
          width: isMobile ? width : 120,
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
            width: 50.h(context),
            height: 40.h(context),
            decoration: BoxDecoration(
              color:
                  Utility.isAccessible(widget.content.color)
                      ? Utility.parseHexColors(widget.content.color ?? '').first
                      : AppColors.learningColors[widget.index %
                          AppColors.learningColors.length],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: _buildImageOrLottie(
                width: 120,
                height: 120,
                isMobile: false,
              ),
            ),
          ),
          Gaps.verticalGapOf(20),
          Text(
            widget.content.nameNp.isNotEmpty ? widget.content.nameNp : 'चरा',
            style: AppStyles.text32PxBold.copyWith(
              color: AppColors.kSecondaryColor,
              fontFamily: AppConstants.kMuktaFont,
            ),
          ),
          Text(
            widget.content.nameEn.isNotEmpty ? widget.content.nameEn : 'Bird',
            style: AppStyles.text20PxBold,
          ),
          Gaps.verticalGapOf(16),
          if (widget.hasSound)
            CustomAvatarGlow(
              glowColor: AppColors.kSecondaryColor,
              glowShape: BoxShape.circle,
              visible: widget.isPlaying,
              glowRadiusFactor: 0.2,
              child: IconButton(
                icon: SvgHelper.fromSource(
                  path: Assets.sound,
                  height: 48,
                  width: 48,
                ),
                onPressed: _onSoundTap,
              ),
            ),
        ],
      );
    } else {
      // Mobile: Use Row layout
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
          Gaps.horizontalGapOf(60),
          // Details
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.content.nameNp.isNotEmpty
                    ? widget.content.nameNp
                    : 'चरा',
                style: AppStyles.text32PxBold.copyWith(
                  color: AppColors.kDrawerBgColor,
                  fontSize: 64,
                  fontFamily: AppConstants.kMuktaFont,
                ),
              ),
              Text(
                widget.content.nameEn.isNotEmpty
                    ? widget.content.nameEn
                    : 'Bird',
                style: AppStyles.text20PxBold,
              ),
              Gaps.verticalGapOf(16),
              if (widget.hasSound)
                CustomAvatarGlow(
                  glowColor: AppColors.kSecondaryColor,
                  glowShape: BoxShape.circle,
                  visible: widget.isPlaying,
                  glowRadiusFactor: 0.2,
                  child: IconButton(
                    icon: SvgHelper.fromSource(
                      path: Assets.sound,
                      height: 36,
                      width: 36,
                    ),
                    onPressed: _onSoundTap,
                  ),
                ),
            ],
          ),
        ],
      );
    }
  }
}
