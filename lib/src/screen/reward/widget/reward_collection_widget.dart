import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../src.dart';

class RewardCollectionWidget extends StatefulWidget {
  final String? childId;
  const RewardCollectionWidget({super.key, this.childId});

  @override
  State<RewardCollectionWidget> createState() => _RewardCollectionWidgetState();
}

class _RewardCollectionWidgetState extends State<RewardCollectionWidget> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      if (widget.childId != null) {
        context.read<RewardProvider>().fetchChildRewards(
          childId: widget.childId,
        );
      } else {
        context.read<RewardProvider>().fetchChildRewards();
      }
    });
  }

  void _showRewardPopup(BuildContext context, RewardModel reward) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => RewardStickerPopup(reward: reward),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Responsive values
    final double stickerSize = isMobileLandscape ? 130 : 180;
    final double stickerMargin = isMobileLandscape ? 24 : 34;
    final double titleFontSize = isMobileLandscape ? 24 : 64;

    return Consumer<RewardProvider>(
      builder: (context, rewardProvider, child) {
        return StatusHandler(
          status: rewardProvider.status,
          hasData: true,
          errorTitle: 'Error loading stickers',
          errorMessage: 'Please try again later.',
          onRetry: () {
            if (widget.childId != null) {
              context.read<RewardProvider>().fetchChildRewards(
                childId: widget.childId,
              );
            } else {
              context.read<RewardProvider>().fetchChildRewards();
            }
          },
          successBuilder: () {
            final unlockedStickers =
                rewardProvider.childRewards.take(5).toList();

            Widget stickerGrid() {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with title and close button
                    SizedBox(
                      height: 60, // Fixed height for header
                      child: Stack(
                        children: [
                          // Centered title
                          Center(
                            child: Text(
                              widget.childId != null
                                  ? 'Sticker Collection'
                                  : 'My Sticker Collection',
                              style: AppStyles.text22PxSemiBold.copyWith(
                                fontSize: titleFontSize,
                                fontFamily: 'Luckiest Guy',
                                letterSpacing: 1.6,
                              ),
                            ),
                          ),
                          // Close button at top right
                          Positioned(
                            top: 0,
                            right: Dimensions.kIconMargin(context),
                            child: CircularButtonWidget(
                              onPressed: () {
                                UserAppBar.setTabIndex(0);

                                Utility.navigate(
                                  context,
                                  AppRoutes.dashboardScreen,
                                );
                              },
                              type: CircularButtonType.close,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gaps.verticalGapOf(stickerMargin),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: stickerMargin,
                      runSpacing: stickerMargin,
                      children: List.generate(5, (index) {
                        final isUnlocked = index < unlockedStickers.length;
                        final colors = [
                          Colors.orange,
                          Colors.purple,
                          AppColors.kRed,
                          Colors.teal,
                          Colors.blue,
                        ];
                        final shapes = [
                          BoxShape.circle,
                          BoxShape.rectangle,
                          BoxShape.circle,
                          BoxShape.rectangle,
                          BoxShape.circle,
                        ];
                        final borderRadius = [
                          BorderRadius.circular(0), // Cone-like
                          BorderRadius.circular(25), // Oval
                          BorderRadius.circular(0),
                          BorderRadius.circular(10),
                          BorderRadius.circular(0),
                        ];
                        return GestureDetector(
                          onTap:
                              isUnlocked
                                  ? () => _showRewardPopup(
                                    context,
                                    unlockedStickers[index],
                                  )
                                  : null,
                          child: Container(
                            width: stickerSize,
                            height: stickerSize,
                            decoration: BoxDecoration(
                              color:
                                  isUnlocked
                                      ? AppColors.kTransparentColor
                                      : colors[index % colors.length],
                              shape: shapes[index % shapes.length],
                              borderRadius:
                                  shapes[index % shapes.length] ==
                                          BoxShape.rectangle
                                      ? borderRadius[index %
                                          borderRadius.length]
                                      : null,
                              border: Border.all(
                                color:
                                    isUnlocked
                                        ? AppColors.kTransparentColor
                                        : colors[index % colors.length],
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child:
                                  isUnlocked
                                      ? SvgHelper.fromSource(
                                        path: unlockedStickers[index].image,
                                        type: SvgSourceType.network,
                                        fit: BoxFit.contain,
                                      )
                                      : Text(
                                        '?',
                                        style: AppStyles.text24PxMedium
                                            .copyWith(color: AppColors.kWhite),
                                      ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Gaps.verticalGapOf(stickerMargin),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: stickerMargin,
                      runSpacing: stickerMargin,
                      children: List.generate(1, (index) {
                        final isUnlocked = index + 5 < unlockedStickers.length;
                        final colors = AppColors.rewardCollectionColors;
                        final shapes = [
                          BoxShape.circle,
                          BoxShape.rectangle,
                          BoxShape.circle,
                          BoxShape.rectangle,
                          BoxShape.circle,
                        ];
                        final borderRadius = [
                          BorderRadius.circular(0), // Cone-like
                          BorderRadius.circular(50), // Oval
                          BorderRadius.circular(0),
                          BorderRadius.circular(50),
                          BorderRadius.circular(0),
                        ];
                        return GestureDetector(
                          onTap:
                              isUnlocked
                                  ? () => _showRewardPopup(
                                    context,
                                    unlockedStickers[index + 5],
                                  )
                                  : null,
                          child: Container(
                            width: stickerSize,
                            height: stickerSize,
                            decoration: BoxDecoration(
                              color:
                                  isUnlocked
                                      ? AppColors.kTransparentColor
                                      : colors[index % colors.length],
                              shape: shapes[index % shapes.length],
                              borderRadius:
                                  shapes[index % shapes.length] ==
                                          BoxShape.rectangle
                                      ? borderRadius[index %
                                          borderRadius.length]
                                      : null,
                              border: Border.all(
                                color:
                                    isUnlocked
                                        ? AppColors.kTransparentColor
                                        : colors[index % colors.length],
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child:
                                  isUnlocked
                                      ? CustomImage(
                                        unlockedStickers[index + 5].image,
                                        boxFit: BoxFit.contain,
                                      )
                                      : Text(
                                        '?',
                                        style: AppStyles.text24PxMedium
                                            .copyWith(color: AppColors.kWhite),
                                      ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              backgroundColor: AppColors.kWhite,

              body: SafeArea(child: stickerGrid()),
            );
          },
        );
      },
    );
  }
}
