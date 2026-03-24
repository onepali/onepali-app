import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class ConversationView extends StatefulWidget {
  const ConversationView({super.key, required this.content});
  final BallSlideLessonContent content;

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final _audioPlayerService = AudioPlayerServiceImpl();
  bool _isAudioCompleted = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (final audio in widget.content.conversation) {
        _audioPlayerService.play(audio);
        await _audioPlayerService.onPlayerComplete.first;
      }
      setState(() {
        _isAudioCompleted = true;
      });
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
              context.read<LessonBloc>().add(LessonEvent.nextContent());
            },
          ),
      ],
    );
  }
}
