import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ChooseRewardWidget extends StatefulWidget {
  const ChooseRewardWidget({super.key});

  @override
  State<ChooseRewardWidget> createState() => _ChooseRewardWidgetState();
}

class _ChooseRewardWidgetState extends State<ChooseRewardWidget> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      _fetchRewards();
    });
  }

  Future<void> _fetchRewards() async {
    final rewardProvider = context.read<RewardProvider>();
    await rewardProvider.fetchClaimableRewards();
  }

  Widget stickerGrid(List<RewardModel> rewards) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Responsive values
    final double stickerSize = isMobileLandscape ? 130 : 300;
    final double stickerMargin = isMobileLandscape ? 10 : 24;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(rewards.length, (index) {
        // final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RewardPreviewWidget(data: rewards[index]),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: stickerMargin),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // border:
              //     isSelected
              //         ? Border.all(
              //           color: AppColors.kPurple.withValues(alpha: 0.8),
              //           width: 4,
              //         )
              //         : null,
              borderRadius: BorderRadius.circular(18),
            ),
            child: SizedBox(
              width: stickerSize,
              height: stickerSize,
              child: SvgHelper.fromSource(
                path: rewards[index].imageOutline ?? rewards[index].image,
                fit: BoxFit.contain,
                type: SvgSourceType.network,
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rewardProvider = Provider.of<RewardProvider>(context);
    final rewards = rewardProvider.claimableRewards;
    // final stickers = AppConstants.rewardOutlinedStickers;
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Responsive values
    final double titleFontSize = isMobileLandscape ? 20 : 45;
    final double titlePaddingH = isMobileLandscape ? 16 : 40;
    final double titlePaddingV = isMobileLandscape ? 10 : 18;
    final double gap = isMobileLandscape ? 32 : 40;

    return Scaffold(
      backgroundColor: AppColors.kBlack,
      body: Stack(
        children: [
          // Background image covering full screen
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.rewardBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Stack(
            children: [
              if (!isMobileLandscape) Gaps.verticalGapOf(100),
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
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Text(
                        'Choose your new sticker!',
                        style: AppStyles.text22PxSemiBold.copyWith(
                          fontSize: titleFontSize,
                        ),
                      ),
                    ),
                    Gaps.verticalGapOf(gap),
                    stickerGrid(rewards),
                  ],
                ),
              ),
            ],
          ),
          TopRightPositionedCloseButton(
            onTap: () {
              Utility.navigate(context, AppRoutes.dashboardScreen);
            },
          ),
        ],
      ),
    );
  }
}
