import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/widgets/choose_correct_item.dart';
import 'package:onepali/src/provider/story/choose_correct_story_provider.dart';
import 'package:provider/provider.dart';

class ChooseCorrect extends StatelessWidget {
  const ChooseCorrect({super.key, required this.content, this.isLast = false});
  final Content content;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<ChooseCorrectStoryProvider>(
      create: (context) => ChooseCorrectStoryProvider()..setContent(content),
      child: Builder(
        builder: (context) {
          return Consumer<ChooseCorrectStoryProvider>(
            builder: (context, storyProvider, _) {
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
                                    for (final item in content.conversation)
                                      ItemCard(
                                        bgImage: item.icon,
                                        nameEn: item.messageEn,
                                        nameNp: item.messageNp,
                                        bgColor: '#FFFFFF',
                                        isCorrect: item.correct,
                                        size: size,
                                        itemCount: content.conversation.length,
                                        index: content.conversation.indexOf(
                                          item,
                                        ),
                                        isSelected:
                                            storyProvider
                                                .userSelectedConversation ==
                                            item,
                                        onTap: () {
                                          if (storyProvider
                                              .isCorrectAnswerSelected) {
                                            return;
                                          }
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
                                          onPressed:
                                              storyProvider
                                                  .isCorrectAnswerSelected
                                              ? null
                                              : storyProvider.resetSelection,
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                storyProvider
                                                    .isCorrectAnswerSelected
                                                ? AppColors.kButtonGreen
                                                : AppColors.kButtonRed,
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
                  if (isLast && storyProvider.isCorrectAnswerSelected)
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

                  if (!isLast && storyProvider.isCorrectAnswerSelected)
                    CenterRightAlignedForwardButton(
                      onTap: () {
                        context.read<StoryProvider>().nextContent(context);
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
