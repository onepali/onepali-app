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
    return Consumer<LessonProvider>(
      builder: (context, lessonProvider, child) {
        logger.d(
          'CourseScreen: status: ${lessonProvider.status}, courses: ${lessonProvider.courses.length}',
        );
        return StatusHandler(
          status: lessonProvider.status,
          hasData: lessonProvider.courses.isNotEmpty,
          errorTitle: 'No courses available',
          errorMessage: 'Please check back later for new courses.',
          checkConnectivity: false,
          onRetry: () {
            context.read<LessonProvider>().fetchCourses();
          },
          successBuilder: () {
            final courseModel = lessonProvider.courses.first;
            final categoriesWithChapters =
                courseModel.courses
                    .where((c) => c.chapters.isNotEmpty)
                    .toList();

            if (widget.isMobile) {
              return SafeArea(
                child: Scaffold(
                  body: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
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
                          Builder(
                            builder: (context) {
                              final cardWidth = AppCardResponsive.getCardWidth(
                                context,
                              );
                              final cardHeight =
                                  AppCardResponsive.getLessonCardHeight(
                                    context,
                                  );
                              final isTablet = PlatformUtility.isTablet(
                                context,
                              );
                              final isMobile = PlatformUtility.isMobile(
                                context,
                              );
                              final isLandscape = PlatformUtility.isLandscape(
                                context,
                              );
                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              final screenHeight =
                                  MediaQuery.of(context).size.height;

                              logger.d(
                                'CourseScreen Card Dimensions (Mobile Mode): cardWidth: $cardWidth, cardHeight: $cardHeight, isTablet: $isTablet, isMobile: $isMobile, isLandscape: $isLandscape, screenWidth: $screenWidth, screenHeight: $screenHeight',
                              );

                              return SizedBox(
                                height: cardHeight,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
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
                                            color: AppColors.lessonBgColor,
                                            isLocked:
                                                GuestUtil.isGuestUser() &&
                                                catIdx > 0,
                                            isCompleted: false,
                                            isGuestUser:
                                                GuestUtil.isGuestUser(),
                                            onTap: () {
                                              if (GuestUtil.isGuestUser() &&
                                                  catIdx > 0) {
                                                // Show guest account prompt for locked lessons
                                                GuestUtil.showGuestAccountPrompt(
                                                  context,
                                                );
                                              } else {
                                                Utility.navigateMaterialRoute(
                                                  context,
                                                  LessonScreen(
                                                    chapter: chapter,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      }).toList(),
                                ),
                              );
                            },
                          ),
                          // Add bottom spacing to prevent cutoff
                          if (catIdx == categoriesWithChapters.length - 1)
                            Gaps.verticalGapOf(16),
                        ],
                      );
                    },
                  ),
                ),
              );
            }

            if (categoriesWithChapters.isNotEmpty) {
              final category = categoriesWithChapters.first;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
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
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final cardWidth = AppCardResponsive.getCardWidth(
                            context,
                          );
                          final cardHeight =
                              AppCardResponsive.getLessonCardHeight(context);
                          final isTablet = PlatformUtility.isTablet(context);
                          final isMobile = PlatformUtility.isMobile(context);
                          final isLandscape = PlatformUtility.isLandscape(
                            context,
                          );
                          final screenWidth = MediaQuery.of(context).size.width;
                          final screenHeight =
                              MediaQuery.of(context).size.height;

                          logger.d(
                            'CourseScreen Card Dimensions (HomeScreen Mode): cardWidth: $cardWidth, cardHeight: $cardHeight, isTablet: $isTablet, isMobile: $isMobile, isLandscape: $isLandscape, screenWidth: $screenWidth, screenHeight: $screenHeight',
                          );

                          return ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                      color: AppColors.lessonBgColor,
                                      isLocked: category.chapters.length > 1,
                                      isCompleted: false,
                                      isGuestUser: GuestUtil.isGuestUser(),
                                      onTap: () {
                                        if (category.chapters.length > 1) {
                                          // Show guest account prompt for locked lessons
                                          GuestUtil.showGuestAccountPrompt(
                                            context,
                                          );
                                        } else {
                                          Utility.navigateMaterialRoute(
                                            context,
                                            LessonScreen(chapter: chapter),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            // Fallback
            return const SizedBox();
          },
        );
      },
    );
  }
}
