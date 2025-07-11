import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../src.dart';

class RewardCollectionWidget extends StatefulWidget {
  const RewardCollectionWidget({super.key});

  @override
  State<RewardCollectionWidget> createState() => _RewardCollectionWidgetState();
}

class _RewardCollectionWidgetState extends State<RewardCollectionWidget> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<RewardProvider>().fetchChildRewards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Responsive values
    final double stickerSize = isMobileLandscape ? 100 : 150;
    final double stickerMargin = isMobileLandscape ? 24 : 34;
    final double titleFontSize = isMobileLandscape ? 24 : 28;
    final double wrongIconSize = isMobileLandscape ? 40 : 52;

    return Consumer<RewardProvider>(
      builder: (context, rewardProvider, child) {
        if (rewardProvider.status == DataFetchStatus.loading) {
          return CustomLoader();
        } else {
          final unlockedStickers = rewardProvider.childRewards.take(5).toList();

          Widget stickerGrid() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: stickerMargin,
                  runSpacing: stickerMargin,
                  children: List.generate(5, (index) {
                    final isUnlocked = index < unlockedStickers.length;
                    final colors = [
                      Colors.orange,
                      Colors.purple,
                      Colors.red,
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
                    return Container(
                      width: stickerSize,
                      height: stickerSize,
                      decoration: BoxDecoration(
                        color:
                            isUnlocked
                                ? AppColors.transparent
                                : colors[index % colors.length],
                        shape: shapes[index % shapes.length],
                        borderRadius:
                            shapes[index % shapes.length] == BoxShape.rectangle
                                ? borderRadius[index % borderRadius.length]
                                : null,
                        border: Border.all(
                          color:
                              isUnlocked
                                  ? AppColors.transparent
                                  : colors[index % colors.length],
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child:
                            isUnlocked
                                ? CustomImage(
                                  unlockedStickers[index].image,
                                  boxFit: BoxFit.contain,
                                )
                                : Text(
                                  '?',
                                  style: AppStyles.text24PxMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: stickerMargin),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: stickerMargin,
                  runSpacing: stickerMargin,
                  children: List.generate(1, (index) {
                    final isUnlocked = index + 5 < unlockedStickers.length;
                    final colors = [
                      Colors.orange,
                      Colors.purple,
                      Colors.red,
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
                      BorderRadius.circular(50), // Oval
                      BorderRadius.circular(0),
                      BorderRadius.circular(50),
                      BorderRadius.circular(0),
                    ];
                    return Container(
                      width: stickerSize,
                      height: stickerSize,
                      decoration: BoxDecoration(
                        color:
                            isUnlocked
                                ? AppColors.transparent
                                : colors[index % colors.length],
                        shape: shapes[index % shapes.length],
                        borderRadius:
                            shapes[index % shapes.length] == BoxShape.rectangle
                                ? borderRadius[index % borderRadius.length]
                                : null,
                        border: Border.all(
                          color:
                              isUnlocked
                                  ? AppColors.transparent
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
                                  style: AppStyles.text24PxMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    );
                  }),
                ),
              ],
            );
          }

          return Scaffold(
            backgroundColor: AppColors.kWhite,
            appBar: CustomAppBar(
              title: 'My Sticker Collection',
              centerTitle: true,
              showBackButton: false,
              automaticallyImplyLeading: false,
              leading: null,
              titleStyle: AppStyles.text22PxSemiBold.copyWith(
                fontSize: titleFontSize,
                fontFamily: 'Luckiest Guy',
                letterSpacing: 1.6,
              ),
              actions: [
                customInkwell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: SvgHelper.fromSource(
                      path: Assets.wrong,
                      height: wrongIconSize,
                      color: AppColors.kLightGrey,
                    ),
                  ),
                ),
              ],
            ),
            body: Center(child: stickerGrid()),
          );
        }
      },
    );
  }
}
