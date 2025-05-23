import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ChildRS1Screen extends StatefulWidget {
  const ChildRS1Screen({super.key});

  @override
  State<ChildRS1Screen> createState() => _ChildRS1ScreenState();
}

class _ChildRS1ScreenState extends State<ChildRS1Screen> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthState>();

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showStepper: true,
        currentStep: 2,
        totalSteps: 4,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let ${authState.childName} choose \nthe character',
              style: AppStyles.text20PxSemiBold,
            ),
            Gaps.verticalGapOf(24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: List.generate(AppConstants.avatarList.length, (
                  index,
                ) {
                  return _buildReferralCard(
                    AppConstants.avatarList[index],
                    _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      authState.setChildAvatar(
                        AppConstants.avatarList[_selectedIndex!],
                      );
                    },
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
    String icon,
    bool isSelected, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.kButtonGreen : AppColors.kLightGrey,
            width: isSelected ? 2.5 : 1,
          ),
          shape: BoxShape.circle,
        ),
        child: CustomImage(
          icon,
          height: 75,
          width: 75,
          imageType: CustomImageType.local,
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
        Utility.navigateMaterialRoute(context, ChildRS2Screen());
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
