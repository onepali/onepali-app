import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class ConversationView extends StatefulWidget {
  const ConversationView({
    super.key,
    required this.content,
    required this.onNext,
  });
  final BallSlideLessonContent content;
  final VoidCallback onNext;

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_playConversation());
  }

  Future<void> _playConversation() async {
    for (final audioUrl in widget.content.conversation) {
      if (_disposed || audioUrl.isEmpty) continue;
      try {
        await _audioPlayerService.play(audioUrl);
        await _audioPlayerService.onPlayerComplete.first;
      } catch (error) {
        log('Error playing conversation audio: $error');
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_audioPlayerService.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return Stack(
      children: [
        Positioned.fill(
          child: CustomCachedImage(
            imageUrl: isMobile
                ? widget.content.bgImageMobile ?? ''
                : widget.content.bgImageTablet ?? '',
            fit: BoxFit.cover,
          ),
        ),

        CenterLeftAlignedBackButton(
          onTap: () {
            context.read<LessonBloc>().add(LessonEvent.previousContent());
          },
        ),
        CenterRightAlignedForwardButton(onTap: widget.onNext),
      ],
    );
  }
}
