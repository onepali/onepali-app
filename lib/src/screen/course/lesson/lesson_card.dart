import 'package:flutter/material.dart';

import '../../../src.dart';

class LessonCard extends StatelessWidget {
  final Lesson data;
  final Color color;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double? thumbnailHeight;
  final double? thumbnailWidth;

  const LessonCard({
    super.key,
    required this.data,
    required this.color,
    this.isLocked = false,
    this.isCompleted = false,
    this.onTap,
    this.trailing,
    this.thumbnailHeight,
    this.thumbnailWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.43,
      height: 140,
      child: GestureDetector(
        onTap: isLocked ? null : onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImage(
                      data.thumbnail,
                      width: thumbnailWidth ?? 200,
                      cover: false,
                      height: thumbnailHeight ?? 140,
                      circular: false,
                    ),
                    Gaps.verticalGapOf(20),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        data.lessonName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.kBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: trailing!,
                  ),
                ),
              if (isCompleted)
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: AppColors.kWhite,
                    radius: 14,
                    child: Icon(Icons.check, color: Colors.teal, size: 18),
                  ),
                ),
              if (isLocked)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(Icons.lock, color: Colors.black, size: 22),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
