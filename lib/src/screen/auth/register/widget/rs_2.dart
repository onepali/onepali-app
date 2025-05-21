import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class RS2Screen extends StatefulWidget {
  const RS2Screen({super.key});

  @override
  State<RS2Screen> createState() => _RS2ScreenState();
}

class _RS2ScreenState extends State<RS2Screen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 2),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why is your child learning Nepali?',
              style: AppStyles.text20PxSemiBold,
            ),
            SizedBox(height: 24),
            ...List.generate(
              AppConstants.whyLearningNepali.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom:
                      index == AppConstants.whyLearningNepali.length - 1
                          ? 0
                          : 16,
                ),
                child: _buildOptionCard(
                  AppConstants.whyLearningNepali[index],
                  selectedIndex == index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
            Spacer(),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    String text,
    bool isSelected, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.kButtonGreen : AppColors.kLightGrey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: AppStyles.text16PxRegular.copyWith(
            color: AppColors.kPitchBlack,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return CustomMaterialButton(
      label: 'Next',
      onTap: () {
        Utility.navigateMaterialRoute(context, RS3Screen());
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
    );
  }
}
