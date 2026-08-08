import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
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
  final VoidCallback? onNext;
  final VoidCallback? onLessonCompleted;

  const ChooseCorrectLessonView({
    super.key,
    required this.content,
    this.isLastContent = false,
    this.onNext,
    this.onLessonCompleted,
  });

  @override
  State<ChooseCorrectLessonView> createState() =>
      _ChooseCorrectLessonViewState();
}

class _ChooseCorrectLessonViewState extends State<ChooseCorrectLessonView>
    with AutoAdvanceMixin<ChooseCorrectLessonView> {
  static const _autoAdvanceDelay = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _initializeLesson();
  }

  Future<void> _initializeLesson() async {
    final bloc = context.read<ChooseCorrectLessonContentBloc>();
    bloc.add(ChooseCorrectLessonContentEvent.started(widget.content));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      ChooseCorrectLessonContentBloc,
      ChooseCorrectLessonContentState
    >(
      listenWhen: (previous, current) =>
          current.isCorrect &&
          previous.status != ChooseCorrectLessonContentStatus.completed &&
          current.status == ChooseCorrectLessonContentStatus.completed,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scheduleAutoAdvance(_autoAdvanceDelay, () {
            if (widget.isLastContent) {
              widget.onLessonCompleted?.call();
              return;
            }
            if (widget.onNext != null) {
              widget.onNext!.call();
            } else {
              context.read<LessonBloc>().add(const LessonEvent.nextContent());
            }
          });
        });
      },
      builder: (context, state) {
        if (state.errorMessage != null) {
          return _LessonContentError(message: state.errorMessage!);
        }

        if (state.lessonContent == null || state.currentQuestion == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final content = state.lessonContent!;
        return SizedBox.expand(
          child: Stack(
            children: [
              LessonContentFrame(
                builder: (context, constraints) {
                  final frameSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final groupWidth = frameSize.width * 0.95;
                  final cardHeight = frameSize.height * 0.6;
                  const feedbackButtonVerticalPadding = 16.0;
                  const feedbackIconSize = 32.0;
                  const feedbackButtonHeight =
                      feedbackIconSize + (feedbackButtonVerticalPadding * 2);

                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: groupWidth,
                          height: cardHeight,
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
                                      size: frameSize,
                                      itemCount: content.items.length,
                                      index: content.items.indexOf(item),
                                      availableWidth: groupWidth,
                                      isSelected: item == state.selectedItem,
                                      height: cardHeight,
                                      onTap: () {
                                        if (state.isCorrect) return;
                                        final isCorrect =
                                            item.nameEn ==
                                                state.currentQuestion?.nameEn &&
                                            item.nameNp ==
                                                state.currentQuestion?.nameNp;
                                        MetricsTrackingHelper.trackAnswerAttempt(
                                          context: context,
                                          isCorrect: isCorrect,
                                        );
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
                                  ],
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: frameSize.height * 0.04),
                        SizedBox(
                          width: frameSize.width * 0.2,
                          height: feedbackButtonHeight,
                          child: state.isAnswered
                              ? ElevatedButton(
                                  onPressed: () {
                                    if (state.isAnswered && state.isCorrect) {
                                      if (widget.onNext != null) {
                                        widget.onNext!.call();
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
                                      context
                                          .read<
                                            ChooseCorrectLessonContentBloc
                                          >()
                                          .add(
                                            const ChooseCorrectLessonContentEvent.questionAudioRequested(),
                                          );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: state.isCorrect
                                        ? AppColors.kButtonGreen
                                        : AppColors.kButtonRed,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: feedbackButtonVerticalPadding,
                                    ),
                                  ),
                                  child: state.isAnswered && !state.isCorrect
                                      ? Text(
                                          "Try again",
                                          style: AppStyles.text20PxBold
                                              .copyWith(
                                                color: AppColors.kBlack,
                                              ),
                                        )
                                      : state.isAnswered && state.isCorrect
                                      ? Icon(
                                          Icons.check,
                                          size: feedbackIconSize,
                                          color: AppColors.kBlack,
                                        )
                                      : SizedBox(),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
              CenterLeftAlignedBackButton(
                onTap: () {
                  context.read<LessonBloc>().add(
                    const LessonEvent.previousContent(),
                  );
                },
              ),
              if (!widget.isLastContent &&
                  state.status == ChooseCorrectLessonContentStatus.completed)
                CenterRightAlignedForwardButton(
                  onTap: () {
                    if (widget.onNext != null) {
                      widget.onNext!.call();
                    } else {
                      context.read<LessonBloc>().add(
                        const LessonEvent.nextContent(),
                      );
                    }
                  },
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
