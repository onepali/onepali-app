import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class LessonDetailScreen extends StatelessWidget {
  final List<Lesson> category;
  final String subCategoryName;

  const LessonDetailScreen({
    super.key,
    required this.category,
    required this.subCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subCategoryName)),
      backgroundColor: AppColors.kBackgroundColor,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: ListView.builder(
            itemCount: category.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final subcategory = category[index];
              final screenHeight = MediaQuery.of(context).size.height;
              final screenWidth = MediaQuery.of(context).size.width;
              return Container(
                height: screenHeight * 0.15,
                width: screenWidth * 0.5,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                  color:
                      AppColors.learningColors[index %
                          AppColors.learningColors.length],
                  borderRadius: BorderRadius.circular(12.0),
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
                    Text(
                      '${subcategory.nameNp} (${subcategory.nameEn})',
                      style: AppStyles.text18PxMedium,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
