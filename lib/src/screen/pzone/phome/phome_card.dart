import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

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
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);
    // final selectedChild = children.firstWhere(
    //   (child) => child.uid == selectedChildUid,
    //   orElse: () => children.first,
    // );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.kLightGrey),
            ),
            alignment: Alignment.center,
            height: Dimensions.kSettingAvatarSize(context) + 16,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                iconSize: Dimensions.kSettingAvatarSize(context) - 26,
                value: selectedChildUid,
                isExpanded: true,
                hint: Text(
                  'Select child',
                  style: AppStyles.text16PxRegular.copyWith(
                    fontFamily: AppConstants.kDMSansFont,
                    fontSize: isMobilePortrait ? 16 : 24,
                  ),
                ),
                items: children.map((child) {
                  return DropdownMenuItem<String>(
                    value: child.uid,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        CustomImage(
                          child.avatarUrl.isNotEmpty ? child.avatarUrl : "",
                          imageType: child.avatarUrl.isNotEmpty
                              ? CustomImageType.network
                              : CustomImageType.local,
                          circular: true,
                          height: Dimensions.kSettingAvatarSize(context),
                          width: Dimensions.kSettingAvatarSize(context),
                          cover: false,
                        ),
                        Gaps.horizontalGapOf(12),
                        Text(
                          child.fullName,
                          style: AppStyles.text16PxRegular.copyWith(
                            fontFamily: AppConstants.kDMSansFont,
                            fontSize: isMobilePortrait ? 16 : 24,
                            fontWeight: isMobilePortrait
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                        ),
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
            Gaps.verticalGapOf(isMobilePortrait ? 16 : 32),
            PDailyLearningWidget(
              dayStreak: metrics!.dayStreak,
              weeklyStreak: metrics!.weeklyStreak,
              isMobilePortrait: isMobilePortrait,
            ),
            Gaps.verticalGapOf(isMobilePortrait ? 16 : 32),
            PDashboardMetricsWidget(
              averageDailyLearningTime: metrics!.averageDailyLearningTime,
              mostPracticedTopics: metrics!.mostPracticedTopics,
              isMobilePortrait: isMobilePortrait,
            ),
            // Gaps.verticalGapOf(24),
            // ElevatedButton(
            //   onPressed:
            //       parentUid != null && selectedChildUid != null
            //           ? () async {
            //             await Provider.of<PzMetricsProvider>(
            //               context,
            //               listen: false,
            //             ).updateMetrics(
            //               parentUid: parentUid!,
            //               childUid: selectedChildUid!,
            //               newMetrics: metrics!.copyWith(
            //                 completedActivities:
            //                     metrics!.completedActivities + 1,
            //               ),
            //             );
            //           }
            //           : null,
            //   child: const Text('Update Metrics (Demo)'),
            // ),
          ],
        ],
      ),
    );
  }
}
