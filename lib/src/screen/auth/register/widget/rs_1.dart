import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class RS1Screen extends StatefulWidget {
  const RS1Screen({super.key});

  @override
  State<RS1Screen> createState() => _RS1ScreenState();
}

class _RS1ScreenState extends State<RS1Screen> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 1),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How did you hear about O Nepali?',
              style: AppStyles.text20PxSemiBold,
            ),
            Gaps.verticalGapOf(24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: List.generate(onboardList.length, (index) {
                  final option = onboardList[index];
                  return _buildReferralCard(
                    option.title,
                    _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    icon: option.icon,
                  );
                }),
              ),
            ),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCard(
    String text,
    bool isSelected, {
    required VoidCallback onTap,
    String? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.kButtonGreen : AppColors.kLightGrey,
            width: isSelected ? 2.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgHelper.fromSource(path: icon ?? Assets.leoSvg, height: 30),
            Gaps.verticalGapOf(12),
            Text(
              text,
              style: AppStyles.text14PxRegular.copyWith(
                color: AppColors.kPitchBlack,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return CustomMaterialButton(
      label: 'Next',
      onTap: () {
        if (_selectedIndex == null) {
          showCustomToaster("Please select an option.", isError: true);
          return;
        }
        // Save heardAbout to AuthState
        final authState = context.read<AuthState>();
        authState.setHeardAbout(onboardList[_selectedIndex!].title);
        Utility.navigate(context, AppRoutes.rs2Screen);
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
