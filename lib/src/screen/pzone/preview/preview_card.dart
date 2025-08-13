import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../src.dart';

class PreviewCard extends StatefulWidget {
  const PreviewCard({super.key});

  @override
  State<PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<PreviewCard> {
  double _rating = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Platform responsive variables
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final bool isMobile = PlatformUtility.isMobile(context);
    final bool isMobilePortrait =
        isMobile && PlatformUtility.isPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding =
        isTabletPortrait ? 32 : (isMobilePortrait ? 20 : 80);
    final double verticalPadding = isTabletPortrait ? 24.0 : 12.0;
    final double titleGap = isTabletPortrait ? 12.0 : 8.0;
    final double subtitleGap = isTabletPortrait ? 24.0 : 18.0;
    final double ratingGap = isTabletPortrait ? 8.0 : 4.0;
    final double sectionGap = isTabletPortrait ? 32.0 : 24.0;
    final double fieldGap = isTabletPortrait ? 32.0 : 20.0;
    final double labelGap = isTabletPortrait ? 10.0 : 6.0;
    final double characterCountGap = isTabletPortrait ? 12.0 : 8.0;
    final double submitGap = isTabletPortrait ? 100.0 : 80.0;
    final double buttonSpacing = isTabletPortrait ? 20.0 : 12.0;
    final double starSize = isTabletPortrait ? 44.0 : 36.0;

    final TextStyle titleStyle =
        isTabletPortrait
            ? AppStyles.text28PxSemiBold.copyWith(color: AppColors.kBlack)
            : AppStyles.text22PxSemiBold.copyWith(color: AppColors.kBlack);

    final TextStyle subtitleStyle =
        isTabletPortrait
            ? AppStyles.text18PxRegular.copyWith(color: AppColors.kDarkGrey)
            : AppStyles.text16PxRegular.copyWith(color: AppColors.kDarkGrey);

    final TextStyle tapRateStyle =
        isTabletPortrait
            ? AppStyles.text16PxRegular.copyWith(color: AppColors.kDarkGrey)
            : AppStyles.text14PxRegular.copyWith(color: AppColors.kDarkGrey);

    final TextStyle labelStyle =
        isTabletPortrait
            ? AppStyles.text16PxMedium.copyWith(color: AppColors.kBlack)
            : AppStyles.text14PxMedium.copyWith(color: AppColors.kBlack);

    final TextStyle characterCountStyle =
        isTabletPortrait
            ? AppStyles.text14PxRegular.copyWith(color: AppColors.kGrey)
            : AppStyles.text12PxRegular.copyWith(color: AppColors.kGrey);

    final TextStyle buttonTextStyle =
        isTabletPortrait ? AppStyles.text18PxMedium : AppStyles.text16PxMedium;

    return Consumer<PzReviewProvider>(
      builder: (context, reviewProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.kWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Enjoying O Nepali',
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    Gaps.verticalGapOf(titleGap),
                    Text(
                      'Share your experience is helpful to other parents!',
                      style: subtitleStyle,
                      textAlign: TextAlign.center,
                    ),
                    Gaps.verticalGapOf(subtitleGap),
                    // Rating bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            _rating > index ? Icons.star : Icons.star_border,
                            color: AppColors.kOrange,
                            size: starSize,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    Gaps.verticalGapOf(ratingGap),
                    Text('Tap to rate', style: tapRateStyle),
                    Gaps.verticalGapOf(sectionGap),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Review title', style: labelStyle),
                    ),
                    Gaps.verticalGapOf(labelGap),
                    CustomTextField(
                      hintText: 'e.g., My kid enjoyed the app!',
                      controller: _titleController,
                      maxLines: 1,
                      paddingHorizontal: 12,
                      paddingVertical: 16,
                    ),
                    Gaps.verticalGapOf(fieldGap),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What did your child enjoy the most? (Optional)',
                        style: labelStyle,
                      ),
                    ),
                    Gaps.verticalGapOf(labelGap),
                    CustomTextField(
                      hintText: 'How has it helped your child to learn?',
                      controller: _descController,
                      maxLines: 5,
                      minLines: 3,
                      paddingHorizontal: 12,
                      paddingVertical: 16,
                      onChanged: (value) {
                        setState(() {}); // Update character count
                      },
                    ),
                    Gaps.verticalGapOf(characterCountGap),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_descController.text.length}/500 characters',
                        style: characterCountStyle,
                      ),
                    ),
                    Gaps.verticalGapOf(submitGap),
                    CustomMaterialButton(
                      label: 'Submit',
                      onTap: () => _handleSubmit(context, reviewProvider),
                      backgroundColor: AppColors.kButtonGreen,
                      elevation: 0,
                      radius: 10,
                      textStyle: buttonTextStyle,
                      isLoading: reviewProvider.isLoading,
                    ),
                    Gaps.verticalGapOf(buttonSpacing),
                    CustomMaterialButton(
                      label: 'Not now',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      backgroundColor: AppColors.kButtonGrey,
                      textStyle: buttonTextStyle,
                      elevation: 0,
                      radius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit(
    BuildContext context,
    PzReviewProvider reviewProvider,
  ) async {
    if (_rating == 0) {
      showCustomToaster('Please select a rating');
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      showCustomToaster('Please enter a review title');
      return;
    }

    try {
      await reviewProvider.submitReview(
        rating: _rating,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
      );

      if (context.mounted) {
        showCustomToaster('Thank you for your feedback!');

        Navigator.of(context).pop();
      }
    } catch (e) {
      // Error handling
      if (context.mounted) {
        showCustomToaster('Error submitting review');
      }
    }
  }
}
