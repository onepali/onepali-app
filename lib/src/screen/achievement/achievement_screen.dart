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
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    var rewardProvider = context.watch<RewardProvider>();
    totalStarBadge = rewardProvider.totalStarBadge;

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child:
          isMobileLandscape
              ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: achievementList.length,
                itemBuilder: (context, index) {
                  final achievement = achievementList[index];
                  final value = _getAchievementValue(achievement.id);
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: AchievementCard(
                      achievement: achievement,
                      dynamicValue: value,
                      useFullHeight: true,
                    ),
                  );
                },
              )
              : const SizedBox.shrink(),
    );
  }

  Widget buildCongratulationsSection() {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    final double titleFontSize = isMobileLandscape ? 18 : 24;
    final double imageSize = isMobileLandscape ? 80 : 120;
    final double paddingH = isMobileLandscape ? 16 : 24;
    final double paddingV = isMobileLandscape ? 12 : 20;

    return Container(
      height: MediaQuery.of(context).size.height,
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
                    fontSize:
                        isMobileLandscape && widget.name.length > 4 ? 20 : 24,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          Gaps.verticalGapOf(10),
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
                      fontSize: titleFontSize,
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
                SizedBox(width: 200, child: buildCongratulationsSection()),
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
