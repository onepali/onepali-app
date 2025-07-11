import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class CourseScreen extends StatefulWidget {
  final bool isMobile;
  const CourseScreen({super.key, this.isMobile = true});

  @override
  State<CourseScreen> createState() => CourseScreenState();
}

class CourseScreenState extends State<CourseScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<LessonProvider>().fetchCourses();
      context.read<RecommendedLessonProvider>().fetchRecommendedLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<LessonProvider>(
          builder: (context, lessonProvider, child) {
            logger.d(
              'CourseScreen: status: ${lessonProvider.status}, courses: ${lessonProvider.courses.length}',
            );
            if (lessonProvider.status == DataFetchStatus.loading) {
              return CustomLoader();
            } else if (lessonProvider.status == DataFetchStatus.error ||
                lessonProvider.courses.isEmpty) {
              return ErrorScreen(
                title: 'No Courses Available',
                message: 'Please check back later for new courses.',
                onRetry: () {
                  context.read<LessonProvider>().fetchCourses();
                },
              );
            } else {
              final courseModel = lessonProvider.courses.first;
              final categoriesWithChapters =
                  courseModel.courses
                      .where((c) => c.chapters.isNotEmpty)
                      .toList();

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: categoriesWithChapters.length,
                itemBuilder: (context, catIdx) {
                  final category = categoriesWithChapters[catIdx];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 8),
                        child: Text(
                          category.nameEn.isNotEmpty
                              ? category.nameEn
                              : category.nameNp,
                          style: AppStyles.text20PxSemiBold.copyWith(
                            color: AppColors.kBlack,
                          ),
                        ),
                      ),
                      Gaps.verticalGapOf(8),
                      SizedBox(
                        height: AppCardResponsive.getCardHeight(context),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          children:
                              category.chapters.map((chapter) {
                                return SizedBox(
                                  width: AppCardResponsive.getCardWidth(
                                    context,
                                  ),
                                  child: CourseCard(
                                    title:
                                        chapter.nameEn.isNotEmpty
                                            ? chapter.nameEn
                                            : chapter.nameNp,
                                    thumbnail: chapter.thumbnail,
                                    color: Colors.orange[200]!,
                                    isLocked: false,
                                    isCompleted: false,
                                    onTap: () {
                                      Utility.navigateMaterialRoute(
                                        context,
                                        LessonScreen(chapter: chapter),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
