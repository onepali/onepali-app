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
      backgroundColor: AppColors.kWhite ,
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
                        Text(
                          '${category.nameNp} (${category.nameEn})',
                          style: AppStyles.text16PxSemiBold,
                        ),
                        const SizedBox(height: 8.0),
                        Container(
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
                                        subCategoryName:
                                            "${subCategory.nameNp} (${subCategory.nameEn})",
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: AppColors
                                          .learningColors[(index + subIndex) %
                                              AppColors.learningColors.length]
                                          .withValues(alpha: 0.1),
                                      border: Border.all(
                                        color:
                                            AppColors.learningColors[(index +
                                                    subIndex) %
                                                AppColors
                                                    .learningColors
                                                    .length],
                                        width: 2,
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
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomImage(
                                          subCategory.image,
                                          height: 90,
                                          imageType: CustomImageType.local,
                                          width: double.infinity,
                                          borderRadius: 8.0,
                                          boxFit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 8),
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
                                );
                              },
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
