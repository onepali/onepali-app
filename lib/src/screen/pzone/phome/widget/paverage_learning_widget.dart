import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../src.dart';

class PAverageLearningWidget extends StatelessWidget {
  final int completedActivities;
  final double answerSuccessRate;
  final bool isMobilePortrait;
  final String? parentUid;
  final String? childUid;

  const PAverageLearningWidget({
    super.key,
    required this.completedActivities,
    required this.answerSuccessRate,
    required this.isMobilePortrait,
    this.parentUid,
    this.childUid,
  });

  @override
  Widget build(BuildContext context) {
    final minHeight = isMobilePortrait ? 140.0 : 290.0;
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              constraints: BoxConstraints(minHeight: minHeight),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    completedActivities.toString(),
                    style: AppStyles.text40PxSemiBold.copyWith(
                      fontSize: isMobilePortrait ? 40 : 72,
                    ),
                  ),
                  Gaps.verticalGapOf(8),
                  Text(
                    'Completed activities',
                    textAlign: TextAlign.center,
                    style: AppStyles.text16PxMedium.copyWith(
                      fontFamily: AppConstants.kDMSansFont,
                      fontSize: isMobilePortrait ? 16 : 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gaps.horizontalGapOf(isMobilePortrait ? 16 : 32),
          Expanded(
            child: Container(
              constraints: BoxConstraints(minHeight: minHeight),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _AnswerSuccessRateText(
                        parentUid: parentUid,
                        childUid: childUid,
                        fallbackRate: answerSuccessRate,
                        isMobilePortrait: isMobilePortrait,
                      ),
                      Gaps.horizontalGapOf(4),
                      Text(
                        '%',
                        style: AppStyles.text16PxSemiBold.copyWith(
                          fontSize: isMobilePortrait ? 16 : 24,
                        ),
                      ),
                    ],
                  ),
                  Gaps.verticalGapOf(8),
                  Text(
                    'Answer success rate',
                    textAlign: TextAlign.center,
                    style: AppStyles.text16PxMedium.copyWith(
                      fontFamily: AppConstants.kDMSansFont,
                      fontSize: isMobilePortrait ? 16 : 24,
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
}

class _AnswerSuccessRateText extends StatelessWidget {
  const _AnswerSuccessRateText({
    required this.parentUid,
    required this.childUid,
    required this.fallbackRate,
    required this.isMobilePortrait,
  });

  final String? parentUid;
  final String? childUid;
  final double fallbackRate;
  final bool isMobilePortrait;

  @override
  Widget build(BuildContext context) {
    if (parentUid == null || childUid == null) {
      return _buildText(fallbackRate);
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childUid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final rightAnswers = (data?['right_answers_count'] as num?) ?? 0;
        final wrongAnswers = (data?['wrong_answers_count'] as num?) ?? 0;
        final totalAnswers = rightAnswers + wrongAnswers;
        final rate = data == null
            ? fallbackRate
            : totalAnswers > 0
            ? rightAnswers / totalAnswers
            : 0.0;

        return _buildText(rate);
      },
    );
  }

  Widget _buildText(double rate) {
    return Text(
      (rate * 100).toStringAsFixed(0),
      style: AppStyles.text40PxSemiBold.copyWith(
        fontSize: isMobilePortrait ? 40 : 72,
      ),
    );
  }
}
