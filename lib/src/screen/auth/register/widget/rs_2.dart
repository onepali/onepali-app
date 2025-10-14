import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class RS2Screen extends StatefulWidget {
  const RS2Screen({super.key});

  @override
  State<RS2Screen> createState() => _RS2ScreenState();
}

class _RS2ScreenState extends State<RS2Screen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double titleBottomGap = isTabletPortrait ? 32.0 : 24.0;
    final double cardBottomGap = isTabletPortrait ? 20.0 : 16.0;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;

    final TextStyle titleStyle = isTabletPortrait
        ? AppStyles.text24PxSemiBold
        : AppStyles.text20PxSemiBold;
    final TextStyle buttonTextStyle = isTabletPortrait
        ? AppStyles.text20PxMedium
        : AppStyles.text16PxMedium;

    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 2),
      backgroundColor: AppColors.kWhite,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16.0,
          ),
          child: _buildNextButton(
            context,
            isTabletPortrait,
            buttonTextStyle,
            buttonHeight,
            buttonRadius,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Why is your child learning Nepali?', style: titleStyle),
            Gaps.verticalGapOf(titleBottomGap),
            ...List.generate(
              AppConstants.whyLearningNepali.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == AppConstants.whyLearningNepali.length - 1
                      ? 0
                      : cardBottomGap,
                ),
                child: _buildOptionCard(
                  AppConstants.whyLearningNepali[index],
                  selectedIndex == index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  isTabletPortrait: isTabletPortrait,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    String text,
    bool isSelected, {
    required VoidCallback onTap,
    required bool isTabletPortrait,
  }) {
    final double verticalPadding = isTabletPortrait ? 20.0 : 16.0;
    final double horizontalPadding = isTabletPortrait ? 24.0 : 20.0;
    final double borderRadius = isTabletPortrait ? 12.0 : 8.0;
    final double borderWidth = isSelected
        ? (isTabletPortrait ? 3.0 : 2.0)
        : 1.0;

    final TextStyle textStyle = isTabletPortrait
        ? AppStyles.text18PxRegular
        : AppStyles.text16PxRegular;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.kButtonGreen : AppColors.kLightGrey,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          text,
          style: textStyle.copyWith(
            color: AppColors.kPitchBlack,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    bool isTabletPortrait,
    TextStyle buttonTextStyle,
    double buttonHeight,
    double buttonRadius,
  ) {
    return CustomMaterialButton(
      label: 'Next',
      onTap: () {
        if (selectedIndex == null) {
          showCustomToaster("Please select an option.", isError: true);
          return;
        }
        // Save learningReason to AuthState
        final authState = context.read<AuthState>();
        authState.setLearningReason(
          AppConstants.whyLearningNepali[selectedIndex!],
        );
        Utility.navigate(context, AppRoutes.rs3Screen);
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      textStyle: buttonTextStyle,
      height: buttonHeight,
      radius: buttonRadius,
      elevation: 0,
    );
  }
}
