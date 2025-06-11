import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

Widget buildStoryContentWidget({
  required Content content,
  VoidCallback? onConfetti,
  bool isLast = false,
}) {
  switch (content.type) {
    case 'drag_drop':
      return DragDropContent(content: content);
    case 'normal':
      return NormalContent(content: content);
    case 'slide':
      return SlideContent(content: content);
    case 'button_tap':
      return ButtonTapContent(content: content);
    case 'normal_confetti':
      return NormalConfettiContent(
        content: content,
        onConfetti: onConfetti,
        isLast: isLast,
      );
    default:
      return const SizedBox();
  }
}
