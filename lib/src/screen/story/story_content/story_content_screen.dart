import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StoryContentScreen extends StatefulWidget {
  final StoryModel story;
  const StoryContentScreen({super.key, required this.story});

  @override
  State<StoryContentScreen> createState() => _StoryContentScreenState();
}

class _StoryContentScreenState extends State<StoryContentScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final contentList = widget.story.content;
    final content = contentList[_currentIndex];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StoryContentCard(
              content: content,
              isLast: _currentIndex == contentList.length - 1,
              onConfetti: () {},
            ),
          ),
        ],
      ),
    );
  }
}
