import 'package:flutter/material.dart';
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

  void _handleTap(int i, StoryProvider storyProvider) async {
    final opt = widget.content.conversation[i];
    final correct = opt.correct == true;
    setState(() {
      selectedIdx = i;
      isCorrect = correct;
      showTryAgain = !correct;
    });

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
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        storyProvider.nextContent(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
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
