import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/features/lessons/blocs/choose_correct_lesson_content_bloc/choose_correct_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/info_lesson_view.dart';

class ChooseCorrectLessonView extends StatefulWidget {
  const ChooseCorrectLessonView({super.key, required this.content});

  final ChooseCorrectLessonContent content;

  @override
  State<ChooseCorrectLessonView> createState() =>
      _ChooseCorrectLessonViewState();
}

class _ChooseCorrectLessonViewState extends State<ChooseCorrectLessonView> {
  AudioPlayer? _questionAudioPlayer;
  AudioPlayer? _correctAudioPlayer;

  @override
  void initState() {
    super.initState();
    context.read<ChooseCorrectLessonContentBloc>().add(
      ChooseCorrectLessonContentEvent.started(widget.content),
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
        context.read<ChooseCorrectLessonContentBloc>().add(
          const ChooseCorrectLessonContentEvent.questionAudioCompleted(),
        );
      });

      await _questionAudioPlayer!.play(DeviceFileSource(audioFile.path));
    } catch (e) {
      log('Error playing question audio: $e');
      if (!mounted) return;
      context.read<ChooseCorrectLessonContentBloc>().add(
        const ChooseCorrectLessonContentEvent.questionAudioCompleted(),
      );
    }
  }

  Future<void> _playCorrectAudio(String audioUrl) async {
    try {
      await _correctAudioPlayer?.dispose();

      final audioFile = await MediaCacheManager.instance.getSingleFile(
        audioUrl,
      );
      _correctAudioPlayer = AudioPlayer();

      _correctAudioPlayer!.onPlayerComplete.listen((_) {
        if (!mounted) return;
        context.read<ChooseCorrectLessonContentBloc>().add(
          const ChooseCorrectLessonContentEvent.correctAudioCompleted(),
        );
      });

      await _correctAudioPlayer!.play(DeviceFileSource(audioFile.path));
    } catch (e) {
      log('Error playing correct audio: $e');
      if (!mounted) return;
      context.read<ChooseCorrectLessonContentBloc>().add(
        const ChooseCorrectLessonContentEvent.correctAudioCompleted(),
      );
    }
  }

  @override
  void dispose() {
    _questionAudioPlayer?.dispose();
    _correctAudioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocConsumer<
      ChooseCorrectLessonContentBloc,
      ChooseCorrectLessonContentState
    >(
      listener: (context, state) {
        final question = state.currentQuestion?.question;
        if (state.isQuestionAudioPlaying &&
            question != null &&
            question.isNotEmpty) {
          _playQuestionAudio(question);
        }

        if (state.isAudioPlaying && state.selectedItem != null) {
          _playCorrectAudio(state.selectedItem!.audioItem);
        }
      },
      builder: (context, state) {
        if (state.errorMessage != null) {
          return _LessonContentError(message: state.errorMessage!);
        }

        if (state.lessonContent == null || state.currentQuestion == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final content = state.lessonContent!;
        return Center(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: content.items.length,
                            itemBuilder: (context, index) {
                              final item = content.items[index];
                              return ItemCard(
                                item: item,
                                size: size,
                                itemCount: content.items.length,
                                index: index,
                                isSelected: item == state.selectedItem,
                                onTap: () {
                                  context
                                      .read<ChooseCorrectLessonContentBloc>()
                                      .add(
                                        ChooseCorrectLessonContentEvent.itemTapped(
                                          item,
                                        ),
                                      );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.04),
                        Visibility(
                          visible: state.isAnswered,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: SizedBox(
                            width: size.width * 0.2,
                            child: ElevatedButton(
                              onPressed: () {
                                if (state.isAnswered && state.isCorrect) {
                                  context.read<LessonBloc>().add(
                                    const LessonEvent.nextContent(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: state.isCorrect
                                    ? AppColors.kButtonGreen
                                    : AppColors.kButtonRed,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: state.isAnswered && !state.isCorrect
                                  ? Text(
                                      'Try again',
                                      style: AppStyles.text20PxBold.copyWith(
                                        color: AppColors.kBlack,
                                      ),
                                    )
                                  : state.isAnswered && state.isCorrect
                                  ? Icon(
                                      Icons.check,
                                      size: 32,
                                      color: AppColors.kBlack,
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.05,
                right: size.width * 0.05,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgHelper.fromSource(path: Assets.wrong),
                ),
              ),
            ],
          ),
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

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.size,
    required this.itemCount,
    required this.index,
    this.isSelected = false,
    this.onTap,
  });

  final Item item;
  final Size size;
  final int itemCount;
  final int index;
  final bool isSelected;
  final VoidCallback? onTap;

  Color _getCardColor() {
    final colors = [
      Colors.orange.shade300,
      Colors.green.shade700,
      Colors.blue.shade400,
      Colors.purple.shade400,
      Colors.red.shade400,
      Colors.teal.shade400,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = (size.width * 0.75) / itemCount;
    final maxCardWidth = size.width * 0.25;
    final finalCardWidth = cardWidth > maxCardWidth ? maxCardWidth : cardWidth;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: finalCardWidth,
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.015),
        child: Container(
          decoration: BoxDecoration(
            color: _getCardColor(),
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(color: Colors.yellowAccent, width: 4)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  item.nameNp,
                  style: TextStyle(
                    fontSize: finalCardWidth * 0.12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomCachedImage(
                    imageUrl: item.image,
                    width: finalCardWidth * 0.7,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  item.nameEn,
                  style: TextStyle(
                    fontSize: finalCardWidth * 0.1,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
