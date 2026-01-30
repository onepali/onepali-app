import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/tap_to_reveal_lesson_content_bloc/tap_to_reveal_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/info_lesson_view.dart';

class TapToRevealLessonView extends StatefulWidget {
  const TapToRevealLessonView({super.key, required this.content});

  final TapToRevealLessonContent content;

  @override
  State<TapToRevealLessonView> createState() => _TapToRevealLessonViewState();
}

class _TapToRevealLessonViewState extends State<TapToRevealLessonView> {
  AudioPlayer? _questionAudioPlayer;
  AudioPlayer? _itemAudioPlayer;
  AudioPlayer? _wrongSfxPlayer;

  @override
  void initState() {
    super.initState();
    _wrongSfxPlayer = AudioPlayer();
    context.read<TapToRevealLessonContentBloc>().add(
      TapToRevealLessonContentEvent.started(widget.content),
    );
  }

  Future<void> _playQuestionAudio(String audioUrl) async {
    try {
      await _questionAudioPlayer?.dispose();

      final audioFile = await MediaCacheManager.instance.getSingleFile(
        audioUrl,
      );
      _questionAudioPlayer = AudioPlayer();

      _questionAudioPlayer!.onPlayerComplete.listen((_) {
        if (!mounted) return;
        context.read<TapToRevealLessonContentBloc>().add(
          const TapToRevealLessonContentEvent.questionAudioCompleted(),
        );
      });

      await _questionAudioPlayer!.play(DeviceFileSource(audioFile.path));
    } catch (e) {
      log('Error playing question audio: $e');
      if (!mounted) return;
      context.read<TapToRevealLessonContentBloc>().add(
        const TapToRevealLessonContentEvent.questionAudioCompleted(),
      );
    }
  }

  Future<void> _playItemAudio(String audioUrl) async {
    try {
      await _itemAudioPlayer?.dispose();

      final audioFile = await MediaCacheManager.instance.getSingleFile(
        audioUrl,
      );
      _itemAudioPlayer = AudioPlayer();

      _itemAudioPlayer!.onPlayerComplete.listen((_) {
        if (!mounted) return;
        context.read<TapToRevealLessonContentBloc>().add(
          const TapToRevealLessonContentEvent.correctAudioCompleted(),
        );
      });

      await _itemAudioPlayer!.play(DeviceFileSource(audioFile.path));
    } catch (e) {
      log('Error playing item audio: $e');
      if (!mounted) return;
      context.read<TapToRevealLessonContentBloc>().add(
        const TapToRevealLessonContentEvent.correctAudioCompleted(),
      );
    }
  }

  @override
  void dispose() {
    _questionAudioPlayer?.dispose();
    _itemAudioPlayer?.dispose();
    _wrongSfxPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocConsumer<
      TapToRevealLessonContentBloc,
      TapToRevealLessonContentState
    >(
      listener: (context, state) async {
        final isCorrect = state.tappedItem == state.currentQuestion;
        if (!isCorrect &&
            !state.isCorrectAudioPlaying &&
            state.tappedItem != null) {
          await _wrongSfxPlayer?.play(AssetSource('audio/sfx/wrong.mp3'));
        }

        final question = state.currentQuestion?.question;
        if (state.isQuestionAudioPlaying &&
            question != null &&
            question.isNotEmpty) {
          _playQuestionAudio(question);
        }

        if (state.isCorrectAudioPlaying && state.tappedItem != null) {
          _playItemAudio(state.tappedItem!.audioItem);
        }
      },
      builder: (context, state) {
        if (state.errorMessage != null) {
          return _LessonContentError(message: state.errorMessage!);
        }

        if (state.content == null || state.selectedItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final content = state.content!;
        final bgImage = content.bgImage;

        if (state.allQuestionsCompleted) {
          return _CompletionScreen(
            onClose: () => Navigator.of(context).pop(),
            onReplay: () {
              context.read<TapToRevealLessonContentBloc>().add(
                TapToRevealLessonContentEvent.started(widget.content),
              );
            },
          );
        }

        return Stack(
          children: [
            Positioned.fill(
              child: bgImage == null || bgImage.isEmpty
                  ? Container(color: Colors.grey[100])
                  : SvgPicture.network(bgImage, fit: BoxFit.cover),
            ),
            ...content.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isTapped = state.tappedItem == item;
              final itemSize = size.width * 0.15;

              return Positioned(
                left: item.dxRatio != null
                    ? item.dxRatio!.toDouble() * size.width
                    : size.width * 0.5,
                top: item.dyRatio != null
                    ? item.dyRatio!.toDouble() * size.height
                    : size.height * 0.5,
                child: _PositionedItemCard(
                  item: item,
                  itemSize: itemSize,
                  index: index,
                  isSelected: isTapped,
                  isCorrect: isTapped && state.isCorrect,
                  isWrong: isTapped && !state.isCorrect,
                  onTap: () {
                    context.read<TapToRevealLessonContentBloc>().add(
                      TapToRevealLessonContentEvent.itemTapped(item),
                    );
                  },
                ),
              );
            }),
            if (state.currentQuestion != null)
              Positioned(
                top: size.height * 0.05,
                left: size.width * 0.5 - 40,
                child: GestureDetector(
                  onTap:
                      state.isQuestionAudioPlaying ||
                          state.isCorrectAudioPlaying
                      ? null
                      : () {
                          final question = state.currentQuestion?.question;
                          if (question != null && question.isNotEmpty) {
                            _playQuestionAudio(question);
                          }
                        },
                  child: SvgHelper.fromSource(path: Assets.sound),
                ),
              ),
            if (state.showCorrectName && state.tappedItem != null)
              Positioned(
                top: size.height * 0.05 + 50,
                right: 0,
                left: 0,
                child: _CorrectNameDisplay(
                  nameNp: state.tappedItem!.nameNp,
                  nameEn: state.tappedItem!.nameEn,
                ),
              ),
            Positioned(
              top: size.height * 0.05,
              right: size.width * 0.05,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: SvgHelper.fromSource(path: Assets.wrong),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LessonContentError extends StatelessWidget {
  const _LessonContentError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: AppStyles.text20PxMedium),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<LessonBloc>().add(const LessonEvent.nextContent());
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _CorrectNameDisplay extends StatefulWidget {
  const _CorrectNameDisplay({required this.nameNp, required this.nameEn});

  final String nameNp;
  final String nameEn;

  @override
  State<_CorrectNameDisplay> createState() => _CorrectNameDisplayState();
}

class _CorrectNameDisplayState extends State<_CorrectNameDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kSecondaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  widget.nameNp,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PositionedItemCard extends StatefulWidget {
  const _PositionedItemCard({
    required this.item,
    required this.itemSize,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  final Item item;
  final double itemSize;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  @override
  State<_PositionedItemCard> createState() => _PositionedItemCardState();
}

class _PositionedItemCardState extends State<_PositionedItemCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    final curvedAnimation = _animationController.drive(
      CurveTween(curve: Curves.easeInOut),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 40),
    ]).animate(curvedAnimation);

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(
        tween: Tween<double>(begin: 10.0, end: -10.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10.0, end: 10.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 10.0, end: -10.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10.0, end: 5.0),
        weight: 1,
      ),
      TweenSequenceItem(tween: Tween<double>(begin: 5.0, end: -5.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -5.0, end: 0.0), weight: 1),
    ]).animate(curvedAnimation);
  }

  @override
  void didUpdateWidget(_PositionedItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final turnedCorrect = !oldWidget.isCorrect && widget.isCorrect;
    final turnedWrong = !oldWidget.isWrong && widget.isWrong;

    if (turnedCorrect || turnedWrong) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final shakeValue = widget.isWrong ? _shakeAnimation.value : 0.0;
          final scaleValue = widget.isCorrect ? _scaleAnimation.value : 1.0;

          return Transform.translate(
            offset: Offset(shakeValue, 0),
            child: Transform.scale(scale: scaleValue, child: child),
          );
        },
        child: SizedBox(
          width: widget.itemSize,
          height: widget.itemSize,
          child: SvgHelper.fromSource(
            path: widget.item.image,
            width: widget.itemSize,
            height: widget.itemSize,
            fit: BoxFit.contain,
            type: SvgSourceType.network,
          ),
        ),
      ),
    );
  }
}

class _CompletionScreen extends StatelessWidget {
  const _CompletionScreen({required this.onClose, required this.onReplay});

  final VoidCallback onClose;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 120, color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              'Great Job!',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'You completed all questions!',
              style: TextStyle(fontSize: 24, color: Colors.white70),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onReplay,
                  icon: const Icon(Icons.replay),
                  label: const Text('Play Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 24),
                ElevatedButton.icon(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
