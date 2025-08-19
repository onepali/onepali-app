import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class AchievementScreen extends StatefulWidget {
  final String name;
  final String profileImage;
  final String? childId;
  const AchievementScreen({
    super.key,
    required this.name,
    required this.profileImage,
    this.childId,
  });

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  int totalStarBadge = 0;

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final rewardProvider = context.read<RewardProvider>();
    await rewardProvider.fetchChildRewards(childId: widget.childId);
  }

  String _getAchievementValue(id) {
    switch (id) {
      case "1":
        return "0";
      case "2":
        return "0";
      case "3":
        return totalStarBadge.toString();
      default:
        return "0";
    }
  }

  Widget buildAchievementGrid() {
    final isTablet = PlatformUtility.isTablet(context);
    final isTabletLandScape = isTablet && PlatformUtility.isLandscape(context);

    var rewardProvider = context.watch<RewardProvider>();
    totalStarBadge = rewardProvider.totalStarBadge;

    // Responsive grid settings
    final double horizontalPadding = isTabletLandScape ? 32.0 : 16.0;

    return Center(
      child: Container(
        height:
            isTabletLandScape
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 16,
        ),
        child: ListView.builder(
          itemCount: achievementList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final achievement = achievementList[index];
            final value = _getAchievementValue(achievement.id);
            return AchievementCard(
              achievement: achievement,
              dynamicValue: value,
            );
          },
        ),
      ),
    );
  }

  Widget buildCongratulationsSection() {
    final isMobile = PlatformUtility.isMobile(context);
    final isTabletLandScape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    final double titleFontSize =
        isTabletLandScape ? 22 : (isMobileLandscape ? 20 : 24);
    final double imageSize =
        isTabletLandScape ? 100 : (isMobileLandscape ? 80 : 120);
    final double paddingH = isTabletLandScape ? 20 : 16;
    final double paddingV = isTabletLandScape ? 25 : 16;

    return Container(
      height:
          isTabletLandScape
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 0.8,
      margin: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImage(
                widget.profileImage,
                width: imageSize,
                height: imageSize,
              ),
              Gaps.horizontalGapOf(10),
              Expanded(
                child: Text(
                  widget.name,
                  style: AppStyles.text24PxSemiBold.copyWith(
                    color: AppColors.kWhite,
                    fontSize: titleFontSize,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          Gaps.verticalGapOf(isTabletLandScape ? 20 : 10),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: paddingH,
                vertical: paddingV,
              ),
              decoration: BoxDecoration(
                color: AppColors.sunshineYellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Nepali is improving!',
                    style: AppStyles.text22PxMedium.copyWith(
                      fontSize: titleFontSize - 2,
                      color: AppColors.kBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.verticalGapOf(4),
                  Expanded(
                    child: Center(
                      child: CustomImage(
                        Assets.achievement,
                        boxFit: BoxFit.contain,
                        imageType: CustomImageType.local,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTabletLandScape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.kBlack,
        body: Stack(
          children: [
            // Background
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

            // Content
            Row(
              children: [
                SizedBox(
                  width: isTabletLandScape ? 230 : 200,
                  child: buildCongratulationsSection(),
                ),
                Expanded(child: buildAchievementGrid()),
              ],
            ),

            // Close button at top-right corner
            Positioned(
              top: 16,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgHelper.fromSource(
                  path: Assets.wrong,
                  color: AppColors.kButtonGrey,
                  height: AppConstants.kIconSize,
                  width: AppConstants.kIconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
