import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/features/lessons/pages/lesson_category_page.dart';
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
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getLessonsStream(
    String levelId,
  ) {
    return FirebaseFirestore.instance
        .collection('lesson_levels')
        .doc(levelId)
        .collection('categories')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    final isMobile = PlatformUtility.isMobile(context);
    return SafeArea(
      child: StreamBuilder(
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
                      data[index]['name'],
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
                        stream: _getLessonsStream(data[index]['id']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data!.docs
                                .where(
                                  (lesson) =>
                                      kDebugMode ||
                                      lesson.data()['active'] != false,
                                )
                                .toList();
                            return Row(
                              children: [
                                for (final lesson in data) ...[
                                  ContentCard(
                                    nameEn:
                                        lesson.data()['name'] as String? ?? '',
                                    nameNp:
                                        lesson.data()['name'] as String? ?? '',
                                    image: lesson.data()['image'] as String?,
                                    bgImage:
                                        lesson.data()['bg_image'] as String?,
                                    bgColor:
                                        lesson.data()['bg_color'] as String?,
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
      ),
    );
  }

  void _onTapLesson(QueryDocumentSnapshot<Map<String, dynamic>> lesson) {
    Utility.navigateMaterialRoute(
      context,
      LessonCategoryPage(categoryId: lesson.id, title: lesson['name']),
    );
  }
}
