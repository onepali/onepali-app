import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/tap_to_reveal_lesson_content_bloc/tap_to_reveal_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/info_lesson_view.dart';
import 'package:onepali/src/screen/course/lesson/widget/grid_position_helper.dart';

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
      print('Error playing question audio: $e');
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
      print('Error playing item audio: $e');
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
    final isMobile = PlatformUtility.isMobile(context);

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
        if (state.isQuestionAudioPlaying && state.currentQuestion != null) {
          _playQuestionAudio(state.currentQuestion!.question!);
        }

        if (state.isCorrectAudioPlaying && state.tappedItem != null) {
          _playItemAudio(state.tappedItem!.audioItem);
        }
      },
      builder: (context, state) {
        if (state.content == null || state.selectedItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final bgImage = state.content!.bgImage;
        final content = state.content!;

        if (state.allQuestionsCompleted) {
          context.read<LessonBloc>().add(LessonEvent.nextContent());
        }

        return Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.network(bgImage ?? '', fit: BoxFit.cover),
            ),

            ...content.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isCurrentQuestion =
                  state.currentQuestion != null &&
                  item.nameEn == state.currentQuestion!.nameEn &&
                  item.nameNp == state.currentQuestion!.nameNp;
              final isTapped = state.tappedItem == item;

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
              log('dx: $dx, dy: $dy');
              return Positioned(
                left: dx * size.width,
                top: dy * size.height,
                child: _PositionedItemCard(
                  item: item,
                  itemSize: itemSize,
                  index: index,
                  isSelected: isTapped,
                  isCorrect: isTapped && state.isCorrect,
                  isWrong: isTapped && !state.isCorrect,
                  onTap: () async {
                    context.read<TapToRevealLessonContentBloc>().add(
                      TapToRevealLessonContentEvent.itemTapped(item),
                    );
                  },
                ),
              );
            }),

            if (state.currentQuestion != null)
              Positioned(
                top: isMobile ? 24 : 32,
                left: 0,
                right: 0,
                child: CircularButtonWidget(
                  type: CircularButtonType.sound,
                  onPressed:
                      state.isQuestionAudioPlaying ||
                          state.isCorrectAudioPlaying
                      ? null
                      : () {
                          if (state.currentQuestion != null) {
                            _playQuestionAudio(
                              state.currentQuestion!.question!,
                            );
                          }
                        },
                ),
              ),

            if (state.showCorrectName && state.tappedItem != null)
              Positioned(
                top: size.height * 0.05 + 50,
                right: 0,
                left: 0,
                child: CorrectNameDisplay(
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

class CorrectNameDisplay extends StatefulWidget {
  final String nameNp;
  final String nameEn;

  const CorrectNameDisplay({
    super.key,
    required this.nameNp,
    required this.nameEn,
  });

  @override
  State<CorrectNameDisplay> createState() => _CorrectNameDisplayState();
}

class _CorrectNameDisplayState extends State<CorrectNameDisplay>
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
  final Item item;
  final double itemSize;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const _PositionedItemCard({
    required this.item,
    required this.itemSize,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

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
          final double shakeValue = widget.isWrong
              ? _shakeAnimation.value
              : 0.0;
          final double scaleValue = widget.isCorrect
              ? _scaleAnimation.value
              : 1.0;

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
