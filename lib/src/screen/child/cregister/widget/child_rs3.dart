import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ChildRS3Screen extends StatefulWidget {
  const ChildRS3Screen({super.key});

  @override
  State<ChildRS3Screen> createState() => _ChildRS3ScreenState();
}

class _ChildRS3ScreenState extends State<ChildRS3Screen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() async {
      final childProvider = context.read<ChildUserProvider>();
      await childProvider.fetchChildUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final childProvider = context.watch<ChildUserProvider>();
    final int childCount = childProvider.totalChildren;

    // Platform responsive variables
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double verticalGap1 = isTabletPortrait ? 16.0 : 10.0;
    final double verticalGap2 = isTabletPortrait ? 80.0 : 50.0;
    final double verticalGap3 = isTabletPortrait ? 50.0 : 30.0;
    final double imageSize = isTabletPortrait ? 240.0 : 180.0;
    final double bottomPadding = isTabletPortrait ? 24.0 : 16.0;
    // final double buttonGap = isTabletPortrait ? 40.0 : 30.0;
    final double buttonSpacing = isTabletPortrait ? 20.0 : 15.0;

    final TextStyle titleStyle =
        isTabletPortrait
            ? AppStyles.text24PxSemiBold
            : AppStyles.text20PxSemiBold;

    final TextStyle subtitleStyle =
        isTabletPortrait
            ? AppStyles.text16PxRegular
            : AppStyles.text14PxRegular;

    final TextStyle noteStyle =
        isTabletPortrait
            ? AppStyles.text16PxRegular
            : AppStyles.text14PxRegular;

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
              children: [
                Text('Profile created!', style: titleStyle),
                Gaps.verticalGapOf(verticalGap1),
                Text(
                  'Would you like to create another child\'s profile?',
                  style: subtitleStyle,
                  textAlign: TextAlign.center,
                ),
                Gaps.verticalGapOf(verticalGap2),
                SvgHelper.fromSource(
                  path: Assets.childSuccessSvg,
                  height: imageSize,
                  width: imageSize,
                ),
                Gaps.verticalGapOf(verticalGap3),
                Text(
                  'You can always add it later in the settings',
                  style: noteStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: bottomPadding),
          child: _buildNextButton(
            context,
            childCount,
            isTabletPortrait,
            buttonSpacing,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    int childCount,
    bool isTabletPortrait,
    double buttonSpacing,
  ) {
    final TextStyle buttonTextStyle =
        isTabletPortrait ? AppStyles.text18PxMedium : AppStyles.text16PxMedium;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomMaterialButton(
          label: 'Create',
          onTap: () {
            if (childCount >= 3 && !GlobalConfig.isUserTesting) {
              DialogManager.showCustomDialog(
                context: context,
                title: 'You\'ve added 3 kids!',
                content:
                    'Want to add another to keep learning personalized? It’s just \$5 per extra child.',
                confirmButtonText: 'Add for \$5',
                onConfirm: () {},
              );
              return;
            } else {
              Utility.navigate(context, AppRoutes.childRegisterScreen);
            }
          },
          backgroundColor: AppColors.kButtonGreen,
          width: double.infinity,
          textStyle: buttonTextStyle,
          elevation: 0,
        ),
        Gaps.verticalGapOf(buttonSpacing),
        CustomMaterialButton(
          label: 'Not Now',
          onTap: () {
            Utility.navigateMaterialRoute(
              context,
              ChildRS4Screen(),
              routeName: AppRoutes.childRS4Screen,
            );
          },
          backgroundColor: AppColors.kButtonGrey,
          textStyle: buttonTextStyle.copyWith(color: AppColors.kBlack),
          width: double.infinity,
          elevation: 0,
        ),
      ],
    );
  }
}
