import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class ChildRS3Screen extends StatefulWidget {
  const ChildRS3Screen({super.key});

  @override
  State<ChildRS3Screen> createState() => _ChildRS3ScreenState();
}

class _ChildRS3ScreenState extends State<ChildRS3Screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showStepper: true,
        currentStep: 4,
        totalSteps: 4,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Profile created!', style: AppStyles.text20PxSemiBold),
              Gaps.verticalGapOf(10),
              Text(
                'Would you like to create another child\'s profile?',
                style: AppStyles.text14PxRegular,
                textAlign: TextAlign.center,
              ),
              Gaps.verticalGapOf(50),
              SvgHelper.fromSource(
                path: Assets.childSuccessSvg,
                height: 180,
                width: 180,
              ),
              Gaps.verticalGapOf(30),
              Text(
                'You can always add it later in the settings',
                style: AppStyles.text14PxRegular,
              ),
              Gaps.verticalGapOf(30),
              _buildNextButton(context),
              Gaps.verticalGapOf(30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomMaterialButton(
            label: 'Create',
            onTap: () {
              Utility.navigate(context, AppRoutes.dashboardScreen);
            },
            backgroundColor: AppColors.kButtonGreen,
            width: double.infinity,
            elevation: 0,
          ),
        ),
        Gaps.horizontalGapOf(30),
        Expanded(
          child: CustomMaterialButton(
            label: 'Not Now',
            onTap: () {
              Utility.navigate(context, AppRoutes.dashboardScreen);
            },
            backgroundColor: AppColors.kButtonGrey,
            textStyle: AppStyles.text16PxMedium.copyWith(
              color: AppColors.kBlack,
            ),
            width: double.infinity,
            elevation: 0,
          ),
        ),
      ],
    );
  }
}
