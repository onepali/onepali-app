import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';

// Button Tap UI
class ButtonTapContent extends StatefulWidget {
  final Content content;
  const ButtonTapContent({super.key, required this.content});
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
    if (correct) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        storyProvider.nextContent(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.content.conversation;
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    void playAudio() {
      final audio = widget.content.audio;
      storyProvider.playAudio(audio);
    }

    return Stack(
      children: [
        // Main content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.content.image.isNotEmpty)
              Expanded(
                child: CustomImage(
                  widget.content.image,
                  imageType: CustomImageType.network,
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: const BoxDecoration(color: Colors.white),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 30,
                children: List.generate(options.length, (i) {
                  final opt = options[i];
                  final correct = opt.correct == true;
                  final isSelected = selectedIdx == i;
                  Color bgColor = AppColors.kButtonGrey;
                  String label = opt.messageEn;
                  dynamic icon;
                  Color textColor = isSelected ? Colors.white : Colors.black;
                  TextStyle? textStyle = AppStyles.text16PxBold.copyWith(
                    color: textColor,
                  );
                  if (isSelected) {
                    if (isCorrect == true && correct) {
                      bgColor = AppColors.kButtonGreen;
                      icon = Icons.check;
                      label = '';
                      textColor = Colors.white;
                      textStyle = AppStyles.text16PxBold.copyWith(
                        color: Colors.white,
                      );
                    } else if (isCorrect == false && !correct) {
                      bgColor = AppColors.kRed;
                      label = 'Try Again';
                      textColor = Colors.white;
                      textStyle = AppStyles.text16PxBold.copyWith(
                        color: Colors.white,
                      );
                    }
                  }
                  return CustomMaterialButton(
                    backgroundColor: bgColor,
                    showBorder: true,
                    elevation: 0,
                    radius: 60,
                    textStyle: textStyle,
                    width: 120,
                    onTap: () {
                      if (isCorrect == true && correct) {
                        return;
                      }
                      _handleTap(i, storyProvider);
                    },
                    label: label,
                    icon: icon,
                    fillButton: isSelected,
                  );
                }),
              ),
            ),
          ],
        ),
        // Top center sound icon
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: playAudio,
              child: SvgHelper.fromSource(path: Assets.sound, height: 40),
            ),
          ),
        ),
      ],
    );
  }
}
