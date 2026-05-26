
import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';
import 'package:onepali/src/src.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlatformUtility.isTablet(context);
    return Scaffold(
      backgroundColor: AppColors.kBlack,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(Assets.rewardBackground, fit: BoxFit.cover),
          ),
          // Achievement board
          AchievementLayout(
            name: widget.name,
            profileImage: widget.profileImage,
            childId: widget.childId,
          ),
          // Close button at top-right corner
          TopRightPositionedCloseButton(
            iconPath: Assets.closeGreyIcon,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class AchievementBoardScreen extends StatefulWidget {
  const AchievementBoardScreen({super.key});

  @override
  State<AchievementBoardScreen> createState() => _AchievementBoardScreenState();
}

class _AchievementBoardScreenState extends State<AchievementBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackgroundImage(
            bgImageMb: Assets.rewardBackground,
            bgImageTb: Assets.rewardBackground,
          ),
        ),
        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 32, 8, 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAvatarCard(),
                const SizedBox(width: 14),
                Expanded(
                  child: Row(
                    children: [
                      _buildAchievementCard(),
                      const SizedBox(width: 12),
                      _buildAchievementCard(),
                      const SizedBox(width: 12),
                      _buildAchievementCard(),
                    ],
                  ),
                ),

                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kButtonGreen,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kBlack.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CustomImage(
                Assets.avatar1,
                width: 52,
                height: 52,
                circular: true,
                imageType: CustomImageType.local,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Dev',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.kWhite,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          width: 200,
          decoration: BoxDecoration(
            color: AppColors.sunshineYellow,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Message
              const Text(
                'Your Nepali is\nimproving!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF333333),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),

              // Celebration illustration
              CustomImage(
                Assets.achievement,
                boxFit: BoxFit.contain,
                imageType: CustomImageType.local,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kButtonGreen,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.kBlack.withValues(alpha: 0.55),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Count
            Text(
              '5',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),

            // Emoji
            Text('🏆', style: const TextStyle(fontSize: 38)),

            // Label
            Text(
              'Practice Hero\nTrophy',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.35,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
