import 'package:flutter/material.dart';

import '../../../src.dart';

class PzNotificationProvider extends ChangeNotifier {
  NotificationSettings? _settings;
  List<NotificationTemplate> _notifications = [];
  final PzNotificationRepo _repo = PzNotificationRepo();
  DataFetchStatus _status = DataFetchStatus.initial;

  NotificationSettings? get settings => _settings;
  List<NotificationTemplate> get notifications => _notifications;
  DataFetchStatus get status => _status;

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> getNotificationSetting() async {
    setStatus(DataFetchStatus.loading);
    try {
      _settings = await _repo.fetchNotificationSettings();
      setStatus(DataFetchStatus.success);
      if (_settings != null &&
          _settings!.dailyReminderTime != null &&
          _settings!.dailyReminderTime!.isNotEmpty) {
        final t = TimeOfDay(
          hour: int.parse(_settings!.dailyReminderTime!.split(':')[0]),
          minute: int.parse(_settings!.dailyReminderTime!.split(':')[1]),
        );
        try {
          await NotificationService.scheduleDailyReminder(
            time: t,
            title: AppConstants.dailyReminderTitle,
            body: AppConstants.dailyReminderBody,
          );
          await NotificationService.logPendingNotifications();
        } catch (e) {
          logger.w(
            'Could not schedule notification (permissions may not be granted): $e',
          );
        }
      }
    } catch (e) {
      logger.e('Error fetching notification settings: $e');
      setStatus(DataFetchStatus.error);
      showCustomToaster('Failed to load notification settings', isError: true);
    }
  }

  Future<void> getNotification() async {
    try {
      _notifications = await _repo.fetchNotificationTemplates();
      notifyListeners();
    } catch (e) {
      logger.e('Error fetching notifications: $e');
      showCustomToaster('Failed to load notifications', isError: true);
    }
  }

  Future<void> updateSettings(NotificationSettings newSettings) async {
    try {
      _settings = newSettings;
      notifyListeners();
      await _repo.updateNotificationSettings(newSettings);
    } catch (e) {
      logger.e('Error updating notification settings: $e');
      showCustomToaster('Failed to update settings', isError: true);
    }
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
    try {
      final updated = _settings!.copyWith(dailyReminderTime: time);
      await updateSettings(updated);
      // Schedule the daily notification
      final t = TimeOfDay(
        hour: int.parse(time.split(':')[0]),
        minute: int.parse(time.split(':')[1]),
      );
      debugPrint('[UI] Scheduling daily reminder for $t');
      try {
        await NotificationService.scheduleDailyReminder(
          time: t,
          title: AppConstants.dailyReminderTitle,
          body: AppConstants.dailyReminderBody,
        );
      } catch (e) {
        logger.w(
          'Could not schedule notification (permissions may not be granted): $e',
        );
        showCustomToaster(
          'Reminder saved, but notification permissions may be needed',
          isError: false,
        );
      }
    } catch (e) {
      logger.e('Error updating daily reminder time: $e');
      showCustomToaster('Failed to update reminder time', isError: true);
    }
  }
}
