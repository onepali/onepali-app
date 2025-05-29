import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

import '../../src.dart';
import 'bottom_sheet_manager.dart';

class YoutubeVideoWidget extends StatefulWidget {
  final String youtubeUrl;
  final String? title;
  final String? subtitle;
  final bool isLocked;
  final String? info;

  const YoutubeVideoWidget({
    super.key,
    required this.youtubeUrl,
    this.title,
    this.subtitle,
    this.isLocked = false,
    this.info,
  });

  @override
  State<YoutubeVideoWidget> createState() => _YoutubeVideoWidgetState();
}

class _YoutubeVideoWidgetState extends State<YoutubeVideoWidget> {
  late YoutubePlayerController _controller;
  bool _showInfo = false;
  bool _isLocked = false;

  @override
  void initState() {
    logger.i(
      'YoutubeVideoWidget initialized with URL: \\${widget.youtubeUrl} \\${widget.title}',
    );
    super.initState();
    _isLocked = widget.isLocked;
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.youtubeUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: false,
        enableCaption: true,
        isLive: false,
      ),
    );
    _controller.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLandscape();
    });
  }

  void _listener() {
    if (_controller.value.playerState == PlayerState.ended) {
      _setLandscape();
      Navigator.of(context).maybePop();
    }
  }

  void _showInfoBottomSheet() {
    BottomSheetManager.customBottomSheet(
      context,
      title: widget.title,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(widget.info ?? '', style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  void _setLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    _setLandscape();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('islocked: \\$_isLocked, showInfo: \\$_showInfo');
    return PopScope(
      canPop: !_isLocked,
      onPopInvokedWithResult: (didPop, result) {
        _setLandscape();
        if (didPop && result != null) {
          Navigator.of(context).maybePop(result);
        }
      },
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          onReady: () {},
          topActions: [
            IconButton(
              icon: Icon(
                _isLocked ? Icons.lock : Icons.lock_open,
                color: Colors.white,
              ),
              onPressed:
                  () => setState(() {
                    _isLocked = !_isLocked;
                    _showInfo = false;
                  }),
            ),
            if (!_isLocked && widget.info != null) ...[
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {
                  setState(() => _showInfo = !_showInfo);
                  if (!_isLocked && widget.info != null) {
                    _showInfoBottomSheet();
                  }
                },
              ),
            ],
            if (!_isLocked) ...[
              GestureDetector(
                child: const Icon(Icons.close, color: Colors.white),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ],
          bottomActions:
              _isLocked
                  ? []
                  : [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                  ],
          onEnded: (metaData) {
            _setLandscape();
            Navigator.of(context).maybePop();
          },
        ),
        builder: (context, player) {
          return player;
        },
      ),
    );
  }
}
