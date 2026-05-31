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
  late AudioPlayerService _audioPlayerService;
  bool _hasPlayedLastCorrectAudio = false;
  @override
  void initState() {
    super.initState();
    _audioPlayerService = AudioPlayerServiceImpl();
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<ChooseCorrectStoryProvider>(
      create: (context) =>
          ChooseCorrectStoryProvider()..setContent(widget.content),
      child: Builder(
        builder: (context) {
          return Consumer<ChooseCorrectStoryProvider>(
            builder: (context, storyProvider, _) {
              final shouldPlayLastSuccessAudio =
                  widget.isLast && storyProvider.isCorrectAnswerSelected;
              if (shouldPlayLastSuccessAudio && !_hasPlayedLastCorrectAudio) {
                _hasPlayedLastCorrectAudio = true;
                _audioPlayerService.playAsset(Assets.storiesComplete);
              } else if (!shouldPlayLastSuccessAudio) {
                _hasPlayedLastCorrectAudio = false;
              }

              return Stack(
                children: [
                  Positioned.fill(
                    child: Row(
                      children: [
                        // Left arrow
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
                                    for (final item
                                        in widget.content.conversation)
                                      ItemCard(
                                        bgImage: item.icon,
                                        nameEn: item.messageEn,
                                        nameNp: item.messageNp,
                                        bgColor: '#FFFFFF',
                                        isCorrect: item.correct,
                                        size: size,
                                        itemCount:
                                            widget.content.conversation.length,
                                        index: widget.content.conversation
                                            .indexOf(item),
                                        isSelected:
                                            storyProvider
                                                .userSelectedConversation ==
                                            item,
                                        onTap: () {
                                          if (storyProvider
                                              .isCorrectAnswerSelected) {
                                            return;
                                          }
                                          // Track the answer using PzMetricsProvider
                                          context
                                              .read<PzMetricsProvider>()
                                              .trackAnswer1(
                                                isCorrect: item.correct,
                                              );
                                          // Update the state based on the selected item
                                          storyProvider.onTappedItem(item);
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.height * 0.04),
                              // Try again or Correct button
                              Visibility(
                                visible:
                                    storyProvider.userSelectedConversation !=
                                    null,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: SizedBox(
                                  width: size.width * 0.2,
                                  child: Consumer<StoryProvider>(
                                    builder: (context, provider, _) =>
                                        ElevatedButton(
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            disabledBackgroundColor:
                                                storyProvider
                                                    .isCorrectAnswerSelected
                                                ? AppColors.kButtonGreen
                                                : AppColors.kButtonRed,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                          ),
                                          child:
                                              storyProvider
                                                  .isCorrectAnswerSelected
                                              ? Icon(
                                                  Icons.check,
                                                  size: 32,
                                                  color: AppColors.kBlack,
                                                )
                                              : Text(
                                                  "Try again",
                                                  style: AppStyles.text20PxBold
                                                      .copyWith(
                                                        color: AppColors.kBlack,
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

                  if (!widget.isLast)
                    CenterRightAlignedForwardButton(
                      onTap: () {
                        // storyProvider.nextContent(context);
                      },
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
