import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart'; // Assuming AppColors is here

class HorizontalStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double stepIndicatorHeight;
  final double spacing;

  const HorizontalStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepIndicatorHeight = 4.0,
    this.spacing = 4.0,
  }) : assert(currentStep >= 1 && currentStep <= totalSteps);

  @override
  Widget build(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);

    // Responsive sizing for tablet
    final double responsiveStepHeight =
        isTablet ? stepIndicatorHeight + 1.0 : stepIndicatorHeight;
    final double responsiveSpacing = isTablet ? spacing + 2.0 : spacing;

    return Row(
      children: List.generate(totalSteps, (index) {
        bool isActive = index < currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index == totalSteps - 1 ? 0 : responsiveSpacing,
            ),
            height: responsiveStepHeight,
            decoration: BoxDecoration(
              color: isActive ? AppColors.kButtonGreen : AppColors.kLightGrey,
              borderRadius: BorderRadius.circular(responsiveStepHeight / 2),
            ),
          ),
        );
      }),
    );
  }
}
