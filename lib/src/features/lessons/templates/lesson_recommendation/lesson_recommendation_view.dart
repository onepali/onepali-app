import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/pages/lesson_page.dart';

class LessonRecommendationView extends StatefulWidget {
  const LessonRecommendationView({
    super.key,
    required this.content,
    this.onLessonCompleted,
  });

  final LessonRecommendationLessonContent content;
  final VoidCallback? onLessonCompleted;

  @override
  State<LessonRecommendationView> createState() =>
      _LessonRecommendationViewState();
}

class _LessonRecommendationViewState extends State<LessonRecommendationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onLessonCompleted?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: colorFromHex(widget.content.bgColor ?? '#FFFFFF'),
          ),
        ),
        Positioned.fill(
          child: Column(
            children: [
              const Spacer(),
              Text(
                "Explore more lessons like this!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.content.lessons
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Utility.navigateMaterialRoute(
                            context,
                            LessonPage(lessonId: e['id']),
                          );
                        },
                        child: Container(
                          height: size.height * 0.5,
                          width: size.width * 0.25,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: CustomCachedImage(imageUrl: e['image']),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const Spacer(),
            ],
          ),
        ),
        TopRightPositionedCloseButton(onTap: () => Navigator.of(context).pop()),
      ],
    );
  }
}
