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
    // Platform responsive variables
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double verticalGap1 = isTabletPortrait ? 80.0 : 50.0;
    final double verticalGap2 = isTabletPortrait ? 80.0 : 50.0;
    final double imageSize = isTabletPortrait ? 300.0 : 230.0;
    final double bottomPadding = isTabletPortrait ? 24.0 : 16.0;
    // final double buttonGap = isTabletPortrait ? 40.0 : 30.0;
    final double buttonSpacing = isTabletPortrait ? 20.0 : 15.0;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;

    final TextStyle titleStyle =
        isTabletPortrait
            ? AppStyles.text18PxRegular
            : AppStyles.text16PxRegular;

    final TextStyle buttonTextStyle =
        isTabletPortrait ? AppStyles.text18PxMedium : AppStyles.text16PxMedium;

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showStepper: true,
        currentStep: 4,
        totalSteps: 5,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.verticalGapOf(verticalGap1),
                Text('Receive updates?', style: titleStyle),
                Gaps.verticalGapOf(verticalGap2),
                CustomImage(
                  Assets.notificationOn,
                  height: imageSize,
                  width: imageSize,
                  imageType: CustomImageType.local,
                  cover: false,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNextButton(
                context,
                isTabletPortrait,
                buttonSpacing,
                buttonTextStyle,
                buttonHeight,
                buttonRadius,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    bool isTabletPortrait,
    double buttonSpacing,
    TextStyle buttonTextStyle,
    double buttonHeight,
    double buttonRadius,
  ) {
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
          textStyle: buttonTextStyle,
          height: buttonHeight,
          radius: buttonRadius,
          elevation: 0,
        ),
        Gaps.verticalGapOf(buttonSpacing),
        CustomMaterialButton(
          label: 'Not Now',
          onTap: () {
            Utility.navigate(context, AppRoutes.dashboardScreen);
          },
          backgroundColor: AppColors.kButtonGrey,
          textStyle: buttonTextStyle.copyWith(color: AppColors.kBlack),
          width: double.infinity,
          height: buttonHeight,
          radius: buttonRadius,
          elevation: 0,
        ),
      ],
    );
  }
}
