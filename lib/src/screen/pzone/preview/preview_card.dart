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
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);
    double horizontalPadding = isMobilePortrait ? 20 : 80;

    return Consumer<PzReviewProvider>(
      builder: (context, reviewProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.kWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Enjoying O Nepali',
                      style: AppStyles.text22PxSemiBold.copyWith(
                        color: AppColors.kBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gaps.verticalGapOf(8),
                    Text(
                      'Share your experience is helpful to other parents!',
                      style: AppStyles.text16PxRegular.copyWith(
                        color: AppColors.kDarkGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gaps.verticalGapOf(18),
                    // Rating bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            _rating > index ? Icons.star : Icons.star_border,
                            color: AppColors.kOrange,
                            size: 36,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    Gaps.verticalGapOf(4),
                    Text(
                      'Tap to rate',
                      style: AppStyles.text14PxRegular.copyWith(
                        color: AppColors.kDarkGrey,
                      ),
                    ),
                    Gaps.verticalGapOf(24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Review title',
                        style: AppStyles.text14PxMedium.copyWith(
                          color: AppColors.kBlack,
                        ),
                      ),
                    ),
                    Gaps.verticalGapOf(6),
                    CustomTextField(
                      hintText: 'e.g., My kid enjoyed the app!',
                      controller: _titleController,
                      maxLines: 1,
                      paddingHorizontal: 12,
                      paddingVertical: 16,
                    ),
                    Gaps.verticalGapOf(20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What did your child enjoy the most? (Optional)',
                        style: AppStyles.text14PxMedium.copyWith(
                          color: AppColors.kBlack,
                        ),
                      ),
                    ),
                    Gaps.verticalGapOf(6),
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
                    Gaps.verticalGapOf(8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_descController.text.length}/500 characters',
                        style: AppStyles.text12PxRegular.copyWith(
                          color: AppColors.kGrey,
                        ),
                      ),
                    ),
                    Gaps.verticalGapOf(80),
                    CustomMaterialButton(
                      label: 'Submit',
                      onTap: () => _handleSubmit(context, reviewProvider),
                      backgroundColor: AppColors.kButtonGreen,
                      elevation: 0,
                      radius: 10,
                      isLoading: reviewProvider.isLoading,
                    ),
                    Gaps.verticalGapOf(12),
                    CustomMaterialButton(
                      label: 'Not now',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      backgroundColor: AppColors.kButtonGrey,
                      textStyle: AppStyles.text16PxMedium,
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
