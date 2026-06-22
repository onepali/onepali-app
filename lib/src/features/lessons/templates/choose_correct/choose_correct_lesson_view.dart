import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/templates/choose_correct/choose_correct_lesson_content_bloc/choose_correct_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/choose_correct_item.dart';

class ChooseCorrectLessonView extends StatefulWidget {
  final ChooseCorrectLessonContent content;
  final bool isLastContent;

  const ChooseCorrectLessonView({
    super.key,
    required this.content,
    this.isLastContent = false,
  });

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
    _initializeLesson();
  }

  Future<void> _initializeLesson() async {
    final bloc = context.read<ChooseCorrectLessonContentBloc>();
    bloc.add(ChooseCorrectLessonContentEvent.started(widget.content));
  }

  Future<void> _playQuestionAudio(String audioUrl) async {
    try {
      await _questionAudioPlayer?.dispose();

      final audioFile = await MediaCacheManager.instance.getSingleFile(
        audioUrl,
      );
      _questionAudioPlayer = AudioPlayer();

      _questionAudioPlayer!.onPlayerComplete.listen((_) {
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
        // Play question audio when it starts
        final question = state.currentQuestion?.question;
        if (state.isQuestionAudioPlaying &&
            question != null &&
            question.isNotEmpty) {
          _playQuestionAudio(question);
        }

        // Play correct audio when correct item is tapped
        if (state.isAudioPlaying && state.selectedItem != null) {
          final audioItem = state.selectedItem!.audioItem;
          if (audioItem != null && audioItem.isNotEmpty) {
            _playCorrectAudio(audioItem);
          } else {
            context.read<ChooseCorrectLessonContentBloc>().add(
              const ChooseCorrectLessonContentEvent.correctAudioCompleted(),
            );
          }
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CenterLeftAlignedBackButton(
                        onTap: () {
                          context.read<LessonBloc>().add(
                            const LessonEvent.previousContent(),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: size.height * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (final item in content.items)
                                  Stack(
                                    children: [
                                      ItemCard(
                                        nameEn: item.nameEn,
                                        nameNp: item.nameNp,
                                        image: item.image,
                                        isImageSvg: item.isImageSvg,
                                        bgColor: item.bgColor,
                                        isCorrect: item.isCorrect,
                                        size: size,
                                        itemCount: content.items.length,
                                        index: content.items.indexOf(item),
                                        isSelected: item == state.selectedItem,
                                        onTap: () {
                                          context
                                              .read<
                                                ChooseCorrectLessonContentBloc
                                              >()
                                              .add(
                                                ChooseCorrectLessonContentEvent.itemTapped(
                                                  item,
                                                ),
                                              );
                                        },
                                      ),
                                      // Positioned(
                                      //   bottom: -20,
                                      //   left: 0,
                                      //   right: 0,
                                      //   child: SvgHelper.fromSource(
                                      //     path: Assets.sound1,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                              ],
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
                                    if (widget.isLastContent) {
                                      Navigator.of(context).pop();
                                    } else {
                                      context.read<LessonBloc>().add(
                                        const LessonEvent.nextContent(),
                                      );
                                    }
                                  } else if (state.isAnswered &&
                                      !state.isCorrect &&
                                      state
                                              .currentQuestion
                                              ?.question
                                              ?.isNotEmpty ==
                                          true) {
                                    _playQuestionAudio(
                                      state.currentQuestion!.question!,
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
                                        "Try again",
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
                                    : SizedBox(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: widget.isLastContent
                          ? const SizedBox.shrink()
                          : CenterRightAlignedForwardButton(
                              onTap: () {
                                context.read<LessonBloc>().add(
                                  const LessonEvent.nextContent(),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              if (widget.isLastContent && state.isCorrect)
                Positioned.fill(
                  child: IgnorePointer(
                    child: LottieHelper.fromSource(
                      path: Assets.confetti1,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              TopRightPositionedCloseButton(
                onTap: () => Navigator.pop(context),
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
