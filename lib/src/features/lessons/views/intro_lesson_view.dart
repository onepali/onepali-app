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
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

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

  StreamSubscription? audioSubscription;
  late AudioPlayerService audioProvider;

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
      audioSubscription = audioProvider.onPlayerComplete.listen((event) {
        // context.read<LessonBloc>().add(LessonEvent.nextContent());
        log('audio completed');
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
        TopRightPositionedCloseButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        if (!widget.isLast)
          StreamBuilder(
            stream: audioProvider.onPlayerComplete,
            builder: (context, asyncSnapshot) {
              final isAudioCompleted = asyncSnapshot.hasData;
              log('isAudioCompleted: $isAudioCompleted');
              return CenterRightAlignedForwardButton(
                onTap: () {
                  context.read<LessonBloc>().add(const LessonEvent.nextContent());
                },
              );
            }
          ),
        if (!widget.isFirst)
          CenterLeftAlignedBackButton(
            onTap: () {
              context.read<LessonBloc>().add(
                const LessonEvent.previousContent(),
              );
            },
          ),
      ],
    );
  }
}
