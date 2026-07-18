import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';

class IntroLessonView extends StatefulWidget {
  const IntroLessonView({
    super.key,
    required this.content,
    required this.isLast,
    required this.isFirst,
  });
  final IntroLessonContent content;
  final bool isLast;
  final bool isFirst;

  @override
  State<IntroLessonView> createState() => _IntroLessonViewState();
}

class _IntroLessonViewState extends State<IntroLessonView> {
  StreamSubscription? audioSubscription;
  late AudioPlayerService audioProvider;
  late AudioPlayerService messageSoundProvider;
  StreamSubscription? messageSoundSubscription;
  bool _isAudioCompleted = false;
  bool _isMessageSoundCompleted = false;

  @override
  void initState() {
    super.initState();
    audioProvider = AudioPlayerServiceImpl();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playAudio();
    });
    messageSoundProvider = AudioPlayerServiceImpl();
  }

  Future<void> _playMessageSound() async {
    if (widget.content.messageSound != null &&
        widget.content.messageSound!.isNotEmpty) {
      await messageSoundSubscription?.cancel();
      messageSoundSubscription = messageSoundProvider.onPlayerComplete.listen((
        event,
      ) {
        log('message sound completed');
        if (!mounted) return;
        setState(() {
          _isMessageSoundCompleted = true;
        });
        _playSuccessFeedbackIfLast();
      });
      await messageSoundProvider.play(widget.content.messageSound!);
    } else {
      if (!mounted) return;
      setState(() {
        _isMessageSoundCompleted = true;
      });
      _playSuccessFeedbackIfLast();
    }
  }

  void _playSuccessFeedbackIfLast() {
    if (widget.isLast) {
      audioProvider.playAsset(Assets.confettiFeedback);
    }
  }

  void _playAudio() async {
    if (widget.content.audio != null && widget.content.audio!.isNotEmpty) {
      audioSubscription = audioProvider.onPlayerComplete.listen((event) async {
        await _playMessageSound();
        log('audio completed');
        if (!mounted) return;
        setState(() {
          _isAudioCompleted = true;
        });
      });
      await audioProvider.play(widget.content.audio!);
    } else {
      _playMessageSound();
      if (!mounted) return;
      setState(() {
        _isAudioCompleted = true;
      });
    }
  }

  @override
  void dispose() {
    audioSubscription?.cancel();
    messageSoundSubscription?.cancel();
    audioProvider.dispose();
    messageSoundProvider.dispose();
    super.dispose();
  }

  Widget _buildBackgroundImage(bool isMobile) {
    if (isMobile) {
      return widget.content.bgImageMobile == null
          ? const SizedBox.shrink()
          : Positioned.fill(
              child: CustomCachedImage(
                imageUrl: widget.content.bgImageMobile!,
                fit: BoxFit.cover,
              ),
            );
    } else {
      return widget.content.bgImageTablet == null
          ? const SizedBox.shrink()
          : Positioned.fill(
              child: CustomCachedImage(
                imageUrl: widget.content.bgImageTablet!,
                fit: BoxFit.cover,
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = PlatformUtility.isMobile(context);
    return Stack(
      children: [
        if (widget.content.bgColor != null)
          Positioned.fill(
            child: Container(color: colorFromHex(widget.content.bgColor)),
          ),
        _buildBackgroundImage(isMobile),

        if (widget.content.image != null && widget.content.image!.isNotEmpty)
          Center(
            child: SvgHelper.fromSource(
              path: widget.content.image!,
              type: SvgSourceType.network,
              width: isMobile ? size.height * 0.7 : size.height * 0.6,
              height: isMobile ? size.height * 0.7 : size.height * 0.6,
            ),
          ),
        if (_isAudioCompleted && widget.content.message != null)
          Positioned(
            top: size.height * 0.1,
            left: 0,
            right: 0,
            child: LabelDisplay(nameEn: '', nameNp: widget.content.message!),
          ),
        TopRightPositionedCloseButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        if (!widget.isLast && _isMessageSoundCompleted)
          CenterRightAlignedForwardButton(
            onTap: () {
              context.read<LessonBloc>().add(const LessonEvent.nextContent());
            },
          ),
        if (!widget.isFirst && _isMessageSoundCompleted)
          CenterLeftAlignedBackButton(
            onTap: () {
              context.read<LessonBloc>().add(
                const LessonEvent.previousContent(),
              );
            },
          ),
        if (widget.isLast && _isMessageSoundCompleted)
          Positioned.fill(
            child: IgnorePointer(
              child: LottieHelper.fromSource(
                path: Assets.confetti1,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}
