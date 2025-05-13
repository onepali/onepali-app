import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonProvider>().fetchLessons(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Consumer<LessonProvider>(
        builder: (context, lessonProvider, child) {
          if (lessonProvider.status == DataFetchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (lessonProvider.status == DataFetchStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Text("Error loading lessons")],
              ),
            );
          } else if (lessonProvider.status == DataFetchStatus.success) {
            if (lessonProvider.categories.isEmpty) {
              return const Center(
                child: Text(
                  "No lessons available",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              );
            }
            return ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600),

              child: ListView.builder(
                itemCount: lessonProvider.categories.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final category = lessonProvider.categories[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleActionChild(
                          title: '${category.nameNp} (${category.nameEn})',
                          titleStyle: AppStyles.text20PxSemiBold.copyWith(
                            color: AppColors.kPrimaryColor,
                            fontFamily: 'Mukta',
                          ),
                          titlePadding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 8.0,
                          ),

                          action: GestureDetector(
                            onTap: () {
                              Utility.navigateMaterialRoute(
                                context,
                                SubCategoryScreen(category: category),
                              );
                            },
                            child: Text(
                              "See All",
                              style: AppStyles.text16PxSemiBold.copyWith(
                                color: AppColors.kSecondaryColor,
                              ),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: category.subcategories.length,
                                itemBuilder: (context, subIndex) {
                                  final subCategory =
                                      category.subcategories[subIndex];
                                  return GestureDetector(
                                    onTap: () {
                                      Utility.navigateMaterialRoute(
                                        context,
                                        LessonDetailScreen(
                                          category: subCategory.lessons,
                                          subCategoryName: subCategory.nameNp,
                                          hasSound:
                                              subCategory.soundAvailable ??
                                              false,
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width /
                                              4,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                            color: AppColors
                                                .learningColors[(index +
                                                        subIndex) %
                                                    AppColors
                                                        .learningColors
                                                        .length]
                                                .withValues(alpha: 0.1),
                                            border: Border.all(
                                              color:
                                                  subCategory.progress ==
                                                          'in_progress'
                                                      ? AppColors.kOrange
                                                      : AppColors
                                                          .learningColors[(index +
                                                              subIndex) %
                                                          AppColors
                                                              .learningColors
                                                              .length],
                                              width:
                                                  subCategory.progress ==
                                                          'in_progress'
                                                      ? 2
                                                      : 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors
                                                    .learningColors[(index +
                                                            subIndex) %
                                                        AppColors
                                                            .learningColors
                                                            .length]
                                                    .withValues(alpha: 0.2),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustomImage(
                                                subCategory.image,
                                                height: 100,
                                                imageType:
                                                    CustomImageType.local,
                                                width: 100,
                                                borderRadius: 8.0,
                                                boxFit: BoxFit.contain,
                                              ),
                                              Gaps.verticalGapOf(8),
                                              Text(
                                                subCategory.nameEn,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (subCategory.progress != "")
                                          Positioned(
                                            top: 8,
                                            right: 16,
                                            child: Container(
                                              height: 24,
                                              width: 24,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    subCategory.progress ==
                                                            'completed'
                                                        ? AppColors.kGreen
                                                        : subCategory
                                                                .progress ==
                                                            'locked'
                                                        ? AppColors.kGrey
                                                        : AppColors.kOrange,
                                              ),
                                              child:
                                                  subCategory.progress ==
                                                          'in_progress'
                                                      ? Text(
                                                        '25',
                                                        style: AppStyles
                                                            .text12PxSemiBold
                                                            .copyWith(
                                                              color:
                                                                  AppColors
                                                                      .kWhite,
                                                            ),
                                                      )
                                                      : Icon(
                                                        Utility.getProgressTypeIcon(
                                                          subCategory.progress,
                                                        ),
                                                        size: 18,
                                                        color: AppColors.kWhite,
                                                      ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
