import 'dart:developer';
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/speaker_icon.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_reveal/tap_to_reveal_lesson_content_bloc/tap_to_reveal_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';

class TapToRevealLessonView extends StatefulWidget {
  final TapToRevealLessonContent content;

  const TapToRevealLessonView({super.key, required this.content});

  @override
  State<TapToRevealLessonView> createState() => _TapToRevealLessonViewState();
}

class _TapToRevealLessonViewState extends State<TapToRevealLessonView> {
  AudioPlayer? _questionAudioPlayer;
  AudioPlayer? _itemAudioPlayer;
  AudioPlayer? _wrongSfxPlayer;
  bool _advancedAfterCompletion = false;
  Timer? _hintTimer;
  String? _hintQuestionKey;
  bool _showHintPulse = false;

  @override
  void initState() {
    super.initState();
    _initializeLesson();
    _wrongSfxPlayer = AudioPlayer();
  }

  Future<void> _initializeLesson() async {
    final bloc = context.read<TapToRevealLessonContentBloc>();
    bloc.add(TapToRevealLessonContentEvent.started(widget.content));
  }

  Future<void> _playQuestionAudio(String audioUrl) async {
    try {
      await _questionAudioPlayer?.dispose();

      final audioFile = await MediaCacheManager.instance.getSingleFile(
        audioUrl,
      );
      _questionAudioPlayer = AudioPlayer();

      _questionAudioPlayer!.onPlayerComplete.listen((_) {
        if (mounted) {
          context.read<TapToRevealLessonContentBloc>().add(
            const TapToRevealLessonContentEvent.questionAudioCompleted(),
          );
        }
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
        if (mounted) {
          context.read<TapToRevealLessonContentBloc>().add(
            const TapToRevealLessonContentEvent.correctAudioCompleted(),
          );
        }
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

  String _questionKey(Item? item) {
    if (item == null) return '';
    return '${item.nameEn}-${item.nameNp}';
  }

  void _cancelHintPulse() {
    _hintTimer?.cancel();
    _hintTimer = null;
    if (_showHintPulse) {
      setState(() {
        _showHintPulse = false;
      });
    }
  }

  void _scheduleHintPulse(TapToRevealLessonContentState state) {
    final currentQuestion = state.currentQuestion;
    if (currentQuestion == null || state.isAnswered || state.isCorrect) {
      _cancelHintPulse();
      return;
    }

    final nextQuestionKey = _questionKey(currentQuestion);
    if (_hintQuestionKey == nextQuestionKey && _hintTimer != null) {
      return;
    }

    _cancelHintPulse();
    _hintQuestionKey = nextQuestionKey;
    _hintTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      final latestState = context.read<TapToRevealLessonContentBloc>().state;
      final latestQuestionKey = _questionKey(latestState.currentQuestion);
      final shouldShowPulse =
          latestQuestionKey == nextQuestionKey &&
          !latestState.isAnswered &&
          latestState.tappedItem != latestState.currentQuestion;

      if (shouldShowPulse && !_showHintPulse) {
        setState(() {
          _showHintPulse = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _questionAudioPlayer?.dispose();
    _itemAudioPlayer?.dispose();
    _wrongSfxPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = PlatformUtility.isMobile(context);

    return BlocConsumer<
      TapToRevealLessonContentBloc,
      TapToRevealLessonContentState
    >(
      listener: (context, state) async {
        _scheduleHintPulse(state);
        final isCorrect = state.tappedItem == state.currentQuestion;
        if (isCorrect) {
          _cancelHintPulse();
        }
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
          final audioItem = state.tappedItem!.audioItem;
          if (audioItem != null && audioItem.isNotEmpty) {
            _playItemAudio(audioItem);
          } else {
            context.read<TapToRevealLessonContentBloc>().add(
              const TapToRevealLessonContentEvent.correctAudioCompleted(),
            );
          }
        }
      },
      builder: (context, state) {
        if (state.errorMessage != null) {
          return _LessonContentError(message: state.errorMessage!);
        }

        if (state.content == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.selectedItems.isEmpty) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<LessonBloc>().add(const LessonEvent.nextContent());
              },
              child: const Text('Next'),
            ),
          );
        }

        if (state.allQuestionsCompleted && !_advancedAfterCompletion) {
          _advancedAfterCompletion = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.read<LessonBloc>().add(const LessonEvent.nextContent());
          });
        }

        final content = state.content!;
        final selectedBgImage = isMobile
            ? content.bgImage ?? content.bgImageTb
            : content.bgImageTb ?? content.bgImage;

        return Stack(
          children: [
            Positioned.fill(
              child: selectedBgImage == null || selectedBgImage.isEmpty
                  ? Container(color: Colors.grey[100])
                  : SvgPicture.network(selectedBgImage, fit: BoxFit.cover),
            ),

            ...content.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isCurrentQuestion =
                  state.currentQuestion != null &&
                  item.nameEn == state.currentQuestion!.nameEn &&
                  item.nameNp == state.currentQuestion!.nameNp;
              final isTapped = state.tappedItem == item;
              final showHintPulse =
                  _showHintPulse && isCurrentQuestion && !state.isCorrect;

              final itemSize = size.width * 0.15;
              final dx = isMobile
                  ? item.dxRatioMobile != null
                        ? item.dxRatioMobile!.toDouble()
                        : 0.5
                  : item.dxRatio != null
                  ? item.dxRatio!.toDouble()
                  : 0.5;
              final dy = isMobile
                  ? item.dyRatioMobile != null
                        ? item.dyRatioMobile!.toDouble()
                        : 0.5
                  : item.dyRatio != null
                  ? item.dyRatio!.toDouble()
                  : 0.5;
              return Positioned(
                left: dx * size.width,
                top: dy * size.height,
                child: Transform.scale(
                  scale: isMobile
                      ? item.sizeMb.toDouble()
                      : item.sizeTb.toDouble(),
                  child: _PositionedItemCard(
                    item: item,
                    itemSize: itemSize,
                    index: index,
                    isSelected: isTapped,
                    isCorrect: isTapped && state.isCorrect,
                    isWrong: isTapped && !state.isCorrect,
                    showHintPulse: showHintPulse,
                    onTap: () async {
                      final isCorrect =
                          item.nameEn == state.currentQuestion?.nameEn &&
                          item.nameNp == state.currentQuestion?.nameNp;
                      MetricsTrackingHelper.trackAnswerAttempt(
                        context: context,
                        isCorrect: isCorrect,
                      );
                      context.read<TapToRevealLessonContentBloc>().add(
                        TapToRevealLessonContentEvent.itemTapped(item),
                      );
                    },
                  ),
                ),
              );
            }),

            if (state.currentQuestion != null)
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: SpeakerIcon(
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
                  ),
                ),
              ),

            if (state.showCorrectName && state.tappedItem != null)
              Positioned(
                top: size.height * 0.05 + 50,
                right: 0,
                left: 0,
                child: LabelDisplay(
                  nameNp: state.tappedItem!.nameNp,
                  nameEn: state.tappedItem!.nameEn,
                ),
              ),

            TopRightPositionedCloseButton(
              onTap: () {
                Navigator.of(context).pop();
              },
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

class _PositionedItemCard extends StatefulWidget {
  final Item item;
  final double itemSize;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool showHintPulse;
  final VoidCallback onTap;

  const _PositionedItemCard({
    required this.item,
    required this.itemSize,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.showHintPulse,
    required this.onTap,
  });

  @override
  State<_PositionedItemCard> createState() => _PositionedItemCardState();
}

class _PositionedItemCardState extends State<_PositionedItemCard>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _shakeAnimation;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

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

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.showHintPulse) {
      _pulseController.repeat(reverse: true);
    }
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

    if (widget.showHintPulse && !oldWidget.showHintPulse) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.showHintPulse && oldWidget.showHintPulse) {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_animationController, _pulseController]),
        builder: (context, child) {
          final double shakeValue = widget.isWrong
              ? _shakeAnimation.value
              : 0.0;
          final double correctScaleValue = widget.isCorrect
              ? _scaleAnimation.value
              : 1.0;
          final double pulseScaleValue = widget.showHintPulse
              ? _pulseAnimation.value
              : 1.0;
          final double scaleValue = correctScaleValue * pulseScaleValue;

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
