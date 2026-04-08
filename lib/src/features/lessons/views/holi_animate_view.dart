import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';

class HoliAnimateView extends StatefulWidget {
  const HoliAnimateView({super.key, required this.content});
  final HoliAnimateLessonContent content;

  @override
  State<HoliAnimateView> createState() => _HoliAnimateViewState();
}

class _HoliAnimateViewState extends State<HoliAnimateView> {
  StreamSubscription? audioSubscription;
  late AudioPlayerService audioProvider;
  bool _isAudioCompleted = false;

  @override
  void initState() {
    super.initState();
    audioProvider = AudioPlayerServiceImpl();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playAudio();
    });
  }

  void _playAudio() async {
    if (widget.content.audio != null && widget.content.audio!.isNotEmpty) {
      await audioProvider.play(widget.content.audio!);
      audioSubscription = audioProvider.onPlayerComplete.listen((event) async {
        log('audio completed');
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _isAudioCompleted = true;
        });
      });
    } else {
      setState(() {
        _isAudioCompleted = true;
      });
    }
  }

  @override
  void dispose() {
    audioProvider.dispose();
    audioSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          CenterRightAlignedForwardButton(
            onTap: () =>
                context.read<LessonBloc>().add(const LessonEvent.nextContent()),
          ),
        if (_isAudioCompleted)
          CenterLeftAlignedBackButton(
            onTap: () => context.read<LessonBloc>().add(
              const LessonEvent.previousContent(),
            ),
          ),
        TopRightPositionedCloseButton(onTap: () => Navigator.of(context).pop()),
      ],
    );
  }
}
