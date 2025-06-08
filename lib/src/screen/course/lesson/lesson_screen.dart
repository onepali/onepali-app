import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class LessonScreen extends StatelessWidget {
  final Course chapter;
  const LessonScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: chapter.nameEn.isNotEmpty ? chapter.nameEn : chapter.nameNp,
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chapter.lessons.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, idx) {
          final lesson = chapter.lessons[idx];
          return LessonCard(
            data: lesson,
            color: Colors.teal[200]!,
            isLocked: lesson.progress == 'locked',
            isCompleted: lesson.progress == 'completed',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => LessonContentScreen(
                        lesson: lesson,
                        lessons: chapter.lessons,
                        initialIndex: 0,
                        hasSound: true,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
