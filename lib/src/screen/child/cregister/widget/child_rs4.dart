import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class ChildRS4Screen extends StatefulWidget {
  const ChildRS4Screen({super.key});

  @override
  State<ChildRS4Screen> createState() => _ChildRS4ScreenState();
}

class _ChildRS4ScreenState extends State<ChildRS4Screen> {
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
        totalSteps: 5,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.verticalGapOf(50),

                Text('Receive updates?', style: AppStyles.text16PxRegular),
                Gaps.verticalGapOf(50),
                CustomImage(
                  Assets.notificationOn,
                  height: 230,
                  width: 230,
                  imageType: CustomImageType.local,
                  cover: false,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildNextButton(context), Gaps.verticalGapOf(30)],
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomMaterialButton(
          label: 'Turn On',
          onTap: () async {
            if (mounted) {
              AppSettings.openAppSettings(type: AppSettingsType.notification);
              Utility.navigate(context, AppRoutes.dashboardScreen);
            }
          },
          backgroundColor: AppColors.kButtonGreen,
          width: double.infinity,
          elevation: 0,
        ),
        Gaps.verticalGapOf(15),
        CustomMaterialButton(
          label: 'Not Now',
          onTap: () {
            Utility.navigate(context, AppRoutes.dashboardScreen);
          },
          backgroundColor: AppColors.kButtonGrey,
          textStyle: AppStyles.text16PxMedium.copyWith(color: AppColors.kBlack),
          width: double.infinity,
          elevation: 0,
        ),
      ],
    );
  }
}
