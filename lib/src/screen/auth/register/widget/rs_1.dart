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
    final int crossAxisCount = 2;
    final double mainAxisSpacing = isTabletPortrait ? 20.0 : 16.0;
    final double crossAxisSpacing = isTabletPortrait ? 20.0 : 16.0;
    final double childAspectRatio = isTabletPortrait ? 1.35 : 1.1;
    const double gridVerticalInsetRatio = 0.10;
    final double buttonHeight = AuthOnboardingLayout.buttonHeight(context);
    final double buttonRadius = AuthOnboardingLayout.buttonRadius(context);

    final TextStyle titleStyle = isTabletPortrait
        ? AppStyles.text24PxSemiBold
        : AppStyles.text20PxSemiBold;
    final TextStyle buttonTextStyle = isTabletPortrait
        ? AppStyles.text20PxMedium
        : AppStyles.text16PxMedium;

    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 1),
      backgroundColor: AppColors.kWhite,
      body: AuthOnboardingLayout(
        bottomActionGap: 0,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'How did you hear about O Nepali?',
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final rowCount = (onboardList.length / crossAxisCount).ceil();
                  final totalCrossSpacing =
                      crossAxisSpacing * (crossAxisCount - 1);
                  final totalMainSpacing = mainAxisSpacing * (rowCount - 1);
                  final gridVerticalInset =
                      constraints.maxHeight * gridVerticalInsetRatio;
                  final availableGridHeight =
                      (constraints.maxHeight - (gridVerticalInset * 2))
                          .clamp(0.0, double.infinity)
                          .toDouble();
                  final maxCardWidth =
                      ((constraints.maxWidth - totalCrossSpacing)
                          .clamp(0.0, double.infinity)
                          .toDouble()) /
                      crossAxisCount;
                  final cardHeight =
                      ((availableGridHeight - totalMainSpacing)
                          .clamp(0.0, double.infinity)
                          .toDouble()) /
                      rowCount;
                  if (maxCardWidth <= 0 || cardHeight <= 0) {
                    return const SizedBox.shrink();
                  }
                  final cardWidth = (cardHeight * childAspectRatio)
                      .clamp(0.0, maxCardWidth)
                      .toDouble();
                  final layoutScale = (cardWidth / maxCardWidth)
                      .clamp(0.85, 1.0)
                      .toDouble();
                  final gridWidth =
                      (crossAxisCount * cardWidth) + totalCrossSpacing;
                  final gridHeight = (rowCount * cardHeight) + totalMainSpacing;

                  return Center(
                    child: SizedBox(
                      width: gridWidth,
                      height: gridHeight,
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: onboardList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: mainAxisSpacing,
                          crossAxisSpacing: crossAxisSpacing,
                          childAspectRatio: cardWidth / cardHeight,
                        ),
                        itemBuilder: (context, index) {
                          final option = onboardList[index];
                          final iconWidth = option.iconWidth(isTabletPortrait);
                          return _buildReferralCard(
                            option.title,
                            _selectedIndex == index,
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            icon: option.icon,
                            iconHeight:
                                option.iconHeight(isTabletPortrait) *
                                layoutScale,
                            iconWidth: iconWidth == null
                                ? null
                                : iconWidth * layoutScale,
                            isTabletPortrait: isTabletPortrait,
                            layoutScale: layoutScale,
                            color: option.color,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomAction: _buildNextButton(
          context,
          isTabletPortrait,
          buttonTextStyle,
          buttonHeight,
          buttonRadius,
        ),
      ),
    );
  }

  Widget _buildReferralCard(
    String text,
    bool isSelected, {
    required VoidCallback onTap,
    String? icon,
    required double iconHeight,
    double? iconWidth,
    required bool isTabletPortrait,
    required double layoutScale,
    Color? color,
  }) {
    final double verticalGap = (isTabletPortrait ? 16.0 : 12.0) * layoutScale;
    final double borderRadius = (isTabletPortrait ? 12.0 : 8.0) * layoutScale;
    final double borderWidth = isSelected
        ? (isTabletPortrait ? 3.0 : 2.5)
        : 1.0;
    final double cardPadding = (isTabletPortrait ? 16.0 : 12.0) * layoutScale;

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
              height: iconHeight,
              width: iconWidth,
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
