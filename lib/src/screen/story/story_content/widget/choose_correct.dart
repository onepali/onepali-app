import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/widgets/choose_correct_item.dart';
import 'package:onepali/src/provider/story/choose_correct_story_provider.dart';
import 'package:provider/provider.dart';

class ChooseCorrect extends StatefulWidget {
  const ChooseCorrect({super.key, required this.content, this.isLast = false});
  final Content content;
  final bool isLast;

  @override
  State<ChooseCorrect> createState() => _ChooseCorrectState();
}

class _ChooseCorrectState extends State<ChooseCorrect> {
  late final AudioPlayerService _completionAudioService;
  bool _hasPlayedCompletionAudio = false;

  @override
  void initState() {
    super.initState();
    _completionAudioService = AudioPlayerServiceImpl();
  }

  @override
  void dispose() {
    unawaited(_completionAudioService.dispose());
    super.dispose();
  }

  void _playCompletionAudioOnce() {
    if (_hasPlayedCompletionAudio) return;
    _hasPlayedCompletionAudio = true;
    unawaited(
      _completionAudioService.playAsset(Assets.storiesComplete).catchError((
        error,
      ) {
        logger.e('Error playing story completion audio: $error');
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.of(context).size;
    const feedbackButtonHeight = 56.0;
    return ChangeNotifierProvider<ChooseCorrectStoryProvider>(
      create: (context) =>
          ChooseCorrectStoryProvider()..setContent(widget.content),
      child: Builder(
        builder: (context) {
          return Consumer<ChooseCorrectStoryProvider>(
            builder: (context, storyProvider, _) {
              if (widget.isLast && storyProvider.isCorrectAnswerSelected) {
                _playCompletionAudioOnce();
              } else {
                _hasPlayedCompletionAudio = false;
              }

              return Stack(
                children: [
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final gap = (constraints.maxHeight * 0.04).clamp(
                          12.0,
                          28.0,
                        );
                        const itemCardVerticalMargin = 16.0;
                        final availableCardAreaHeight =
                            (constraints.maxHeight - gap - feedbackButtonHeight)
                                .clamp(0.0, constraints.maxHeight)
                                .toDouble();
                        final targetCardAreaHeight = isMobile
                            ? size.height * 0.6
                            : size.height * 0.50;
                        final cardAreaHeight = targetCardAreaHeight
                            .clamp(0.0, availableCardAreaHeight)
                            .toDouble();
                        final itemCardHeight =
                            (cardAreaHeight - itemCardVerticalMargin)
                                .clamp(0.0, cardAreaHeight)
                                .toDouble();

                        return Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: cardAreaHeight,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (final item
                                            in widget.content.conversation)
                                          ItemCard(
                                            bgImage: item.icon,
                                            nameEn: item.messageEn,
                                            nameNp: item.messageNp,
                                            bgColor: '#FFFFFF',
                                            isCorrect: item.correct,
                                            size: size,
                                            itemCount: widget
                                                .content
                                                .conversation
                                                .length,
                                            index: widget.content.conversation
                                                .indexOf(item),
                                            isSelected:
                                                storyProvider
                                                    .userSelectedConversation ==
                                                item,
                                            height: itemCardHeight,
                                            onTap: () {
                                              if (storyProvider
                                                  .isCorrectAnswerSelected) {
                                                return;
                                              }
                                              storyProvider.onTappedItem(item);
                                              MetricsTrackingHelper.trackAnswerAttempt(
                                                context: context,
                                                isCorrect: item.correct,
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: gap),
                                  // Try again or Correct button
                                  Visibility(
                                    visible:
                                        storyProvider
                                            .userSelectedConversation !=
                                        null,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: SizedBox(
                                      width: size.width * 0.2,
                                      height: feedbackButtonHeight,
                                      child: Consumer<StoryProvider>(
                                        builder: (context, provider, _) =>
                                            ElevatedButton(
                                              onPressed: () {
                                                if (!storyProvider
                                                    .isCorrectAnswerSelected) {
                                                  storyProvider
                                                      .clearSelection();
                                                  return;
                                                }
                                                if (widget.isLast) {
                                                  Navigator.of(context).pop();
                                                } else {
                                                  provider.nextContent(context);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    storyProvider
                                                        .isCorrectAnswerSelected
                                                    ? AppColors.kButtonGreen
                                                    : AppColors.kButtonRed,
                                                foregroundColor:
                                                    AppColors.kBlack,
                                                minimumSize: Size.zero,
                                                padding: EdgeInsets.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                              child:
                                                  storyProvider
                                                      .isCorrectAnswerSelected
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons.check,
                                                        size: 32,
                                                        color: AppColors.kBlack,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Try again",
                                                      style: AppStyles
                                                          .text20PxBold
                                                          .copyWith(
                                                            color: AppColors
                                                                .kBlack,
                                                          ),
                                                    ),
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (widget.isLast && storyProvider.isCorrectAnswerSelected)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: LottieHelper.fromSource(
                          path: Assets.confetti1,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  // Close button
                  Consumer<StoryProvider>(
                    builder: (context, storyProvider, _) =>
                        TopRightPositionedCloseButton(
                          onTap: () {
                            storyProvider.resetStoryProvider();
                            Navigator.of(context).pop();
                          },
                        ),
                  ),

                  if (!widget.isLast && storyProvider.isCorrectAnswerSelected)
                    Consumer<StoryProvider>(
                      builder: (context, provider, _) =>
                          CenterRightAlignedForwardButton(
                            onTap: () => provider.nextContent(context),
                          ),
                    ),
                  Consumer<StoryProvider>(
                    builder: (context, storyProvider, _) {
                      return CenterLeftAlignedBackButton(
                        onTap: () {
                          storyProvider.previousContent();
                        },
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
