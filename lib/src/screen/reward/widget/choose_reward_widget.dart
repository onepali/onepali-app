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

  String? childId;

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      _fetchChildId();
    });
  }

  Future<void> _fetchChildId() async {
    childId = await ChildLocalStorage.getCurrentChildId();
    if (childId != null) {
      _fetchClaimableRewards(childId!);
    }
  }

  Future<void> _fetchClaimableRewards(String childId) async {
    final rewardProvider = context.read<RewardProvider>();
    await rewardProvider.fetchClaimableRewards(childId);
  }

  Widget stickerGrid(List<RewardModel> rewards) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);
    // If rewards length is greater than 3, show only 3, otherwise show all
    final rewardToShow = rewards.length > 3 ? rewards.sublist(0, 3) : rewards;
    // Responsive values
    final double stickerSize = isMobileLandscape ? 130 : 300;
    final double stickerMargin = isMobileLandscape ? 10 : 24;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(rewardToShow.length, (index) {
        final reward = rewardToShow[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RewardPreviewWidget(data: reward),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: stickerMargin),
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: stickerSize,
              height: stickerSize,
              child: SvgHelper.fromSource(
                path: reward.imageOutline ?? reward.image,
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
          // Content with SafeArea
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
