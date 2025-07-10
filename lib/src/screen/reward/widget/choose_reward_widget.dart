import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class ChooseRewardWidget extends StatefulWidget {
  const ChooseRewardWidget({super.key});

  @override
  State<ChooseRewardWidget> createState() => _ChooseRewardWidgetState();
}

class _ChooseRewardWidgetState extends State<ChooseRewardWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final stickers = AppConstants.rewardOutlinedStickers;
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Responsive values
    final double stickerSize = isMobileLandscape ? 90 : 130;
    final double stickerMargin = isMobileLandscape ? 10 : 24;
    final double titleFontSize = isMobileLandscape ? 20 : 28;
    final double titlePaddingH = isMobileLandscape ? 16 : 32;
    final double titlePaddingV = isMobileLandscape ? 10 : 18;
    final double gap = isMobileLandscape ? 24 : 40;

    Widget stickerGrid() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(stickers.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: stickerMargin),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border:
                    isSelected
                        ? Border.all(
                          color: AppColors.kPurple.withValues(alpha: 0.8),
                          width: 4,
                        )
                        : null,
                borderRadius: BorderRadius.circular(18),
              ),
              child: SizedBox(
                width: stickerSize,
                height: stickerSize,
                child: CustomImage(stickers[index], cover: false),
              ),
            ),
          );
        }),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.kBlack,
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
                    'Choose your new sticker!',
                    style: AppStyles.text22PxMedium.copyWith(
                      fontSize: titleFontSize,
                    ),
                  ),
                ),
                Gaps.verticalGapOf(gap),
                stickerGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
