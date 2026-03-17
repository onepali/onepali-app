import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/features/lessons/pages/lesson_page.dart';
import 'package:onepali/src/features/tea_maker/pages/kitchen_page.dart';
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
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    final isMobile = PlatformUtility.isMobile(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('lesson_levels')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            padding: EdgeInsets.symmetric(horizontal: 24),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data[index]['name'] as String? ?? '',
                    style: AppStyles.text20PxSemiBold.copyWith(
                      color: AppColors.kBlack,
                      fontSize: isTabletLandscape ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: isMobile
                        ? MediaQuery.of(context).size.height * 0.45
                        : MediaQuery.of(context).size.height * 0.3,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('lessons')
                          .where('level_id', isEqualTo: data[index]['id'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!.docs
                              .where(
                                (lesson) => lesson.data()['active'] != false,
                              )
                              .toList();
                          return Row(
                            children: [
                              for (final lesson in data) ...[
                                ContentCard(
                                  nameEn: lesson['name'],
                                  nameNp: lesson['name'],
                                  image: lesson['image'],
                                  bgColor: lesson['bg_color'],
                                  onTap: () => _onTapLesson(lesson),
                                ),
                                Gaps.horizontalGapOf(16),
                              ],
                            ],
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              );
            },
          );
        }
        return SizedBox();
      },
    );
  }

  void _onTapLesson(QueryDocumentSnapshot<Map<String, dynamic>> lesson) {
    if ((lesson.data()['name'] as String?) == 'Tea making') {
      Utility.navigateMaterialRoute(context, KitchenPage());
      return;
    }
    Utility.navigateMaterialRoute(context, LessonPage(lessonId: lesson.id));
  }
}
