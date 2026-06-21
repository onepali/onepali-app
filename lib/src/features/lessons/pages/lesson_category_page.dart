import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/features/lessons/pages/lesson_page.dart';
import 'package:onepali/src/src.dart';

class LessonCategoryPage extends StatelessWidget {
  const LessonCategoryPage({
    super.key,
    required this.categoryId,
    required this.title,
  });
  final String categoryId;
  final String title;

  Widget _buildTitleText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontFamily: GoogleFonts.luckiestGuy().fontFamily,
        fontSize: 36,
        letterSpacing: 5,
        fontWeight: FontWeight.bold,
        color: AppColors.kDrawerBgColor,
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLessonsStream() {
    return FirebaseFirestore.instance
        .collection('lessons')
        .where('category_id', isEqualTo: categoryId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: isMobile
                          ? closeBtnPositionMobile
                          : closeBtnPositionTablet,
                      bottom: isMobile
                          ? closeBtnPositionMobile
                          : closeBtnPositionTablet,
                      right: isMobile
                          ? closeBtnPositionMobile
                          : closeBtnPositionTablet,
                    ),
                    child: CustomCloseButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(child: _buildTitleText(context, title)),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: getLessonsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs
                      .where((lesson) => lesson.data()['active'] != false)
                      .toList();
                  return GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 2.0,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                    padding: const EdgeInsets.only(
                      right: 24,
                      left: 24,
                      bottom: 24,
                    ),
                    itemBuilder: (context, index) {
                      final lesson = data[index];
                      final lessonData = lesson.data();
                      return ContentCard(
                        nameEn: lessonData['name'] as String? ?? '',
                        bgColor: lessonData['bg_color'] as String?,
                        nameNp: lessonData['name_np'] as String? ?? '',
                        onTap: () {
                          Utility.navigateMaterialRoute(
                            context,
                            LessonPage(lessonId: lesson.id),
                          );
                        },
                        image: lessonData['image'] as String?,
                        bgImage: lessonData['bg_image'] as String?,
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
