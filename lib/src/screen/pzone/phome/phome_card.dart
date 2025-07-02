import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class PHomeCard extends StatelessWidget {
  final List<ChildUserModel> children;
  final String? selectedChildUid;
  final Function(String) onChildSelected;
  final PzHomeMetricsModel? metrics;
  final DataFetchStatus metricsStatus;
  final bool isMobilePortrait;
  final String? parentUid;

  const PHomeCard({
    super.key,
    required this.children,
    required this.selectedChildUid,
    required this.onChildSelected,
    required this.metrics,
    required this.metricsStatus,
    required this.isMobilePortrait,
    required this.parentUid,
  });

  @override
  Widget build(BuildContext context) {
    final selectedChild = children.firstWhere(
      (child) => child.uid == selectedChildUid,
      orElse: () => children.first,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.kLightGrey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedChildUid,
              isExpanded: true,
              hint: const Text('Select Child'),
              items:
                  children.map((child) {
                    return DropdownMenuItem<String>(
                      value: child.uid,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.kGrey,
                            backgroundImage:
                                child.avatarUrl.isNotEmpty
                                    ? NetworkImage(child.avatarUrl)
                                    : null,
                          ),
                          Gaps.horizontalGapOf(12),
                          Text(child.fullName),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChildSelected(value);
                }
              },
            ),
          ),
        ),

        Gaps.verticalGapOf(16),

        // Selected Child Info
        Row(
          children: [
            CircleAvatar(
              radius: isMobilePortrait ? 24 : 32,
              backgroundColor: AppColors.kGrey,
              backgroundImage:
                  selectedChild.avatarUrl.isNotEmpty
                      ? NetworkImage(selectedChild.avatarUrl)
                      : null,
            ),
            Gaps.horizontalGapOf(12),
            Text(
              selectedChild.fullName,
              style:
                  isMobilePortrait
                      ? AppStyles.text18PxSemiBold
                      : AppStyles.text22PxSemiBold,
            ),
          ],
        ),

        Gaps.verticalGapOf(24),

        // Metrics Content
        if (metricsStatus == DataFetchStatus.loading)
          CustomLoader()
        else if (metrics == null)
          const Center(child: Text('No metrics data found'))
        else ...[
          PAverageLearningWidget(
            completedActivities: metrics!.completedActivities,
            answerSuccessRate: metrics!.answerSuccessRate,
            isMobilePortrait: isMobilePortrait,
          ),
          Gaps.verticalGapOf(16),
          PDailyLearningWidget(
            dayStreak: metrics!.dayStreak,
            weeklyStreak: metrics!.weeklyStreak,
            isMobilePortrait: isMobilePortrait,
          ),
          Gaps.verticalGapOf(16),
          PDashboardMetricsWidget(
            averageDailyLearningTime: metrics!.averageDailyLearningTime,
            mostPracticedTopics: metrics!.mostPracticedTopics,
            isMobilePortrait: isMobilePortrait,
          ),
          Gaps.verticalGapOf(24),
          ElevatedButton(
            onPressed:
                parentUid != null && selectedChildUid != null
                    ? () async {
                      await Provider.of<PzMetricsProvider>(
                        context,
                        listen: false,
                      ).updateMetrics(
                        parentUid: parentUid!,
                        childUid: selectedChildUid!,
                        newMetrics: metrics!.copyWith(
                          completedActivities: metrics!.completedActivities + 1,
                        ),
                      );
                    }
                    : null,
            child: const Text('Update Metrics (Demo)'),
          ),
        ],
      ],
    );
  }
}
