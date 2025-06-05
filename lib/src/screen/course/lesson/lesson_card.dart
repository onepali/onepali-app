import 'package:flutter/material.dart';

import '../../../src.dart';

class LessonCard extends StatelessWidget {
  final String title;
  final Color color;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback? onTap;
  final Widget? trailing;

  const LessonCard({
    super.key,
    required this.title,
    required this.color,
    this.isLocked = false,
    this.isCompleted = false,
    this.onTap,
    this.trailing,
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
                alignment: Alignment.bottomCenter,
                child: Container(
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
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.kBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
