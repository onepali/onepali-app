import 'package:flutter/material.dart';

import '../../src.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String? thumbnail;
  final Color color;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CourseCard({
    super.key,
    required this.title,
    this.thumbnail,
    required this.color,
    this.isLocked = false,
    this.isCompleted = false,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    logger.d(
      'CourseCard: title: $title, isLocked: $isLocked, isCompleted: $thumbnail',
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.43,
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
                child: Column(
                  children: [
                    if (thumbnail != null)
                      CustomImage(
                        thumbnail!,
                        width: 120,
                        cover: false,
                        height: 100,
                        imageType: CustomImageType.network,
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
                        title,
                        style: AppStyles.text16PxSemiBold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: AppColors.kWhite,
                    radius: 14,
                    child: Icon(
                      Icons.check,
                      color: AppColors.kButtonGreen,
                      size: 18,
                    ),
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
