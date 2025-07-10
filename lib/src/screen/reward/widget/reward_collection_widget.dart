import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Responsive values
    final double stickerSize = isMobileLandscape ? 90 : 130;
    final double stickerMargin = isMobileLandscape ? 10 : 24;
    final double titleFontSize = isMobileLandscape ? 20 : 28;
    final double titlePaddingH = isMobileLandscape ? 16 : 32;
    final double titlePaddingV = isMobileLandscape ? 10 : 18;
    final double gap = isMobileLandscape ? 24 : 40;

    final unlockedStickers =
        AppConstants.rewardOutlinedStickers.take(5).toList();
    final placeholders = List.generate(5, (index) => '?');

    Widget stickerGrid() {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: stickerMargin,
        runSpacing: stickerMargin,
        children: List.generate(10, (index) {
          final isUnlocked = index < unlockedStickers.length;
          return Container(
            width: stickerSize,
            height: stickerSize,
            decoration: BoxDecoration(
              color: isUnlocked ? AppColors.transparent : AppColors.kLightGrey,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    isUnlocked ? AppColors.transparent : AppColors.kLightGrey,
                width: 2,
              ),
            ),
            child: Center(
              child:
                  isUnlocked
                      ? CustomImage(
                        unlockedStickers[index],
                        boxFit: BoxFit.contain,
                      )
                      : Text(
                        '?',
                        style: AppStyles.text24PxMedium.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
            ),
          );
        }),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.rewardBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: titlePaddingH,
                    vertical: titlePaddingV,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Text(
                    'My Sticker Collection',
                    style: AppStyles.text22PxMedium.copyWith(
                      fontSize: titleFontSize,
                    ),
                  ),
                ),
                SizedBox(height: gap),
                stickerGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
