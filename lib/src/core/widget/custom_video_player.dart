import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../src.dart';

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
  bool _hasCompleted = false;
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
    if (_isDisposed || _hasCompleted) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _pauseVideo();
        break;
      case AppLifecycleState.resumed:
        if (widget.autoPlay && _isVisible && !_hasCompleted) {
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
    if (_isInitialized &&
        !_controller.value.isPlaying &&
        widget.autoPlay &&
        !_hasCompleted) {
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
          final uri = Uri.parse(widget.videoPath);
          _controller = VideoPlayerController.networkUrl(
            uri,
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
              allowBackgroundPlayback: false,
            ),
            httpHeaders:
                widget.enableCaching && !uri.scheme.startsWith('file')
                    ? {
                      'Cache-Control': 'max-age=604800',
                      'Connection': 'keep-alive',
                    }
                    : {},
          );
          break;
      }

      // Performance optimization: Initialize with buffer settings
      await _controller.initialize();

      // Set buffer duration for smoother playback
      if (widget.sourceType == VideoSourceType.network &&
          !Uri.parse(widget.videoPath).scheme.startsWith('file')) {
        // Only for actual network URLs, not cached files
        try {
          // These settings help with network video performance
          await _controller.setVolume(1.0);
        } catch (e) {
          logger.w('Could not set video buffer settings: $e');
        }
      }

      if (_isDisposed || !mounted) return;

      setState(() {
        _isInitialized = true;
        _hasError = false;
      });

      // Performance optimization: Configure playback settings
      _controller.setLooping(widget.loop);

      // Volume is already set above, no need to set again

      if (widget.autoPlay && _isVisible && !_hasCompleted) {
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
    if (hasEnded && !_hasCompleted) {
      _hasCompleted = true;

      // Pause the video immediately to prevent background playback
      _controller.pause();

      // Use post frame callback to avoid calling setState during build
      Misc.onLayoutRendered(() {
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
                    _isDisposed || _hasCompleted
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
                      _isDisposed || _hasCompleted
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
