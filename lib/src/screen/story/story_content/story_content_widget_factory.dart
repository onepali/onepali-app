import 'package:flutter/material.dart';
import 'package:onepali/src/screen/story/story_content/widget/button_tap_content2.dart';
import 'package:onepali/src/screen/story/story_content/widget/choose_correct.dart';
import 'package:onepali/src/src.dart';

Widget buildStoryContentWidget({
  required Content content,
  VoidCallback? onConfetti,
  bool isLast = false,
  bool playAudio = true,
}) {
  switch (content.type) {
    case 'drag_drop':
      return DragDropContent(content: content, playAudio: playAudio);
    case 'normal':
      return NormalContent(content: content, playAudio: playAudio);
    case 'slide':
      return SlideContent(content: content, playAudio: playAudio);
    case 'button_tap':
      return ButtonTapContent(content: content, playAudio: playAudio);
    case 'normal_confetti':
      return NormalConfettiContent(
        content: content,
        onConfetti: onConfetti,
        isLast: isLast,
        playAudio: playAudio,
      );
    case "button_tap2":
      return ButtonTapContent2(content: content, playAudio: playAudio);
    case 'choose_correct':
      return ChooseCorrect(content: content,isLast: isLast,);
    default:
      return const SizedBox();
  }
}
