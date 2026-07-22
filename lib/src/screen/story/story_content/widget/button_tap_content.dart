import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';

// Button Tap UI
class ButtonTapContent extends StatefulWidget {
  final Content content;
  final bool playAudio;
  const ButtonTapContent({
    super.key,
    required this.content,
    this.playAudio = true,
  });
  @override
  State<ButtonTapContent> createState() => ButtonTapContentState();
}

class ButtonTapContentState extends State<ButtonTapContent> {
  int? selectedIdx;
  bool? isCorrect;
  bool showTryAgain = false;
  late final AudioPlayerService _optionAudioService;
  int _selectionGeneration = 0;

  @override
  void initState() {
    super.initState();
    _optionAudioService = AudioPlayerServiceImpl();
  }

  @override
  void dispose() {
    _selectionGeneration++;
    unawaited(_optionAudioService.dispose());
    super.dispose();
  }

  Future<void> _playSelectionAudio(
    Conversation option,
    StoryProvider storyProvider,
    int selectionGeneration,
    bool correct,
  ) async {
    await _optionAudioService.stop().catchError((_) {});
    await storyProvider.stopAudio();
    if (!mounted || selectionGeneration != _selectionGeneration) {
      return;
    }

    final feedbackAsset = correct ? Assets.starBlast : Assets.wrongSfx;
    final feedbackComplete = _optionAudioService.onPlayerComplete.first.timeout(
      const Duration(seconds: 3),
      onTimeout: () {},
    );

    var didStartFeedback = false;
    try {
      await _optionAudioService.playAsset(feedbackAsset);
      didStartFeedback = true;
    } catch (error) {
      logger.e('Error playing story feedback audio: $error');
    }

    if (didStartFeedback) {
      await feedbackComplete.catchError((_) {});
    }

    if (!mounted || selectionGeneration != _selectionGeneration) {
      return;
    }

    final audioItem = option.audioItem;
    if (audioItem == null || audioItem.isEmpty) {
      return;
    }

    final optionComplete = _optionAudioService.onPlayerComplete.first.timeout(
      const Duration(seconds: 5),
      onTimeout: () {},
    );
    try {
      await _optionAudioService.play(audioItem);
      await optionComplete.catchError((_) {});
    } catch (error) {
      logger.e('Error playing story option audio: $error');
    }
  }

  void _handleTap(int i, StoryProvider storyProvider) async {
    final selectionGeneration = ++_selectionGeneration;
    final opt = widget.content.conversation[i];
    final correct = opt.correct == true;
    setState(() {
      selectedIdx = i;
      isCorrect = correct;
      showTryAgain = !correct;
    });
    final selectionAudio = _playSelectionAudio(
      opt,
      storyProvider,
      selectionGeneration,
      correct,
    );

    // Track the answer for parent metrics
    if (storyProvider.currentStory != null) {
      await MetricsTrackingHelper.trackStoryAnswer(
        context: context,
        isCorrect: correct,
        storyTitle: storyProvider.currentStory!.nameNp.isNotEmpty
            ? storyProvider.currentStory!.nameNp
            : storyProvider.currentStory!.nameEn,
      );
    }

    if (correct) {
      await Future.wait([
        selectionAudio,
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
      if (mounted && selectionGeneration == _selectionGeneration) {
        storyProvider.nextContent(context);
      }
    } else {
      unawaited(selectionAudio);
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.content.conversation;
    final isMobile = PlatformUtility.isMobile(context);
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);

    return Stack(
      children: [
        // Bottom button container
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: const BoxDecoration(
              // color: AppColors.kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 120,
              children: List.generate(options.length, (i) {
                final opt = options[i];
                final correct = opt.correct == true;
                final isSelected = selectedIdx == i;
                Color bgColor = AppColors.kButtonGrey;
                String label = opt.messageEn;
                dynamic icon;
                String iconType = '';
                Color textColor = isSelected
                    ? AppColors.kWhite
                    : AppColors.kBlack;
                TextStyle? textStyle = AppStyles.text16PxBold.copyWith(
                  color: textColor,
                  fontSize:
                      PlatformUtility.isTablet(context) &&
                          PlatformUtility.isLandscape(context)
                      ? 32
                      : 16,
                );
                final buttonHeight =
                    PlatformUtility.isTablet(context) &&
                        PlatformUtility.isLandscape(context)
                    ? 60.0
                    : 48.0;
                final buttonWidth =
                    PlatformUtility.isTablet(context) &&
                        PlatformUtility.isLandscape(context)
                    ? 220.0
                    : 120.0;
                if (isSelected) {
                  if (isCorrect == true && correct) {
                    bgColor = AppColors.kButtonGreen;
                    iconType = 'svg';
                    label = '';
                    textColor = AppColors.kWhite;
                    textStyle = AppStyles.text16PxBold.copyWith(
                      color: AppColors.kWhite,
                      fontSize:
                          PlatformUtility.isTablet(context) &&
                              PlatformUtility.isLandscape(context)
                          ? 28
                          : 16,
                    );
                  } else if (isCorrect == false && !correct) {
                    bgColor = AppColors.kButtonRed;
                    label = 'Try Again';
                    textColor = AppColors.kDrawerBgColor;
                    textStyle = AppStyles.text16PxBold.copyWith(
                      color: AppColors.kDrawerBgColor,
                      fontSize:
                          PlatformUtility.isTablet(context) &&
                              PlatformUtility.isLandscape(context)
                          ? 28
                          : 16,
                    );
                  }
                }
                if (isSelected && isCorrect == true && correct) {
                  return GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,
                      child: SvgHelper.fromSource(
                        path: Assets.checkButton,
                        width: buttonWidth,
                        height: buttonHeight,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }
                return CustomMaterialButton(
                  backgroundColor: bgColor,
                  showBorder: true,
                  elevation: 0,
                  radius: 60,
                  height: buttonHeight,
                  textStyle: textStyle,
                  width: buttonWidth,
                  onTap: () {
                    if (isCorrect == true && correct) {
                      return;
                    }
                    _handleTap(i, storyProvider);
                  },
                  label: label,
                  iconType: iconType,
                  icon: icon,
                  fillButton: isSelected,
                );
              }),
            ),
          ),
        ),
        // Top center sound icon
        Positioned(
          top: isMobile ? 24 : 32,
          left: 0,
          right: 0,
          child: Center(
            child: Consumer<StoryProvider>(
              builder: (context, storyProvider, _) {
                final soundIcon = CircularButtonWidget(
                  onPressed: () {
                    logger.d(
                      '[ButtonTapContent] Sound icon tapped, isPlaying: \\${storyProvider.isPlaying}',
                    );
                    storyProvider.playAudio(widget.content.audio);
                  },
                  type: CircularButtonType.sound,
                );
                return storyProvider.isPlaying
                    ? CustomAvatarGlow(child: soundIcon)
                    : soundIcon;
              },
            ),
          ),
        ),
      ],
    );
  }
}
