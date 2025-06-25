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
      if (provider.settings == null) {
        provider.getNotificationSetting();
      }
      provider.getNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = PlatformUtility.isMobile(context);
    final bool isMobilePortrait =
        isMobile && PlatformUtility.isPortrait(context);
    return Consumer<PzNotificationProvider>(
      builder: (context, provider, _) {
        final settings = provider.settings;
        if (provider.loading || settings == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: CustomAppBar(title: 'Notification'),
          backgroundColor: AppColors.kWhite,
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    'Enable All Notifications',
                    style:
                        isMobilePortrait
                            ? AppStyles.text16PxMedium
                            : AppStyles.text18PxMedium,
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
                Gaps.verticalGapOf(16),
                TitleActionChild(
                  title: 'Daily Practice Reminder',
                  titlePadding: const EdgeInsets.only(bottom: 8.0),
                  titleStyle:
                      isMobilePortrait
                          ? AppStyles.text16PxMedium
                          : AppStyles.text18PxMedium,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.alarm_add_outlined,
                          color:
                              settings.isPracticeEnabled
                                  ? AppColors.kButtonGreen
                                  : AppColors.kGrey,
                        ),
                        title: Text(
                          'Daily Practice Reminder',
                          style:
                              isMobilePortrait
                                  ? AppStyles.text14PxRegular
                                  : AppStyles.text16PxRegular,
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
                                    settings.dailyReminderTime!.split(':')[0],
                                  ),
                                  minute: int.parse(
                                    settings.dailyReminderTime!.split(':')[1],
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
                Gaps.verticalGapOf(16),
                ListTile(
                  leading: Icon(
                    Icons.mark_email_unread_outlined,
                    color:
                        settings.isProgressReportEnabled
                            ? AppColors.kButtonGreen
                            : AppColors.kGrey,
                  ),
                  title: Text(
                    'Weekly Progress Report',
                    style:
                        isMobilePortrait
                            ? AppStyles.text14PxRegular
                            : AppStyles.text16PxRegular,
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
                Gaps.verticalGapOf(16),
                ListTile(
                  leading: Icon(
                    Icons.tips_and_updates_outlined,
                    color:
                        settings.isNewsEnabled
                            ? AppColors.kButtonGreen
                            : AppColors.kGrey,
                  ),
                  title: Text(
                    'News and Updates',
                    style:
                        isMobilePortrait
                            ? AppStyles.text14PxRegular
                            : AppStyles.text16PxRegular,
                  ),
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
                Gaps.verticalGapOf(24),
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
  }
}
