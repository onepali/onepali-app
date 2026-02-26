import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
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
    // return Consumer<LessonProvider>(
    //   builder: (context, lessonProvider, child) {
    //     logger.d(
    //       'CourseScreen: status: ${lessonProvider.status}, courses: ${lessonProvider.courses.length}',
    //     );
    //     return StatusHandler(
    //       status: lessonProvider.status,
    //       hasData: lessonProvider.courses.isNotEmpty,
    //       errorTitle: 'No courses available',
    //       errorMessage: 'Please check back later for new courses.',
    //       checkConnectivity: false,
    //       onRetry: () {
    //         context.read<LessonProvider>().fetchCourses();
    //       },
    //       successBuilder: () {
    //         final courseModel = lessonProvider.courses.first;
    //         final categoriesWithChapters =
    //             courseModel.courses
    //                 .where((c) => c.chapters.isNotEmpty)
    //                 .toList();

    //         if (widget.isMobile) {
    //           final isMobileLandscape = PlatformUtility.isMobile(context) &&
    //               PlatformUtility.isLandscape(context);
    //           return SafeArea(
    //             left: true,
    //             top: true,
    //             right: false,
    //             bottom: false,
    //             child: Scaffold(
    //               body: ListView.builder(
    //                 padding: const EdgeInsets.symmetric(
    //                   horizontal: 8,
    //                   vertical: 8,
    //                 ),
    //                 itemCount: categoriesWithChapters.length,
    //                 itemBuilder: (context, catIdx) {
    //                   final category = categoriesWithChapters[catIdx];

    //                   return Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       Padding(
    //                         padding: const EdgeInsets.only(bottom: 8, left: 8),
    //                         child: Text(
    //                           category.nameEn.isNotEmpty
    //                               ? category.nameEn
    //                               : category.nameNp,
    //                           style: AppStyles.text20PxSemiBold.copyWith(
    //                             color: AppColors.kBlack,
    //                             fontSize: isTabletLandscape ? 24 : 20,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                       ),
    //                       Gaps.verticalGapOf(8),
    //                       Builder(
    //                         builder: (context) {
    //                           final cardWidth = AppCardResponsive.getCardWidth(
    //                             context,
    //                           );
    //                           final isTablet = PlatformUtility.isTablet(
    //                             context,
    //                           );
    //                           final cardHeight =
    //                               AppCardResponsive.getDashboardCardHeight(context);
    //                           final isMobile = PlatformUtility.isMobile(
    //                             context,
    //                           );
    //                           final isLandscape = PlatformUtility.isLandscape(
    //                             context,
    //                           );
    //                           final screenWidth =
    //                               MediaQuery.of(context).size.width;
    //                           final screenHeight =
    //                               MediaQuery.of(context).size.height;

    //                           logger.d(
    //                             'CourseScreen Card Dimensions (Mobile Mode): cardWidth: $cardWidth, cardHeight: $cardHeight, isTablet: $isTablet, isMobile: $isMobile, isLandscape: $isLandscape, screenWidth: $screenWidth, screenHeight: $screenHeight',
    //                           );

    //                           return SizedBox(
    //                             height: cardHeight,
    //                             child: ListView(
    //                               scrollDirection: Axis.horizontal,
    //                               padding: const EdgeInsets.symmetric(
    //                                 horizontal: 8,
    //                               ),
    //                               children:
    //                                   category.chapters.map((chapter) {
    //                                     return SizedBox(
    //                                       width: cardWidth,
    //                                       height: cardHeight,
    //                                       child: CourseCard(
    //                                         title:
    //                                             chapter.nameEn.isNotEmpty
    //                                                 ? chapter.nameEn
    //                                                 : chapter.nameNp,
    //                                         thumbnail: chapter.thumbnail,
    //                                         color: AppColors.lessonBgColor,
    //                                         isLocked:
    //                                             GuestUtil.isGuestUser() &&
    //                                             catIdx > 0,
    //                                         isCompleted: false,
    //                                         isGuestUser:
    //                                             GuestUtil.isGuestUser(),
    //                                         onTap: () {
    //                                           if (GuestUtil.isGuestUser() &&
    //                                               catIdx > 0) {
    //                                             // Show guest account prompt for locked lessons
    //                                             GuestUtil.showGuestAccountPrompt(
    //                                               context,
    //                                             );
    //                                           } else {
    //                                             Utility.navigateMaterialRoute(
    //                                               context,
    //                                               LessonScreen(
    //                                                 chapter: chapter,
    //                                               ),
    //                                             );
    //                                           }
    //                                         },
    //                                       ),
    //                                     );
    //                                   }).toList(),
    //                             ),
    //                           );
    //                         },
    //                       ),
    //                       // Add bottom spacing to prevent cutoff
    //                       if (catIdx == categoriesWithChapters.length - 1)
    //                         Gaps.verticalGapOf(16),
    //                     ],
    //                   );
    //                 },
    //               ),
    //             ),
    //           );
    //         }

    //         if (categoriesWithChapters.isNotEmpty) {
    //           final category = categoriesWithChapters.first;
    //           return Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.only(
    //                     bottom: isTabletLandscape ? 21 : 8,
    //                     left: isTabletLandscape ? 24 : 16,
    //                   ),
    //                   child: Text(
    //                     category.nameEn.isNotEmpty
    //                         ? category.nameEn
    //                         : category.nameNp,
    //                     style: AppStyles.text20PxSemiBold.copyWith(
    //                       color: AppColors.kBlack,
    //                       fontSize: isTabletLandscape ? 24 : 20,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //                 Gaps.verticalGapOf(8),
    //                 Expanded(
    //                   child: Builder(
    //                     builder: (context) {
    //                       final cardWidth = AppCardResponsive.getCardWidth(
    //                         context,
    //                       );
    //                       final isTablet = PlatformUtility.isTablet(context);
    //                       final cardHeight =
    //                           AppCardResponsive.getDashboardCardHeight(context);
    //                       final isMobile = PlatformUtility.isMobile(context);
    //                       final isLandscape = PlatformUtility.isLandscape(
    //                         context,
    //                       );
    //                       final screenWidth = MediaQuery.of(context).size.width;
    //                       final screenHeight =
    //                           MediaQuery.of(context).size.height;

    //                       logger.d(
    //                         'CourseScreen Card Dimensions (HomeScreen Mode): cardWidth: $cardWidth, cardHeight: $cardHeight, isTablet: $isTablet, isMobile: $isMobile, isLandscape: $isLandscape, screenWidth: $screenWidth, screenHeight: $screenHeight',
    //                       );

    //                       return ListView(
    //                         scrollDirection: Axis.horizontal,
    //                         padding: const EdgeInsets.symmetric(horizontal: 8),
    //                         children:
    //                             category.chapters.map((chapter) {
    //                               return SizedBox(
    //                                 width: cardWidth,
    //                                 height: cardHeight,
    //                                 child: CourseCard(
    //                                   title:
    //                                       chapter.nameEn.isNotEmpty
    //                                           ? chapter.nameEn
    //                                           : chapter.nameNp,
    //                                   thumbnail: chapter.thumbnail,
    //                                   color: AppColors.lessonBgColor,
    //                                   isLocked: category.chapters.length > 1,
    //                                   isCompleted: false,
    //                                   isGuestUser: GuestUtil.isGuestUser(),
    //                                   onTap: () {
    //                                     if (category.chapters.length > 1) {
    //                                       // Show guest account prompt for locked lessons
    //                                       GuestUtil.showGuestAccountPrompt(
    //                                         context,
    //                                       );
    //                                     } else {
    //                                       Utility.navigateMaterialRoute(
    //                                         context,
    //                                         LessonScreen(chapter: chapter),
    //                                       );
    //                                     }
    //                                   },
    //                                 ),
    //                               );
    //                             }).toList(),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         }

    //         // Fallback
    //         return const SizedBox();
    //       },
    //     );
    //   },
    // );
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
                      stream: FirebaseFirestore.instance
                          .collection('lessons')
                          .where('level_id', isEqualTo: data[index]['id'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!.docs;
                          return Row(
                            children: [
                              for (final lesson in data)
                               ...[
                                 GestureDetector(
                                  onTap: () => _onTapLesson(lesson),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: lesson['bg_color'] != null
                                          ? colorFromHex(lesson['bg_color'])
                                          : Colors.green,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(30),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.network(lesson['image']),
                                        ),
                                        SizedBox(height: 32),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.kBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(20),

                                          ),
                                          child: Text(
                                            lesson['name'],
                                            style: AppStyles.text16PxMedium
                                                .copyWith(
                                                  fontSize: isTabletLandscape
                                                      ? 24
                                                      : 16,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Gaps.horizontalGapOf(16), 
                               ]
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

    Utility.navigateMaterialRoute(context, LessonPage(lessonId: lesson.id));
  }
}
