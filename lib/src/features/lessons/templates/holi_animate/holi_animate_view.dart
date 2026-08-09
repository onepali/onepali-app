import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/utils/auto_advance_mixin.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';

class HoliAnimateView extends StatefulWidget {
  const HoliAnimateView({
    super.key,
    required this.content,
    required this.onNext,
  });
  final HoliAnimateLessonContent content;
  final VoidCallback onNext;

  @override
  State<HoliAnimateView> createState() => _HoliAnimateViewState();
}

class _HoliAnimateViewState extends State<HoliAnimateView>
    with AutoAdvanceMixin<HoliAnimateView> {
  static const _autoAdvanceDelay = Duration(seconds: 1);

  StreamSubscription<void>? audioSubscription;
  late AudioPlayerService audioProvider;
  bool _isAudioCompleted = false;

  bool get _hasPlayableAudio =>
      widget.content.audio != null && widget.content.audio!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    audioProvider = AudioPlayerServiceImpl();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _playAudio();
    });
  }

  void _playAudio() async {
    final audio = widget.content.audio;
    if (audio == null || audio.isEmpty) {
      _markAudioCompleted();
      return;
    }

    try {
      await audioSubscription?.cancel();
      audioSubscription = audioProvider.onPlayerComplete.listen((event) async {
        await Future.delayed(const Duration(seconds: 2));
        _markAudioCompleted();
      });

      await audioProvider.play(audio);
    } catch (error, stackTrace) {
      log(
        'Failed to play Holi animation audio',
        error: error,
        stackTrace: stackTrace,
      );
      _markAudioCompleted();
    }
  }

  void _markAudioCompleted() {
    if (!mounted || _isAudioCompleted) return;
    setState(() {
      _isAudioCompleted = true;
    });
    if (_hasPlayableAudio) {
      _scheduleAutoAdvance();
    }
  }

  void _scheduleAutoAdvance() {
    scheduleAutoAdvance(_autoAdvanceDelay, widget.onNext);
  }

  @override
  void dispose() {
    audioSubscription?.cancel();
    audioProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cancelAutoAdvanceOnPointerDown(
      child: Stack(
        children: [
          Positioned.fill(
            child: BackgroundImage(
              bgImageMb: widget.content.bgImage,
              bgImageTb: widget.content.bgImageTb,
            ),
          ),
          Positioned(
                top: MediaQuery.sizeOf(context).height * 0.2,
                right: 0,
                child: CustomCachedImage(
                  imageUrl: widget.content.image,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  width: MediaQuery.sizeOf(context).width * 0.4,
                ),
              )
              .animate(
                onComplete: (controller) {
                  controller.repeat(reverse: true);
                },
              )
              .scaleXY(
                begin: 1.0,
                end: 1.12,
                duration: 900.ms,
                curve: Curves.easeInOut,
              ),
          if (_isAudioCompleted)
            CenterRightAlignedForwardButton(onTap: widget.onNext),
          if (_isAudioCompleted)
            CenterLeftAlignedBackButton(
              onTap: () => context.read<LessonBloc>().add(
                const LessonEvent.previousContent(),
              ),
            ),
          TopRightPositionedCloseButton(
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
