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
  final List<PzCompletedContentModel> completedContents;
  const PHomeCard({
    super.key,
    required this.children,
    required this.selectedChildUid,
    required this.onChildSelected,
    required this.metrics,
    required this.metricsStatus,
    required this.isMobilePortrait,
    required this.parentUid,
    required this.completedContents,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);
    
    // Filter out invalid children (empty name or uid)
    final filteredChildren = children.where(
      (child) => child.fullName.isNotEmpty && child.uid.isNotEmpty,
    ).toList();
    
    logger.d('📋 PHomeCard - Total children: ${children.length}, Filtered: ${filteredChildren.length}');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Children Dropdown - Always visible
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.kLightGrey),
            ),
            alignment: Alignment.center,
            height: Dimensions.kSettingAvatarSize(context) + 16,
            child: filteredChildren.isEmpty
                ? Center(
                    child: Text(
                      'No children available',
                      style: AppStyles.text16PxRegular.copyWith(
                        fontFamily: AppConstants.kDMSansFont,
                        fontSize: isMobilePortrait ? 16 : 24,
                      ),
                    ),
                  )
                : DropdownButtonHideUnderline(
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
                      items: filteredChildren
                          .map((child) {
                            return DropdownMenuItem<String>(
                              value: child.uid,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    CustomImage(
                                      child.avatarUrl.isNotEmpty
                                          ? child.avatarUrl
                                          : "",
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
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onChildSelected(value);
                        }
                      },
                    ),
                  ),
          ),
          Gaps.verticalGapOf(16),
          // Metrics Content - Always show if child is selected
          if (selectedChildUid == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Please select a child to view metrics',
                  style: AppStyles.text16PxRegular.copyWith(
                    fontFamily: AppConstants.kDMSansFont,
                    fontSize: isMobilePortrait ? 16 : 24,
                  ),
                ),
              ),
            )
          else if (metricsStatus == DataFetchStatus.loading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: CustomLoader(),
            )
          else if (metricsStatus == DataFetchStatus.error)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Error loading metrics. Please try again.',
                  style: AppStyles.text16PxRegular.copyWith(
                    fontFamily: AppConstants.kDMSansFont,
                    fontSize: isMobilePortrait ? 16 : 24,
                  ),
                ),
              ),
            )
          else if (metrics == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'No metrics data found for this child',
                  style: AppStyles.text16PxRegular.copyWith(
                    fontFamily: AppConstants.kDMSansFont,
                    fontSize: isMobilePortrait ? 16 : 24,
                  ),
                ),
              ),
            )
          else ...[
            PAverageLearningWidget(
              completedActivities: completedContents.length,
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
              mostPracticedTopics: completedContents,
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
