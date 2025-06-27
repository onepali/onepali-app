import 'package:flutter/material.dart';

import '../../../src.dart';

class PzNotificationProvider extends ChangeNotifier {
  NotificationSettings? _settings;
  List<NotificationTemplate> _notifications = [];
  final PzNotificationRepo _repo = PzNotificationRepo();
  bool _loading = false;

  NotificationSettings? get settings => _settings;
  List<NotificationTemplate> get notifications => _notifications;
  bool get loading => _loading;

  Future<void> getNotificationSetting() async {
    _loading = true;
    notifyListeners();
    _settings = await _repo.fetchNotificationSettings();
    _loading = false;
    notifyListeners();
    // Reschedule daily reminder if settings exist
    if (_settings != null &&
        _settings!.dailyReminderTime != null &&
        _settings!.dailyReminderTime!.isNotEmpty) {
      final t = TimeOfDay(
        hour: int.parse(_settings!.dailyReminderTime!.split(':')[0]),
        minute: int.parse(_settings!.dailyReminderTime!.split(':')[1]),
      );
      await NotificationService.scheduleDailyReminder(
        time: t,
        title: AppConstants.dailyReminderTitle,
        body: AppConstants.dailyReminderBody,
      );
      await NotificationService.logPendingNotifications();
    }
  }

  Future<void> getNotification() async {
    _notifications = await _repo.fetchNotificationTemplates();
    notifyListeners();
  }

  Future<void> updateSettings(NotificationSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await _repo.updateNotificationSettings(newSettings);
  }

  Future<void> ensureCollections() async {
    await _repo.ensureCollections();
  }

  void toggleAll(bool value) {
    if (_settings == null) return;
    final updated = _settings!.copyWith(
      isEnabledAll: value,
      isPracticeEnabled: value,
      isProgressReportEnabled: value,
      isNewsEnabled: value,
    );
    updateSettings(updated);
  }

  void togglePracticeReminder(bool value) {
    if (_settings == null) return;
    final updated = _settings!.copyWith(
      isPracticeEnabled: value,
      isEnabledAll:
          value &&
          _settings!.isProgressReportEnabled &&
          _settings!.isNewsEnabled,
    );
    updateSettings(updated);
  }

  void toggleProgressReport(bool value) {
    if (_settings == null) return;
    final updated = _settings!.copyWith(
      isProgressReportEnabled: value,
      isEnabledAll:
          value && _settings!.isPracticeEnabled && _settings!.isNewsEnabled,
    );
    updateSettings(updated);
  }

  void toggleNews(bool value) {
    if (_settings == null) return;
    final updated = _settings!.copyWith(
      isNewsEnabled: value,
      isEnabledAll:
          value &&
          _settings!.isPracticeEnabled &&
          _settings!.isProgressReportEnabled,
    );
    updateSettings(updated);
  }

  Future<void> updateDailyReminderTime(String time) async {
    if (_settings == null) return;
    final updated = _settings!.copyWith(dailyReminderTime: time);
    await updateSettings(updated);
    // Schedule the daily notification
    final t = TimeOfDay(
      hour: int.parse(time.split(':')[0]),
      minute: int.parse(time.split(':')[1]),
    );
    debugPrint('[UI] Scheduling daily reminder for $t');
    await NotificationService.scheduleDailyReminder(
      time: t,
      title: AppConstants.dailyReminderTitle,
      body: AppConstants.dailyReminderBody,
    );
  }
}
