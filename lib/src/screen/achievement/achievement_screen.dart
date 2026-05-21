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
  int completedActivities = 0;
  int dayStreak = 0;

  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final rewardProvider = context.read<RewardProvider>();
    final metricsProvider = context.read<PzMetricsProvider>();
    final userProvider = context.read<UserProvider>();

    // Get childId from parameter or fallback to local storage
    String? targetChildId = widget.childId;
    if (targetChildId == null || targetChildId.isEmpty) {
      targetChildId = await ChildLocalStorage.getCurrentChildId();
      logger.d('Using fallback childId from local storage: $targetChildId');
    }

    logger.d('Fetching achievement data for childId: $targetChildId');
    await rewardProvider.fetchChildRewards(childId: targetChildId);

    // Fetch metrics data
    final parentUid = userProvider.userId;
    if (parentUid != null && targetChildId != null) {
      await metricsProvider.fetchMetrics(
        parentUid: parentUid,
        childUid: targetChildId,
      );
    }
  }

  String _getAchievementValue(id) {
    switch (id) {
      case "1": // Practice Hero Trophy - Day Streak
        return dayStreak.toString();
      case "2": // Learning Champion Medal - Completed Activities
        return completedActivities.toString();
      case "3": // Star Collector Badge - Total Stars
        return totalStarBadge.toString();
      default:
        return "0";
    }
  }

  Widget buildAchievementGrid() {
    final isTablet = PlatformUtility.isTablet(context);

    var rewardProvider = context.watch<RewardProvider>();
    var metricsProvider = context.watch<PzMetricsProvider>();

    // Update local variables with real data
    totalStarBadge = rewardProvider.totalStarBadge;
    completedActivities = metricsProvider.metrics?.completedActivities ?? 0;
    dayStreak = metricsProvider.metrics?.dayStreak ?? 0;
    logger.d(
      'AchievementScreen - totalStarBadge: $totalStarBadge, completedActivities: $completedActivities, dayStreak: $dayStreak',
    );

    if (isTablet) {
      // For tablets, use a horizontal row layout
      return LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.of(context).size.height,
            child: Row(
              children: achievementList.map((achievement) {
                final value = _getAchievementValue(achievement.id);
                return Expanded(
                  child: AchievementTabCard(
                    achievement: achievement,
                    dynamicValue: value,
                    onTap: () {},
                  ),
                );
              }).toList(),
            ),
          );
        },
      );
    } else {
      // Mobile layout - horizontal scroll (original structure)
      final double horizontalPadding = 0.0;
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 0,
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
  }

  Widget buildCongratulationsSection() {
    final isMobile = PlatformUtility.isMobile(context);
    final isTablet = PlatformUtility.isTablet(context);
    final isTabletLandScape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    final double titleFontSize = isTabletLandScape
        ? 22
        : (isMobileLandscape ? 20 : 24);
    final double imageSize = isTabletLandScape
        ? 150
        : (isMobileLandscape ? 80 : 120);
    final double paddingH = isTabletLandScape ? 50 : 16;
    final double paddingV = isTabletLandScape ? 50 : 16;

    if (isTablet && !isMobile && isTabletLandScape) {
      // Tablet layout - Row with avatar/name on left, congratulations on right
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Avatar with green border and name
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomImage(
                      widget.profileImage,
                      width: imageSize,
                      height: imageSize,
                      circular: true,
                    ),
                    Gaps.verticalGapOf(12),
                    Text(
                      widget.name,
                      style: AppStyles.text24PxSemiBold.copyWith(
                        color: AppColors.kWhite,
                        fontSize: isTabletLandScape ? 40 : titleFontSize,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),

                Gaps.horizontalGapOf(24),

                // Right side - Congratulations message
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableHeight = constraints.maxHeight.isFinite
                          ? constraints.maxHeight
                          : 200.0;
                      return Container(
                        constraints: BoxConstraints(maxHeight: availableHeight),
                        padding: EdgeInsets.symmetric(
                          horizontal: paddingH,
                          vertical: paddingV,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sunshineYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Your Nepali is improving!',
                                style: AppStyles.text22PxMedium.copyWith(
                                  fontSize: 26,
                                  color: AppColors.kBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gaps.horizontalGapOf(16),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Gaps.horizontalGapOf(24),

                CircularButtonWidget(
                  onPressed: () => Navigator.pop(context),
                  type: CircularButtonType.closeGrey,
                ),
              ],
            ),
          ),

          Positioned(
            top: 20,
            right: 160,

            child: SizedBox(
              width: 30.w(context),
              height: 32.h(context),
              child: CustomImage(
                Assets.achievementTab,
                boxFit: BoxFit.contain,

                imageType: CustomImageType.local,
              ),
            ),
          ),
        ],
      );
    } else {
      // Mobile layout - original unchanged
      return LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width;

          return Container(
            height: isTabletLandScape
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height * 0.8,
            width: availableWidth,
            margin: EdgeInsets.symmetric(
              vertical: paddingV,
              horizontal: paddingH + 4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mobile layout - original row format (unchanged)
                Row(
                  children: [
                    CustomImage(
                      widget.profileImage,
                      width: imageSize,
                      height: imageSize,
                      circular: true,
                      border: true,
                      borderColor: AppColors.kButtonGreen,
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
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Gaps.verticalGapOf(isTabletLandScape ? 20 : 10),

                // Message container - fills remaining space like original
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Your Nepali is improving!',
                          style: AppStyles.text22PxMedium.copyWith(
                            fontSize: titleFontSize - 2,
                            color: AppColors.kBlack,
                            fontWeight: FontWeight.normal,
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
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = PlatformUtility.isTablet(context);
    return Scaffold(
      backgroundColor: AppColors.kBlack,
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.asset(Assets.rewardBackground, fit: BoxFit.cover),
            ),

            // Content
            if (isTablet)
              // Tablet layout - Column structure
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Congratulations section at top
                    buildCongratulationsSection(),
                    // Achievement cards below
                    buildAchievementGrid(),
                  ],
                ),
              )
            else
              // Mobile layout - Row structure
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  // Use 40% of screen width for congratulations section, minimum 180px, maximum 250px
                  final congratsWidth = (screenWidth * 0.4).clamp(180.0, 250.0);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: congratsWidth,
                        child: buildCongratulationsSection(),
                      ),
                      Expanded(child: buildAchievementGrid()),
                    ],
                  );
                },
              ),

            // Close button at top-right corner
            if (!isTablet)
              Positioned(
                top: 16,
                right: Dimensions.kIconMargin(context) - 8,
                child: CircularButtonWidget(
                  onPressed: () => Navigator.pop(context),
                  type: CircularButtonType.closeGrey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
