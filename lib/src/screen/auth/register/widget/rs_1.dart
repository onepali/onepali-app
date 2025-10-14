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
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double titleBottomGap = isTabletPortrait ? 32.0 : 24.0;
    final int crossAxisCount = isTabletPortrait ? 3 : 2;
    final double mainAxisSpacing = isTabletPortrait ? 20.0 : 16.0;
    final double crossAxisSpacing = isTabletPortrait ? 20.0 : 16.0;
    final double childAspectRatio = isTabletPortrait ? 1.3 : 1.2;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;

    final TextStyle titleStyle = isTabletPortrait
        ? AppStyles.text24PxSemiBold
        : AppStyles.text20PxSemiBold;
    final TextStyle buttonTextStyle = isTabletPortrait
        ? AppStyles.text20PxMedium
        : AppStyles.text16PxMedium;

    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 1),
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
            Text('How did you hear about O Nepali?', style: titleStyle),
            Gaps.verticalGapOf(titleBottomGap),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                childAspectRatio: childAspectRatio,
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
                    isTabletPortrait: isTabletPortrait,
                    color: option.color,
                  );
                }),
              ),
            ),
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
    required bool isTabletPortrait,
    Color? color,
  }) {
    final double iconSize = isTabletPortrait ? 40.0 : 30.0;
    final double verticalGap = isTabletPortrait ? 16.0 : 12.0;
    final double borderRadius = isTabletPortrait ? 12.0 : 8.0;
    final double borderWidth = isSelected
        ? (isTabletPortrait ? 3.0 : 2.5)
        : 1.0;
    final double cardPadding = isTabletPortrait ? 16.0 : 12.0;

    final TextStyle textStyle = isTabletPortrait
        ? AppStyles.text16PxRegular
        : AppStyles.text14PxRegular;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.kButtonGreen : AppColors.kLightGrey,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgHelper.fromSource(
              path: icon ?? Assets.leoSvg,
              height: iconSize,
              color: color,
            ),
            Gaps.verticalGapOf(verticalGap),
            Text(
              text,
              style: textStyle.copyWith(color: AppColors.kPitchBlack),
              textAlign: TextAlign.center,
            ),
          ],
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
      textStyle: buttonTextStyle,
      height: buttonHeight,
      radius: buttonRadius,
      elevation: 0,
    );
  }
}
