import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/features/lessons/pages/lesson_page.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

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
    final isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('lesson_levels')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Unable to load lessons'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final levels = snapshot.data!.docs;
        return ListView.builder(
          itemCount: levels.length,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final level = levels[index].data();
            final levelId = level['id'] as String?;
            final levelName = level['name'] as String? ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  levelName,
                  style: AppStyles.text20PxSemiBold.copyWith(
                    color: AppColors.kBlack,
                    fontSize: isTabletLandscape ? 24 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('lessons')
                        .where('level_id', isEqualTo: levelId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Unable to load this level'),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final lessons = snapshot.data!.docs;
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: lessons.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 16),
                        itemBuilder: (context, lessonIndex) {
                          final lesson = lessons[lessonIndex].data();
                          final lessonId = lesson['id'] as String?;
                          final lessonName = lesson['name'] as String? ?? '';
                          final image = lesson['image'] as String? ?? '';

                          return GestureDetector(
                            onTap: lessonId == null
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LessonPage(lessonId: lessonId),
                                      ),
                                    );
                                  },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: image.isEmpty
                                        ? const SizedBox.shrink()
                                        : Image.network(image),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    lessonName,
                                    style: AppStyles.text16PxMedium.copyWith(
                                      fontSize: isTabletLandscape ? 24 : 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }
}
