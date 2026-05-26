import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/content_card.dart';
import 'package:onepali/src/features/lessons/pages/lesson_page.dart';
import 'package:onepali/src/src.dart';

class LessonCategoryPage extends StatefulWidget {
  const LessonCategoryPage({
    super.key,
    required this.categoryId,
    required this.title,
  });
  final String categoryId;
  final String title;

  @override
  State<LessonCategoryPage> createState() => _LessonCategoryPageState();
}

class _LessonCategoryPageState extends State<LessonCategoryPage> {
  List<Map<String, dynamic>> lessons = [];

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      getCompletedLessons();
    });
  }

  Future<void> getCompletedLessons() async {
    final completedLessons = await MetricsTrackingHelper.fetchCompletedContent(
      activityType: ActivityType.lesson,
    );
    if (!mounted) return;
    setState(() {
      lessons = completedLessons;
    });
  }

  Widget _buildTitleText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 36,
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
        color: AppColors.kDrawerBgColor,
      ),
    );
  }

  Stream<QuerySnapshot> getLessonsStream() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('lessons')
        .where('category_id', isEqualTo: widget.categoryId);
    if (!kDebugMode) {
      query = query.where('active', isEqualTo: true);
    }
    return query.snapshots();
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
                child: Center(child: _buildTitleText(context, widget.title)),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: getLessonsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;
                  return SafeArea(
                    right: false,
                    bottom: false,
                    top: false,
                    child: GridView.builder(
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 2.0,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                      ),
                      padding: EdgeInsets.only(right: 24, left: 24, bottom: 24),
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs;
                        final lessonId = data[index].id;
                        final isCompleted = lessons.any(
                          (lesson) => lesson['content_id'] == lessonId,
                        );
                        return ContentCard(
                          nameEn: data[index]['name'],
                          bgColor: data[index]['bg_color'],
                          nameNp: 'name_np',
                          onTap: () async {
                            await Utility.navigateMaterialRoute(
                              context,
                              LessonPage(lessonId: lessonId),
                            );
                            if (!mounted) return;
                            await getCompletedLessons();
                          },
                          image: data[index]['image'],
                          bgImage: data[index]['bg_image'],
                          isCompleted: isCompleted,
                        );
                      },
                    ),
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
