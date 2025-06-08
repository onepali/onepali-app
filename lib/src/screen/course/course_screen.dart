import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => CourseScreenState();
}

class CourseScreenState extends State<CourseScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<LessonProvider>().fetchCourses();
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
              return const Center(child: CircularProgressIndicator());
            } else if (lessonProvider.status == DataFetchStatus.error ||
                lessonProvider.courses.isEmpty) {
              return const Center(child: Text('No courses available'));
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
                    children: [
                      Text(
                        category.nameEn.isNotEmpty
                            ? category.nameEn
                            : category.nameNp,
                        style: AppStyles.text20PxSemiBold.copyWith(
                          color: AppColors.kBlack,
                        ),
                      ),
                      Gaps.verticalGapOf(8),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              category.chapters.map((chapter) {
                                return CourseCard(
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
                                );
                              }).toList(),
                        ),
                      ),
                      Gaps.verticalGapOf(16),
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
