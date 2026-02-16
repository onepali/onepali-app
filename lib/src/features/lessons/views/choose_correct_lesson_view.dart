import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/choose_correct_lesson_content_bloc/choose_correct_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/info_lesson_view.dart';

class ChooseCorrectLessonView extends StatefulWidget {
  final ChooseCorrectLessonContent content;

  const ChooseCorrectLessonView({super.key, required this.content});

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
        if (state.isQuestionAudioPlaying && state.currentQuestion != null) {
          _playQuestionAudio(state.currentQuestion!.question!);
        }

        // Play correct audio when correct item is tapped
        if (state.isAudioPlaying && state.selectedItem != null) {
          _playCorrectAudio(state.selectedItem!.audioItem);
        }
      },
      builder: (context, state) {
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
                    // Left arrow
                    Expanded(
                      flex: 1,
                      // child: Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 16),
                      //     child: GestureDetector(
                      //       onTap: () async {
                      //         context.read<LessonBloc>().add(
                      //           const LessonEvent.previousContent(),
                      //         );
                      //       },
                      //       child: SvgHelper.fromSource(path: Assets.leftArrow),
                      //     ),
                      //   ),
                      // ),
                      child: CenterLeftAlignedBackButton(
                        onTap: () async {
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
                                        item: item,
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
                                    context.read<LessonBloc>().add(
                                      LessonEvent.nextContent(),
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

                    // Next button
                    Expanded(
                      flex: 1,

                      child: CenterRightAlignedForwardButton(
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
              // Close button
              TopRightPositionedCloseButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
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
    this.isCorrect = false,
  });

  final Item item;
  final bool isCorrect;
  final Size size;
  final int itemCount;
  final int index;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final cardWidth = (size.width * 0.75) / itemCount;
    final maxCardWidth = size.width * 0.25;
    final finalCardWidth = cardWidth > maxCardWidth ? maxCardWidth : cardWidth;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * 0.50,
        margin: const EdgeInsets.all(8.0),
        padding: EdgeInsets.only(bottom: 8, top: 8),
        decoration: BoxDecoration(
          color: colorFromHex(item.bgColor) ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.yellowAccent, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Nepali name at top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.nameNp,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Image in the middle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomCachedImage(
                  imageUrl: item.image,
                  width: finalCardWidth * 0.7,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // English name at bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.nameEn,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
