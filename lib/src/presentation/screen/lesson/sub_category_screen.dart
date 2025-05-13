import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class SubCategoryScreen extends StatefulWidget {
  final Category category;

  const SubCategoryScreen({super.key, required this.category});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final subcategories = widget.category.subcategories.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category.nameNp} (${widget.category.nameEn})',
          style: AppStyles.text20PxSemiBold,
        ),
      ),
      body: ListView.builder(
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final subCategory = subcategories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            child: TitleActionChild(
              title: '${subCategory.nameNp} (${subCategory.nameEn})',
              titleStyle: AppStyles.text20PxSemiBold.copyWith(
                color: AppColors.kPrimaryColor,
                fontFamily: 'Mukta',
              ),
              titlePadding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        (subCategory.lessons.length > 5
                            ? 5
                            : subCategory.lessons.length) +
                        1,
                    itemBuilder: (context, lessonIndex) {
                      if (lessonIndex == 0) {
                        return Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomAvatarGlow(
                                  glowRadiusFactor: 0.2,
                                  glowColor: AppColors.kSecondaryColor,
                                  child: Icon(
                                    Icons.play_circle_filled_outlined,
                                    size: 60,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                ),
                                Gaps.verticalGapOf(12),
                                CustomMaterialButton(
                                  label: "Start Lesson",
                                  radius: 60.0,
                                  width: 120,
                                  height: 35,
                                  elevation: 0,
                                  textStyle: AppStyles.text12PxSemiBold
                                      .copyWith(color: AppColors.kWhite),
                                  onTap: () {
                                    context
                                        .read<LessonAudioProvider>()
                                        .resetIndex(index);

                                    Utility.navigateMaterialRoute(
                                      context,
                                      LessonPreviewScreen(
                                        lesson: subCategory.lessons[0],
                                        lessons: subCategory.lessons,
                                        hasSound:
                                            subCategory.soundAvailable ?? false,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                          ],
                        );
                      }

                      // Render the remaining lessons
                      final lesson = subCategory.lessons[lessonIndex - 1];
                      return Container(
                        width: MediaQuery.of(context).size.width / 4,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors
                              .learningColors[(index + lessonIndex) %
                                  AppColors.learningColors.length]
                              .withValues(alpha: 0.1),
                          border: Border.all(
                            color:
                                AppColors.learningColors[(index + lessonIndex) %
                                    AppColors.learningColors.length],
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors
                                  .learningColors[(index + lessonIndex) %
                                      AppColors.learningColors.length]
                                  .withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomImage(
                              lesson.image,
                              height: 80,
                              imageType: CustomImageType.local,
                              width: 80,
                              borderRadius: 8.0,
                              boxFit: BoxFit.contain,
                            ),
                            Gaps.verticalGapOf(8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Text(
                                '${lesson.nameNp} (${lesson.nameEn})',
                                textAlign: TextAlign.center,
                                style: AppStyles.text12PxSemiBold.copyWith(
                                  fontFamily: 'Mukta',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
