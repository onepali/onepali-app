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
  final double? thumbnailHeight;
  final double? thumbnailWidth;

  const CourseCard({
    super.key,
    required this.title,
    this.thumbnail,
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (thumbnail != null)
                      CustomImage(
                        thumbnail!,
                        width: thumbnailWidth ?? 120,
                        cover: false,
                        height: thumbnailHeight ?? 100,
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
