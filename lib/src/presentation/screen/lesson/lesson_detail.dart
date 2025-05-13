import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class LessonDetailScreen extends StatefulWidget {
  final List<Lesson> category;
  final String subCategoryName;

  const LessonDetailScreen({
    super.key,
    required this.category,
    required this.subCategoryName,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  int? selectedIndex;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subCategoryName)),
      backgroundColor: AppColors.kBackgroundColor,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: ListView.builder(
            itemCount: widget.category.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final subcategory = widget.category[index];
              final screenHeight = MediaQuery.of(context).size.height;
              final screenWidth = MediaQuery.of(context).size.width;
              return InkWell(
                onTap: () {
                  Utility.navigateMaterialRoute(
                    context,
                    LessonPreviewScreen(
                      lesson: subcategory,
                      lessons: widget.category,
                    ),
                  );
                },
                onHighlightChanged: (value) {
                  setState(() {
                    selectedIndex = index;
                    isHovered = !isHovered;
                  });
                },
                child: Container(
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.5,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors
                            .learningColors[index %
                                AppColors.learningColors.length]
                            .withValues(alpha: 0.1),
                        AppColors.learningColors[index %
                            AppColors.learningColors.length],
                        AppColors
                            .learningColors[index %
                                AppColors.learningColors.length]
                            .withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    border:
                        selectedIndex == index
                            ? Border.all(
                              color:
                                  AppColors.learningColors[index %
                                      AppColors.learningColors.length],
                              width: 4,
                            )
                            : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImage(
                        subcategory.image,
                        height: screenHeight * 0.45,
                        width: screenWidth * 0.45,
                        borderRadius: 12,
                        boxFit: BoxFit.contain,
                        imageType: CustomImageType.local,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Text(
                          '${subcategory.nameNp} (${subcategory.nameEn})',
                          style: AppStyles.text18PxMedium,
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
    );
  }
}
