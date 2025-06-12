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
                  final isMobile = widget.isMobile;
                  final isTablet = PlatformUtility.isTablet(context);
                  final isWeb = PlatformUtility.isWeb(context);
                  final isLandscape = PlatformUtility.isLandscape(context);
                  double cardWidth;
                  double listHeight;
                  if (isWeb) {
                    cardWidth = 400;
                    listHeight = 320;
                  } else if (isTablet) {
                    cardWidth = isLandscape ? 350 : 300;
                    listHeight = isLandscape ? 260 : 350;
                  } else {
                    cardWidth = isLandscape ? 320 : 260;
                    listHeight = isLandscape ? 220 : 320;
                  }
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
                        height: listHeight,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              category.chapters.map((chapter) {
                                return SizedBox(
                                  width: cardWidth,
                                  child: CourseCard(
                                    title:
                                        chapter.nameEn.isNotEmpty
                                            ? chapter.nameEn
                                            : chapter.nameNp,
                                    thumbnail: chapter.thumbnail,
                                    color: Colors.orange[200]!,
                                    isLocked: false,
                                    isCompleted: false,
                                    thumbnailHeight: isMobile ? 100.0 : 180.0,
                                    thumbnailWidth: isMobile ? 120.0 : 200.0,
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
