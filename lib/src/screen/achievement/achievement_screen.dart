import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
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
  Widget build(BuildContext context) {
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
