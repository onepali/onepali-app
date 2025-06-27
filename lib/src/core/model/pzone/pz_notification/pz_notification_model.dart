// NotificationSettings model
class NotificationSettings {
  final bool isEnabledAll;
  final bool isPracticeEnabled;
  final bool isProgressReportEnabled;
  final bool isNewsEnabled;
  final String? dailyReminderTime;

  NotificationSettings({
    required this.isEnabledAll,
    required this.isPracticeEnabled,
    required this.isProgressReportEnabled,
    required this.isNewsEnabled,
    this.dailyReminderTime,
  });

  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      isEnabledAll: map['isEnabledAll'] ?? false,
      isPracticeEnabled: map['isPracticeEnabled'] ?? false,
      isProgressReportEnabled: map['isProgressReportEnabled'] ?? false,
      isNewsEnabled: map['isNewsEnabled'] ?? false,
      dailyReminderTime: map['dailyReminderTime'] ?? "08:00",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isEnabledAll': isEnabledAll,
      'isPracticeEnabled': isPracticeEnabled,
      'isProgressReportEnabled': isProgressReportEnabled,
      'isNewsEnabled': isNewsEnabled,
      if (dailyReminderTime != null) 'dailyReminderTime': dailyReminderTime,
    };
  }

  NotificationSettings copyWith({
    bool? isEnabledAll,
    bool? isPracticeEnabled,
    bool? isProgressReportEnabled,
    bool? isNewsEnabled,
    String? dailyReminderTime,
  }) {
    return NotificationSettings(
      isEnabledAll: isEnabledAll ?? this.isEnabledAll,
      isPracticeEnabled: isPracticeEnabled ?? this.isPracticeEnabled,
      isProgressReportEnabled:
          isProgressReportEnabled ?? this.isProgressReportEnabled,
      isNewsEnabled: isNewsEnabled ?? this.isNewsEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
    );
  }
}

class NotificationTemplate {
  final String title;
  final String body;
  final String publishedDate;
  final bool seen;

  NotificationTemplate({
    required this.title,
    required this.body,
    required this.publishedDate,
    required this.seen,
  });

  factory NotificationTemplate.fromMap(Map<String, dynamic> map) {
    return NotificationTemplate(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      publishedDate: map['publishedDate'] ?? '',
      seen: map['seen'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'publishedDate': publishedDate,
      'seen': seen,
    };
  }
}
