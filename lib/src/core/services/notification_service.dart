import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // Initialize FCM and local notifications
  static Future<void> initialize() async {
    // Local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap when app is in foreground/background
        // You can use response.payload for navigation or logic
        debugPrint('Notification tapped: \\${response.payload}');
      },
    );
    logPendingNotifications();

    // Request Android 13+ notification permission
    final androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    final androidPermission =
        await androidImplementation?.requestNotificationsPermission();
    debugPrint(
      '[NotificationService] Android notification permission: $androidPermission',
    );

    // Request exact alarm permission (Android 12+)
    final exactAlarmPermission =
        await androidImplementation?.requestExactAlarmsPermission();
    debugPrint(
      '[NotificationService] Exact alarm permission: $exactAlarmPermission',
    );

    // FCM permissions
    final fcmSettings = await _firebaseMessaging.requestPermission();
    debugPrint(
      '[NotificationService] FCM permission: ${fcmSettings.authorizationStatus}',
    );

    // FCM foreground handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification != null) {
        await showLocalNotification(
          notification.title,
          notification.body,
          payload: message.data['payload'],
        );
      }
    });

    // FCM background & terminated tap handler
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification tap when app is in background or terminated
      debugPrint('FCM notification tapped: \\${message.data}');
      // You can navigate or perform logic here
    });
  }

  // Show a local notification (with optional payload and sound)
  static Future<void> showLocalNotification(
    String? title,
    String? body, {
    String? payload,
    bool playSound = true,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'default_channel',
          'Default',
          channelDescription: 'Default channel for notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(
            'notification',
          ), // Place notification.mp3 in android/app/src/main/res/raw/
          showWhen: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Schedule a daily reminder notification at a specific time
  static Future<void> scheduleDailyReminder({
    required TimeOfDay time,
    required String title,
    required String body,
    String? payload,
  }) async {
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    final tz.TZDateTime tzScheduledDate =
        scheduledDate.isBefore(DateTime.now())
            ? tz.TZDateTime.from(
              scheduledDate.add(const Duration(days: 1)),
              tz.local,
            )
            : tz.TZDateTime.from(scheduledDate, tz.local);
    debugPrint(
      '[NotificationService] Scheduling daily reminder for: '
      '${tzScheduledDate.toString()} (tz: \\${tz.local.name})',
    );
    final androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminder',
      channelDescription: 'Channel for daily practice reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    final details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      tzScheduledDate,
      details,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    debugPrint(
      '[NotificationService] zonedSchedule called for notification at $tzScheduledDate',
    );
  }

  // Log pending notifications
  static Future<void> logPendingNotifications() async {
    final pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    debugPrint('[NotificationService] Pending notifications:');
    for (final n in pending) {
      debugPrint(
        '  id: ${n.id}, title: ${n.title}, body: ${n.body}, payload: ${n.payload}',
      );
    }
  }
}
