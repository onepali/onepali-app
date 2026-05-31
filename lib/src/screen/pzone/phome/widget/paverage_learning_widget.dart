import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

import '../../../../src.dart';

class PAverageLearningWidget extends StatefulWidget {
  final int completedActivities;
  final double answerSuccessRate;
  final bool isMobilePortrait;
  final String parentUid;
  final String childUid;

  const PAverageLearningWidget({
    super.key,
    required this.completedActivities,
    required this.answerSuccessRate,
    required this.isMobilePortrait,
    required this.parentUid,
    required this.childUid,
  });

  @override
  State<PAverageLearningWidget> createState() => _PAverageLearningWidgetState();
}

class _PAverageLearningWidgetState extends State<PAverageLearningWidget> {

  @override
  Widget build(BuildContext context) {
    final minHeight = widget.isMobilePortrait ? 140.0 : 290.0;

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
                    widget.completedActivities.toString(),
                    style: AppStyles.text40PxSemiBold.copyWith(
                      fontSize: widget.isMobilePortrait ? 40 : 72,
                    ),
                  ),
                  Gaps.verticalGapOf(8),
                  Text(
                    'Completed activities',
                    textAlign: TextAlign.center,
                    style: AppStyles.text16PxMedium.copyWith(
                      fontFamily: AppConstants.kDMSansFont,
                      fontSize: widget.isMobilePortrait ? 16 : 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gaps.horizontalGapOf(widget.isMobilePortrait ? 16 : 32),
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
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(AppConstants.usersCollection)
                            .doc(widget.parentUid)
                            .collection(AppConstants.childrenCollection)
                            .doc(widget.childUid)
                            .snapshots(),
                        builder: (context, shapshot) {
                          final data = shapshot.data?.data();
                          if (data == null) {
                            return const SizedBox.shrink();
                          }
                          final rightAnswersCount =
                              data['right_answers_count'] ?? 0;
                          final wrongAnswersCount =
                              data['wrong_answers_count'] ?? 0;
                          final totalAnswers = rightAnswersCount + wrongAnswersCount;
                          final answerSuccessRate =
                              totalAnswers > 0
                                  ? rightAnswersCount / totalAnswers
                                  : 0.0;
                          return Text(
                            '${(answerSuccessRate * 100).toStringAsFixed(0)}',
                            style: AppStyles.text40PxSemiBold.copyWith(
                              fontSize: widget.isMobilePortrait ? 40 : 72,
                            ),
                          );
                        },
                      ),
                      Gaps.horizontalGapOf(4),
                      Text(
                        '%',
                        style: AppStyles.text16PxSemiBold.copyWith(
                          fontSize: widget.isMobilePortrait ? 16 : 24,
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
                      fontSize: widget.isMobilePortrait ? 16 : 24,
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
