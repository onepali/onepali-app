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

  const ChooseCorrectLessonView({
    super.key,
    required this.content,
    required this.isLastContent,
  });

  @override
  State<ChooseCorrectLessonView> createState() =>
      _ChooseCorrectLessonViewState();
}

class _ChooseCorrectLessonViewState extends State<ChooseCorrectLessonView> {
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
    final size = MediaQuery.sizeOf(context);
    final isMobile = PlatformUtility.isMobile(context);
    return BlocConsumer<
      ChooseCorrectLessonContentBloc,
      ChooseCorrectLessonContentState
    >(
      listenWhen: (previous, current) =>
          widget.isLastContent &&
          current.isCorrect &&
          previous.status != ChooseCorrectLessonContentStatus.completed &&
          current.status == ChooseCorrectLessonContentStatus.completed,
      listener: (context, state) {
        context.read<ChooseCorrectLessonContentBloc>().add(
          const ChooseCorrectLessonContentEvent.confettiFeedback(),
        );
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
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: isMobile
                                ? size.height * 0.7
                                : size.height * 0.6,
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
                                        onTap: () async {
                                          if (state.isCorrect) return;
                                          final isRightItemSeleted =
                                              item.nameEn ==
                                                  state
                                                      .currentQuestion
                                                      ?.nameEn &&
                                              item.nameNp ==
                                                  state.currentQuestion?.nameNp;
                                          // Track the answer using PzMetricsProvider
                                          context
                                              .read<PzMetricsProvider>()
                                              .trackAnswerAttempt(
                                                isCorrect: isRightItemSeleted,
                                              );
                                          // Update the state based on the selected item
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
                          // Try again or Correct button
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
                                      return;
                                    }
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
                  ],
                ),
              ),
              // Close button
              TopRightPositionedCloseButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

              CenterLeftAlignedBackButton(
                onTap: () async {
                  context.read<LessonBloc>().add(
                    const LessonEvent.previousContent(),
                  );
                },
              ),
              if (!widget.isLastContent)
                CenterRightAlignedForwardButton(
                  onTap: () {
                    context.read<LessonBloc>().add(
                      const LessonEvent.nextContent(),
                    );
                  },
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
