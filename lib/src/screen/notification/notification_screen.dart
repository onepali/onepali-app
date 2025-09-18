import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() async {
      final provider = context.read<PzNotificationProvider>();
      await provider.ensureCollections();

      try {
        await NotificationService.requestPermissions();
      } catch (e) {
        logger.w('Failed to request notification permissions: $e');
      }

      if (provider.settings == null) {
        provider.getNotificationSetting();
      }
      // provider.getNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = PlatformUtility.isMobile(context);

    // Responsive sizing and styling
    final double horizontalPadding = isMobile ? 24.0 : 32.0;
    final double containerPadding = isMobile ? 16.0 : 20.0;
    final double verticalGap1 = isMobile ? 16.0 : 20.0;
    final double verticalGap2 = isMobile ? 24.0 : 30.0;
    final double borderRadius = isMobile ? 8.0 : 12.0;

    final TextStyle titleStyle =
        isMobile ? AppStyles.text16PxMedium : AppStyles.text18PxMedium;
    final TextStyle subtitleStyle =
        isMobile ? AppStyles.text14PxRegular : AppStyles.text16PxRegular;

    return Consumer<PzNotificationProvider>(
      builder: (context, provider, _) {
        return StatusHandler(
          status: provider.status,
          hasData: provider.settings != null,
          errorTitle: 'Failed to load settings',
          errorMessage: 'Please try again to load notification settings.',
          onRetry: () => provider.getNotificationSetting(),
          successBuilder: () {
            final settings = provider.settings!;
            return Scaffold(
              appBar: CustomAppBar(title: 'Notification'),
              backgroundColor: AppColors.kWhite,
              body: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Enable All Notifications',
                        style: titleStyle,
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        provider.toggleAll(!settings.isEnabledAll);
                      },
                      trailing: CupertinoSwitch(
                        value: settings.isEnabledAll,
                        onChanged: (value) {
                          provider.toggleAll(value);
                        },
                        activeTrackColor:
                            settings.isEnabledAll
                                ? AppColors.kButtonGreen
                                : AppColors.kGrey,
                      ),
                    ),
                    Gaps.verticalGapOf(verticalGap1),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: AppColors.kButtonGrey,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.all(containerPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              'Daily Practice Reminder',
                              style: subtitleStyle,
                            ),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            trailing: CupertinoSwitch(
                              value: settings.isPracticeEnabled,
                              onChanged: (value) {
                                provider.togglePracticeReminder(value);
                              },
                              activeTrackColor:
                                  settings.isPracticeEnabled
                                      ? AppColors.kButtonGreen
                                      : AppColors.kGrey,
                            ),
                          ),
                          Gaps.verticalGapOf(8),
                          CupertinoTimePickerField(
                            initialTime:
                                settings.dailyReminderTime != null
                                    ? TimeOfDay(
                                      hour: int.parse(
                                        settings.dailyReminderTime!.split(
                                          ':',
                                        )[0],
                                      ),
                                      minute: int.parse(
                                        settings.dailyReminderTime!.split(
                                          ':',
                                        )[1],
                                      ),
                                    )
                                    : TimeOfDay(hour: 8, minute: 0),
                            onTimeChanged: (time) {
                              final formatted =
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                              provider.updateDailyReminderTime(formatted);
                            },
                            label: 'Reminder Time',
                          ),
                        ],
                      ),
                    ),
                    Gaps.verticalGapOf(verticalGap1),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: AppColors.kButtonGrey,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.all(containerPadding),
                      child: ListTile(
                        title: Text(
                          'Weekly Progress Report',
                          style: subtitleStyle,
                        ),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        trailing: CupertinoSwitch(
                          value: settings.isProgressReportEnabled,
                          onChanged: (value) {
                            provider.toggleProgressReport(value);
                          },
                          activeTrackColor:
                              settings.isProgressReportEnabled
                                  ? AppColors.kButtonGreen
                                  : AppColors.kGrey,
                        ),
                      ),
                    ),
                    Gaps.verticalGapOf(verticalGap1),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kWhite,
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: AppColors.kButtonGrey,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.all(containerPadding),
                      child: ListTile(
                        title: Text('News and Updates', style: subtitleStyle),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        trailing: CupertinoSwitch(
                          value: settings.isNewsEnabled,
                          onChanged: (value) {
                            provider.toggleNews(value);
                          },
                          activeTrackColor:
                              settings.isNewsEnabled
                                  ? AppColors.kButtonGreen
                                  : AppColors.kGrey,
                        ),
                      ),
                    ),
                    Gaps.verticalGapOf(verticalGap2),
                  ],
                ),
              ),
              // bottomNavigationBar: Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: CustomMaterialButton(
              //     label: 'View Notifications',
              //     onTap: () {
              //       if (provider.notifications.isNotEmpty) {
              //         provider.notifications.map(
              //           (n) => Utility.navigateMaterialRoute(
              //             context,
              //             NotificationCard(notification: n),
              //           ),
              //         );
              //       } else {
              //         showCustomToaster('No notifications available');
              //       }
              //     },
              //     isLoading: provider.loading,
              //     fillButton: false,
              //     showBorder: true,
              //     elevation: 0,
              //   ),
              // ),
            );
          },
        );
      },
    );
  }
}
