import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
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

class _ConversationViewState extends State<ConversationView>
    with AutoAdvanceMixin<ConversationView> {
  static const _autoAdvanceDelay = Duration(seconds: 1);

  final _audioPlayerService = AudioPlayerServiceImpl();
  bool _isAudioCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_playConversation());
    });
  }

  Future<void> _playConversation() async {
    final audioSources = widget.content.conversation
        .where((audio) => audio.isNotEmpty)
        .toList();
    for (final audio in audioSources) {
      final completion = _audioPlayerService.onPlayerComplete.first;
      await _audioPlayerService.play(audio);
      await completion;
      if (!mounted) return;
    }

    if (!mounted) return;
    setState(() {
      _isAudioCompleted = true;
    });

    if (audioSources.isNotEmpty) {
      _autoAdvanceAfterAudioComplete();
    }
  }

  void _autoAdvanceAfterAudioComplete() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scheduleAutoAdvance(_autoAdvanceDelay, widget.onNext);
    });
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return cancelAutoAdvanceOnPointerDown(
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomCachedImage(
              imageUrl: isMobile
                  ? widget.content.bgImageMobile ?? ''
                  : widget.content.bgImageTablet ?? '',
              fit: BoxFit.cover,
            ),
          ),
          TopRightPositionedCloseButton(
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          if (_isAudioCompleted)
            CenterLeftAlignedBackButton(
              onTap: () {
                context.read<LessonBloc>().add(LessonEvent.previousContent());
              },
            ),
          if (_isAudioCompleted)
            CenterRightAlignedForwardButton(
              onTap: () {
                widget.onNext();
              },
            ),
        ],
      ),
    );
  }
}
