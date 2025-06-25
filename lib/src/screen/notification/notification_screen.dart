import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isEnabledAll = false;
  bool isPracticeEnabled = false;
  bool isProgressReportEnabled = false;
  bool isNewsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = PlatformUtility.isMobile(context);
    final bool isMobilePortrait =
        isMobile && PlatformUtility.isPortrait(context);
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
                setState(() {
                  isEnabledAll = !isEnabledAll;
                  isPracticeEnabled = isEnabledAll;
                  isProgressReportEnabled = isEnabledAll;
                  isNewsEnabled = isEnabledAll;
                });
              },
              trailing: CupertinoSwitch(
                value: isEnabledAll,
                onChanged: (value) {
                  setState(() {
                    isEnabledAll = value;
                  });
                },
                activeTrackColor:
                    isEnabledAll ? AppColors.kButtonGreen : AppColors.kGrey,
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
              child: ListTile(
                leading: Icon(
                  Icons.alarm_add_outlined,
                  color:
                      isPracticeEnabled
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
                  value: isPracticeEnabled,
                  onChanged: (value) {
                    setState(() {
                      isPracticeEnabled = value;
                      if (isEnabledAll) {
                        isEnabledAll = value;
                      }
                    });
                  },
                  activeTrackColor:
                      isPracticeEnabled
                          ? AppColors.kButtonGreen
                          : AppColors.kGrey,
                ),
              ),
            ),
            Gaps.verticalGapOf(16),
            ListTile(
              leading: Icon(
                Icons.mark_email_unread_outlined,
                color:
                    isProgressReportEnabled
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
                value: isProgressReportEnabled,
                onChanged: (value) {
                  setState(() {
                    isProgressReportEnabled = value;
                    if (isEnabledAll) {
                      isEnabledAll = value;
                    }
                  });
                },
                activeTrackColor:
                    isProgressReportEnabled
                        ? AppColors.kButtonGreen
                        : AppColors.kGrey,
              ),
            ),
            Gaps.verticalGapOf(16),
            ListTile(
              leading: Icon(
                Icons.tips_and_updates_outlined,
                color: isNewsEnabled ? AppColors.kButtonGreen : AppColors.kGrey,
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
                value: isNewsEnabled,
                onChanged: (value) {
                  setState(() {
                    isNewsEnabled = value;
                    if (isEnabledAll) {
                      isEnabledAll = value;
                    }
                  });
                },
                activeTrackColor:
                    isNewsEnabled ? AppColors.kButtonGreen : AppColors.kGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
