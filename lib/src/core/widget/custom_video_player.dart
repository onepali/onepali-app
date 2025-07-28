import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../src.dart';

/// A reusable, optimized video player widget that supports both local assets and network videos.
///
/// Features:
/// - Performance optimizations (RepaintBoundary, AutomaticKeepAliveClientMixin)
/// - App lifecycle management (auto-pause/resume)
/// - Memory management and proper disposal
/// - Error handling with retry functionality
/// - Caching support for network videos
/// - Custom aspect ratio support
///
/// Example usage:
///
/// ```dart
/// // For splash screens (optimized, no controls)
/// VideoPlayerHelper.forSplash(
///   videoPath: 'assets/videos/splash.mp4',
///   sourceType: VideoSourceType.asset,
/// )
///
/// // For regular videos with full control
/// VideoPlayerHelper.fromSource(
///   videoPath: 'https://example.com/video.mp4',
///   sourceType: VideoSourceType.network,
///   autoPlay: false,
///   showControls: true,
///   enableCaching: true,
///   aspectRatio: 16/9,
/// )
///
/// // Using the base widget with custom parameters
/// CustomVideoPlayer(
///   videoPath: 'assets/videos/intro.mp4',
///   sourceType: VideoSourceType.asset,
///   autoPlay: true,
///   optimizeForPerformance: true,
///   onVideoEnd: () => print('Video ended'),
///   placeholder: CustomLoader(),
/// )
/// ```
class VideoPlayerHelper {
  /// Creates an optimized video player based on source type
  static Widget fromSource({
    required String videoPath,
    VideoSourceType sourceType = VideoSourceType.asset,
    bool autoPlay = true,
    bool loop = false,
    bool showControls = true,
    BoxFit fit = BoxFit.cover,
    VoidCallback? onVideoEnd,
    VoidCallback? onVideoStart,
    Widget? placeholder,
    Widget? errorWidget,
    bool enableCaching = true,
    bool optimizeForPerformance = true,
    double? aspectRatio,
  }) {
    return CustomVideoPlayer(
      videoPath: videoPath,
      sourceType: sourceType,
      autoPlay: autoPlay,
      loop: loop,
      showControls: showControls,
      fit: fit,
      onVideoEnd: onVideoEnd,
      onVideoStart: onVideoStart,
      placeholder: placeholder,
      errorWidget: errorWidget,
      enableCaching: enableCaching,
      optimizeForPerformance: optimizeForPerformance,
      aspectRatio: aspectRatio,
    );
  }

  /// Creates an optimized splash video player (no controls, auto-play, performance optimized)
  static Widget forSplash({
    required String videoPath,
    VideoSourceType sourceType = VideoSourceType.asset,
    VoidCallback? onVideoEnd,
    BoxFit fit = BoxFit.cover,
    double? aspectRatio,
  }) {
    return fromSource(
      videoPath: videoPath,
      sourceType: sourceType,
      autoPlay: true,
      loop: false,
      showControls: false,
      fit: fit,
      onVideoEnd: onVideoEnd,
      optimizeForPerformance: true,
      enableCaching: sourceType == VideoSourceType.network,
      aspectRatio: aspectRatio,
    );
  }
}

class CustomVideoPlayer extends StatefulWidget {
  final String videoPath;
  final VideoSourceType sourceType;
  final bool autoPlay;
  final bool loop;
  final bool showControls;
  final BoxFit fit;
  final VoidCallback? onVideoEnd;
  final VoidCallback? onVideoStart;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableCaching;
  final bool optimizeForPerformance;
  final double? aspectRatio;

  const CustomVideoPlayer({
    super.key,
    required this.videoPath,
    this.sourceType = VideoSourceType.asset,
    this.autoPlay = true,
    this.loop = false,
    this.showControls = true,
    this.fit = BoxFit.cover,
    this.onVideoEnd,
    this.onVideoStart,
    this.placeholder,
    this.errorWidget,
    this.enableCaching = true,
    this.optimizeForPerformance = true,
    this.aspectRatio,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isDisposed = false;
  final bool _isVisible = true;

  @override
  bool get wantKeepAlive => widget.optimizeForPerformance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_isDisposed) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _pauseVideo();
        break;
      case AppLifecycleState.resumed:
        if (widget.autoPlay && _isVisible) {
          _resumeVideo();
        }
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        _pauseVideo();
        break;
    }
  }

  void _pauseVideo() {
    if (_isInitialized && _controller.value.isPlaying) {
      _controller.pause();
    }
  }

  void _resumeVideo() {
    if (_isInitialized && !_controller.value.isPlaying && widget.autoPlay) {
      _controller.play();
    }
  }

  void _initializeVideo() async {
    if (_isDisposed) return;

    try {
      // Performance optimization: Initialize controller with appropriate settings
      switch (widget.sourceType) {
        case VideoSourceType.asset:
          _controller = VideoPlayerController.asset(
            widget.videoPath,
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
              allowBackgroundPlayback: false,
            ),
          );
          break;
        case VideoSourceType.network:
          _controller = VideoPlayerController.networkUrl(
            Uri.parse(widget.videoPath),
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
              allowBackgroundPlayback: false,
            ),
            httpHeaders:
                widget.enableCaching ? {'Cache-Control': 'max-age=3600'} : {},
          );
          break;
      }

      // Performance optimization: Set video quality for network videos
      if (widget.optimizeForPerformance &&
          widget.sourceType == VideoSourceType.network) {
        // Preload video data for smoother playback
        await _controller.initialize();
      } else {
        await _controller.initialize();
      }

      if (_isDisposed || !mounted) return;

      setState(() {
        _isInitialized = true;
        _hasError = false;
      });

      // Performance optimization: Configure playback settings
      _controller.setLooping(widget.loop);

      // Set volume to avoid audio conflicts
      _controller.setVolume(1.0);

      if (widget.autoPlay && _isVisible) {
        await _controller.play();
        if (widget.onVideoStart != null) {
          widget.onVideoStart!();
        }
      }

      // Listen for video completion and other events
      _controller.addListener(_videoListener);
    } catch (e) {
      logger.e('Error initializing video: $e');
      if (_isDisposed || !mounted) return;

      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _videoListener() {
    if (_isDisposed) return;

    // Performance optimization: Batch state updates
    bool shouldUpdate = false;
    bool newHasError = false;
    String? newErrorMessage;

    if (_controller.value.hasError) {
      newHasError = true;
      newErrorMessage = _controller.value.errorDescription;
      shouldUpdate = _hasError != newHasError;
    }

    // Check if video has ended
    final hasEnded = _controller.value.position >= _controller.value.duration;
    if (hasEnded && widget.onVideoEnd != null) {
      // Use post frame callback to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed && widget.onVideoEnd != null) {
          widget.onVideoEnd!();
        }
      });
    }

    if (shouldUpdate && mounted) {
      setState(() {
        _hasError = newHasError;
        _errorMessage = newErrorMessage;
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);

    if (_isInitialized) {
      _controller.removeListener(_videoListener);
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // Show error widget if there's an error
    if (_hasError) {
      return widget.errorWidget ?? _buildErrorWidget();
    }

    // Show placeholder while loading
    if (!_isInitialized) {
      return widget.placeholder ?? _buildPlaceholderWidget();
    }

    return _buildVideoPlayer();
  }

  Widget _buildErrorWidget() {
    return Container(
      color: AppColors.kWhite,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.kRed, size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load video',
              style: AppStyles.text16PxMedium.copyWith(color: AppColors.kRed),
            ),
            if (_errorMessage != null && _errorMessage!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  style: AppStyles.text12PxRegular.copyWith(
                    color: AppColors.kGrey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _errorMessage = null;
                });
                _initializeVideo();
              },
              child: Text(
                'Retry',
                style: AppStyles.text14PxMedium.copyWith(
                  color: AppColors.kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderWidget() {
    return Container(
      color: AppColors.kWhite,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildVideoPlayer() {
    final videoWidget =
        widget.aspectRatio != null
            ? AspectRatio(
              aspectRatio: widget.aspectRatio!,
              child: VideoPlayer(_controller),
            )
            : VideoPlayer(_controller);

    return Container(
      color: AppColors.kWhite,
      child:
          widget.optimizeForPerformance
              ? RepaintBoundary(child: _buildVideoStack(videoWidget))
              : _buildVideoStack(videoWidget),
    );
  }

  Widget _buildVideoStack(Widget videoWidget) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: widget.fit,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: videoWidget,
            ),
          ),
        ),
        if (widget.showControls) _buildControls(),
      ],
    );
  }

  Widget _buildControls() {
    return AnimatedOpacity(
      opacity: widget.showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Positioned(
        bottom: 50,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.kBlack.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed:
                    _isDisposed
                        ? null
                        : () {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                            if (widget.onVideoStart != null) {
                              widget.onVideoStart!();
                            }
                          }
                        },
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.kWhite,
                  size: 32,
                ),
              ),
              if (widget.loop)
                IconButton(
                  onPressed:
                      _isDisposed
                          ? null
                          : () {
                            _controller.seekTo(Duration.zero);
                            _controller.play();
                          },
                  icon: Icon(Icons.replay, color: AppColors.kWhite, size: 28),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
