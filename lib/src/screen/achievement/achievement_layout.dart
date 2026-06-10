import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/screen/achievement/achievement_card.dart';
import 'package:onepali/src/screen/achievement/yellow_banner.dart';
import 'package:provider/provider.dart';

class AchievementLayout extends StatefulWidget {
  const AchievementLayout({
    super.key,
    this.childId,
    required this.name,
    required this.profileImage,
  });
  final String? childId;
  final String name;
  final String profileImage;

  @override
  State<AchievementLayout> createState() => _AchievementLayoutState();
}

class _AchievementLayoutState extends State<AchievementLayout>
    with TickerProviderStateMixin {
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

  int totalStarBadge = 0;
  int completedActivities = 0;
  int dayStreak = 0;

  @override
  Widget build(BuildContext context) {
    var rewardProvider = context.watch<RewardProvider>();
    var metricsProvider = context.watch<PzMetricsProvider>();
    totalStarBadge = rewardProvider.totalStarBadge;
    completedActivities = metricsProvider.completedContents.length;
    dayStreak = metricsProvider.metrics?.dayStreak ?? 0;

    final achievements = [
      AchievementModel(
        id: "1",
        title: "Practice Hero Trophy",
        subtitle: "Days streak",
        value: dayStreak.toString(),
        imageUrl: Assets.trophyAv,
        color: AppColors.kPureSkyBlue,
      ),
      AchievementModel(
        id: "2",
        title: "Learning Champion Medal",
        subtitle: "Completed activities",
        value: completedActivities.toString(),
        imageUrl: Assets.medalAv,
        color: AppColors.kButtonRed,
      ),
      AchievementModel(
        id: "3",
        title: "Star Collector Badge",
        subtitle: "Total stars collected",
        value: totalStarBadge.toString(),
        imageUrl: Assets.starAv,
        color: AppColors.kButtonGreen,
      ),
    ];
    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: Image.asset(
            Assets.rewardBackground,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Container(color: const Color(0xFF1A1A2E)),
          ),
        ),

        // Content
        SafeArea(
          child: PlatformUtility.isTablet(context)
              ? _TabletLayout(
                  achievements: achievements,
                  name: widget.name,
                  profileImage: widget.profileImage,
                )
              : _MobileLayout(
                  achievements: achievements,
                  name: widget.name,
                  profileImage: widget.profileImage,
                ),
        ),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout({
    required this.achievements,
    required this.name,
    required this.profileImage,
  });
  final List<AchievementModel> achievements;
  final String name;
  final String profileImage;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hPad = size.width * 0.03;
    final vPad = size.height * 0.04;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, vPad, hPad + 56, vPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: avatar + name  |  yellow banner ──────────────────────
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar + name (stacked)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImage(
                          profileImage,
                          width: 150,
                          height: 150,
                          circular: true,
                        )
                        .animate()
                        .scaleXY(
                          begin: 0.7,
                          end: 1.0,
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(duration: 400.ms),
                    Text(
                          name,
                          style: AppStyles.text40PxBold.copyWith(
                            color: AppColors.kWhite,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          delay: 200.ms,
                          duration: 400.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  ],
                ),

                SizedBox(width: size.width * 0.03),

                // Yellow banner
                Expanded(
                  child: YellowBanner(height: size.height * 0.38)
                      .animate()
                      .fadeIn(delay: 250.ms, duration: 500.ms)
                      .slideX(
                        begin: 0.15,
                        end: 0,
                        delay: 250.ms,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ),
              ],
            ),
          ),

          SizedBox(height: size.height * 0.04),

          // ── Bottom row: three achievement cards ───────────────────────────
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < achievements.length; i++)
                  Expanded(
                    child:
                        AchievementCard(
                              achievement: achievements[i],
                              value: achievements[i].value,
                            )
                            .animate()
                            .fadeIn(delay: (400 + i * 150).ms, duration: 450.ms)
                            .slideY(
                              begin: -0.4,
                              end: 0,
                              delay: (400 + i * 150).ms,
                              duration: 550.ms,
                              curve: Curves.easeOutCubic,
                            ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.achievements,
    required this.name,
    required this.profileImage,
  });
  final List<AchievementModel> achievements;
  final String name;
  final String profileImage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar card
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CustomImage(
                        profileImage,
                        width: 80,
                        height: 80,
                        circular: true,
                      )
                      .animate()
                      .scaleXY(
                        begin: 0.7,
                        end: 1.0,
                        duration: 500.ms,
                        curve: Curves.easeOutBack,
                      )
                      .fadeIn(duration: 400.ms),
                  const SizedBox(width: 8),
                  Text(
                        name,
                        style: AppStyles.text24PxSemiBold.copyWith(
                          color: AppColors.kWhite,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 400.ms)
                      .slideX(
                        begin: 0.2,
                        end: 0,
                        delay: 150.ms,
                        duration: 400.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Expanded(
                child:
                    Container(
                          constraints: BoxConstraints(
                            maxWidth: 170,
                            minWidth: 150,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.sunshineYellow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Spacer(),
                              Text(
                                'Your Nepali is\nimproving!',
                                textAlign: TextAlign.center,
                                style: AppStyles.text18PxSemiBold,
                              ),
                              const SizedBox(height: 8),
                              Spacer(),
                              Image.asset(
                                    Assets.achievement,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) =>
                                        const SizedBox(height: 60),
                                  )
                                  .animate()
                                  .scaleXY(
                                    begin: 0.7,
                                    end: 1.0,
                                    delay: 300.ms,
                                    duration: 500.ms,
                                    curve: Curves.easeOutBack,
                                  )
                                  .fadeIn(delay: 300.ms, duration: 400.ms),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms)
                        .slideY(
                          begin: 0.15,
                          end: 0,
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Three cards
          Expanded(
            child: Row(
              children: [
                for (int i = 0; i < achievements.length; i++)
                  Expanded(
                    child:
                        AchievementCard(
                              achievement: achievements[i],
                              value: achievements[i].value,
                            )
                            .animate()
                            .fadeIn(delay: (350 + i * 130).ms, duration: 450.ms)
                            .slideY(
                              begin: -0.4,
                              end: 0,
                              delay: (350 + i * 130).ms,
                              duration: 550.ms,
                              curve: Curves.easeOutCubic,
                            ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
