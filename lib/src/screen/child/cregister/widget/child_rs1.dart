import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ChildRS1Screen extends StatefulWidget {
  final bool isUpdate;
  const ChildRS1Screen({super.key, this.isUpdate = false});

  @override
  State<ChildRS1Screen> createState() => _ChildRS1ScreenState();
}

class _ChildRS1ScreenState extends State<ChildRS1Screen> {
  int? _selectedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthState>();
    final isUpdate = widget.isUpdate;

    // Platform responsive variables
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final bool isMobile = PlatformUtility.isMobile(context);
    final bool isMobilePortrait =
        isMobile && PlatformUtility.isPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double titleBottomGap = isTabletPortrait ? 40.0 : 30.0;
    final double gridHeight =
        MediaQuery.of(context).size.height * (isTabletPortrait ? 0.65 : 0.6);
    final int crossAxisCount =
        isTabletPortrait ? 4 : (isMobilePortrait ? 3 : 5);
    final double mainAxisSpacing = isTabletPortrait ? 20.0 : 16.0;
    final double crossAxisSpacing = isTabletPortrait ? 20.0 : 16.0;
    final double avatarSize = isTabletPortrait ? 150.0 : 80.0;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;
    final double avatarBorderSize = isTabletPortrait ? 3.5 : 2.5;

    final TextStyle titleStyle =
        isTabletPortrait
            ? AppStyles.text24PxSemiBold
            : AppStyles.text20PxSemiBold;
    final TextStyle buttonTextStyle =
        isTabletPortrait ? AppStyles.text18PxMedium : AppStyles.text16PxMedium;

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showStepper: true,
        currentStep: 2,
        totalSteps: 5,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Let ${authState.childName} choose the character',
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
              Gaps.verticalGapOf(titleBottomGap),
              SizedBox(
                height: gridHeight,
                child: GridView.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: mainAxisSpacing,
                  controller: _scrollController,
                  crossAxisSpacing: crossAxisSpacing,
                  childAspectRatio: 3 / 3,
                  children: List.generate(AppConstants.avatarList.length, (
                    index,
                  ) {
                    return _buildReferralCard(
                      AppConstants.avatarList[index],
                      _selectedIndex == index,
                      avatarSize,
                      avatarBorderSize,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: _buildNextButton(
          context,
          isUpdate,
          isTabletPortrait,
          buttonTextStyle,
          buttonHeight,
          buttonRadius,
        ),
      ),
    );
  }

  Widget _buildReferralCard(
    String icon,
    bool isSelected,
    double avatarSize,
    double avatarBorderSize, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.kButtonGreen : AppColors.kLightGrey,
            width: isSelected ? avatarBorderSize : 1,
          ),
          shape: BoxShape.circle,
        ),
        child: CustomImage(
          icon,
          height: avatarSize,
          width: avatarSize,
          cover: false,
          imageType: CustomImageType.local,
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    bool isUpdate,
    bool isTabletPortrait,
    TextStyle buttonTextStyle,
    double buttonHeight,
    double buttonRadius,
  ) {
    return CustomMaterialButton(
      label: isUpdate ? 'Save' : 'Next',
      onTap: () {
        if (_selectedIndex == null) {
          showCustomToaster("Please select an option.", isError: true);
          return;
        }
        if (isUpdate) {
        } else {
          Utility.navigateMaterialRoute(
            context,
            ChildRS2Screen(),
            routeName: AppRoutes.childRS2Screen,
          );
        }
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
