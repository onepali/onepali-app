import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

/// Achievement progress bar backed by a live Firestore child doc stream.
class AppBarProgressBar extends StatelessWidget {
  final String parentUid;
  final String childUid;

  const AppBarProgressBar({
    super.key,
    required this.parentUid,
    required this.childUid,
  });

  DocumentReference<Map<String, dynamic>> get _childDocRef => FirebaseFirestore
      .instance
      .collection(AppConstants.usersCollection)
      .doc(parentUid)
      .collection(AppConstants.childrenCollection)
      .doc(childUid);

  static int totalLessonsCompletedFromData(Map<String, dynamic>? data) {
    if (data == null) return 0;
    final lessonsCompleted = data['completedLessonsCount'] as int?;
    return lessonsCompleted ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (parentUid.isEmpty || childUid.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final progressBarWidth = constraints.maxWidth;
        if (progressBarWidth <= 0) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _childDocRef.snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            return _ProgressBarContent(
              progressBarWidth: progressBarWidth,
              totalLessonsCompleted: totalLessonsCompletedFromData(data),
            );
          },
        );
      },
    );
  }
}

class _ProgressBarContent extends StatelessWidget {
  final double progressBarWidth;
  final int totalLessonsCompleted;

  const _ProgressBarContent({
    required this.progressBarWidth,
    required this.totalLessonsCompleted,
  });

  @override
  Widget build(BuildContext context) {
    const totalSteps = 5;
    final isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    final progressBarHeight =
        progressBarWidth * (isTabletLandscape ? 0.02 : 0.03);
    final connectorLength =
        progressBarWidth * (isTabletLandscape ? 0.08 : 0.10);
    final circleSize = progressBarWidth * (isTabletLandscape ? 0.04 : 0.05);
    final rewardSize = progressBarWidth * (isTabletLandscape ? 0.10 : 0.12);
    final starLottieSize = progressBarWidth * (isTabletLandscape ? 0.10 : 0.12);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < totalSteps; i++) ...[
          _buildDottedConnector(
            isActive: totalLessonsCompleted > i,
            length: connectorLength,
            height: progressBarHeight,
          ),
          if (i != totalSteps - 1)
            _buildProgressDot(
              isCompleted: totalLessonsCompleted > i,
              isLastStep: i == totalSteps - 1,
              circleSize: circleSize,
            ),
        ],
        if (GlobalConfig.isUserTesting) ...[
          customInkwell(
            onTap: () {
              if (totalLessonsCompleted >= 5) {
                Utility.navigate(context, AppRoutes.chooseRewardScreen);
              } else {
                Utility.navigate(context, AppRoutes.rewardCollectionScreen);
              }
            },
            child: LottieHelper.fromSource(
              path: Assets.starRewardLottie,
              height: starLottieSize,
              repeat: totalLessonsCompleted >= 5,
              width: starLottieSize,
            ),
          ),
        ] else
          SvgHelper.fromSource(
            path: Assets.reward,
            height: rewardSize,
            width: rewardSize,
          ),
      ],
    );
  }

  Widget _buildProgressDot({
    required bool isCompleted,
    required bool isLastStep,
    required double circleSize,
  }) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.kOrange : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: isLastStep && isCompleted
          ? Icon(Icons.star, color: AppColors.kWhite, size: circleSize * 0.6)
          : null,
    );
  }

  Widget _buildDottedConnector({
    required bool isActive,
    required double length,
    required double height,
  }) {
    return CustomPaint(
      size: Size(length, height),
      painter: DottedLinePainter(
        color: isActive ? AppColors.sunshineYellow : Colors.grey.shade300,
        strokeWidth: height,
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DottedLinePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const dashWidth = 4.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
