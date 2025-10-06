import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class ExtendTimeScreen extends StatefulWidget {
  final String? childId;
  const ExtendTimeScreen({super.key, this.childId});

  @override
  State<ExtendTimeScreen> createState() => _ExtendTimeScreenState();
}

class _ExtendTimeScreenState extends State<ExtendTimeScreen> {
  String? selectedTime;
  bool isLoading = false;
  bool _isProcessing = false;

  void _selectTime(String timeOption) {
    if (_isProcessing) return;

    setState(() {
      selectedTime = timeOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final bool isTabletLandScape = isTablet && isLandscape;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive values
    final double horizontalPadding = isTablet
        ? (isLandscape ? 60.0 : 40.0)
        : (isMobile ? 24.0 : 32.0);
    final double verticalPadding = isTablet
        ? (isLandscape ? 40.0 : 24.0)
        : (isMobile ? 24.0 : 32.0);

    final double lottieSize = isTablet
        ? (isLandscape ? 120.0 : 100.0)
        : (isLandscape ? 80.0 : 85.0);

    final double titleFontSize = isTablet
        ? (isLandscape ? 24.0 : 22.0)
        : (isLandscape ? 18.0 : 20.0);

    final int crossAxisCount = isTablet
        ? (isLandscape ? 4 : 2)
        : (isLandscape ? 4 : 2);

    final double childAspectRatio = isTablet
        ? (isLandscape ? 2.5 : 2.8)
        : (isLandscape ? 2.8 : 3.2);

    final double gridSpacing = isTablet ? 32.0 : 24.0;

    final double buttonGap = isTabletLandScape ? 40.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: availableHeight,
                    maxWidth: isTablet && isLandscape
                        ? constraints.maxWidth * 0.8
                        : constraints.maxWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding,
                        ),
                        child: Text(
                          'Choose extra time for this session',
                          style: AppStyles.text20PxSemiBold.copyWith(
                            color: AppColors.kBlack,
                            fontSize: titleFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Gaps.verticalGapOf(isTablet ? 30 : 20),

                      LottieHelper.fromSource(
                        path: Assets.alarmExtendLottie,
                        height: lottieSize,
                        width: lottieSize,
                        repeat: true,
                      ),

                      Gaps.verticalGapOf(isTablet ? 40 : 30),

                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isTablet
                              ? (isLandscape
                                    ? screenWidth * 0.6
                                    : screenWidth * 0.8)
                              : screenWidth,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: gridSpacing,
                          mainAxisSpacing: gridSpacing,
                          children: AppConstants.extendTimeMap.keys.map((
                            timeOption,
                          ) {
                            final isSelected = selectedTime == timeOption;
                            return GestureDetector(
                              key: ValueKey('time_option_$timeOption'),
                              onTap: () => _selectTime(timeOption),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.kButtonGreen
                                        : AppColors.kLightGrey,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? AppColors.kButtonGreen.withValues(
                                          alpha: 0.1,
                                        )
                                      : AppColors.kWhite,
                                ),
                                child: Center(
                                  child: Text(
                                    timeOption,
                                    style: AppStyles.text16PxMedium.copyWith(
                                      color: isSelected
                                          ? AppColors.kButtonGreen
                                          : AppColors.kBlack,
                                      fontSize: isTablet
                                          ? 16.0
                                          : (isLandscape ? 14.0 : 16.0),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      Gaps.verticalGapOf(isTabletLandScape ? 50 : 30),

                      // Buttons section
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isTablet
                              ? (isLandscape
                                    ? screenWidth * 0.5
                                    : screenWidth * 0.8)
                              : screenWidth,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomMaterialButton(
                                key: const ValueKey('cancel_button_row'),
                                fillButton: false,
                                label: 'Cancel',
                                elevation: 0,
                                backgroundColor: AppColors.kButtonGrey,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Gaps.horizontalGapOf(buttonGap),
                            Expanded(
                              child: CustomMaterialButton(
                                label: 'Extend time',
                                backgroundColor: AppColors.kButtonGreen,
                                elevation: 0,
                                isLoading: isLoading,
                                onTap: _onExtendTime,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onExtendTime() async {
    if (isLoading || _isProcessing) return;

    if (selectedTime == null) {
      showCustomToaster('Please select a time option first', isError: true);
      return;
    }

    setState(() {
      isLoading = true;
      _isProcessing = true;
    });

    try {
      final extendMinutes = AppConstants.extendTimeMap[selectedTime]!;
      final childUserProvider = context.read<ChildUserProvider>();
      final screenTimeService = ScreenTimeService.instance;

      String? targetChildUid = widget.childId;
      bool isCurrentChild = false;

      // Get current child only once
      final currentChild = await childUserProvider.getCurrentChild();

      if (targetChildUid == null) {
        if (currentChild == null) {
          throw Exception('No current child found');
        }
        targetChildUid = currentChild.uid;
        isCurrentChild = true;
      } else {
        isCurrentChild = currentChild?.uid == targetChildUid;
      }

      logger.i('Extending time for child: $targetChildUid by $selectedTime');

      if (isCurrentChild) {
        await Future.wait([
          childUserProvider.extendScreenTime(
            childUid: targetChildUid,
            additionalMinutes: extendMinutes.toDouble(),
          ),
          screenTimeService.extendTime(extendMinutes.toDouble()),
        ]);
        logger.i('Updated both Firebase and local screen time service');
      } else {
        await childUserProvider.extendScreenTime(
          childUid: targetChildUid,
          additionalMinutes: extendMinutes.toDouble(),
        );
      }

      if (mounted) {
        showCustomToaster('Screen time extended by $extendMinutes minutes');

        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.dashboardScreen, (route) => false);
      }
    } catch (e) {
      logger.e('Error extending time: $e');
      if (mounted) {
        showCustomToaster(
          'Failed to extend time. Please try again.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          _isProcessing = false;
        });
      }
    }
  }
}
