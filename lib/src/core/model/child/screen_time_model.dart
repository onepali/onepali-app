import 'package:cloud_firestore/cloud_firestore.dart';

class ScreenTimeModel {
  final double totalAllowed;
  final double totalUsed;
  final DateTime lastUpdated;

  ScreenTimeModel({
    required this.totalAllowed,
    required this.totalUsed,
    required this.lastUpdated,
  });

  factory ScreenTimeModel.fromJson(Map<String, dynamic> json) {
    final allowed = json['totalAllowed'] ?? json['totalScreenTime'] ?? 0;
    final used = json['totalUsed'] ?? 0;
    final lastUpdatedRaw = json['lastUpdated'];
    DateTime lastUpdated;
    if (lastUpdatedRaw == null) {
      lastUpdated = DateTime.now();
    } else if (lastUpdatedRaw is String) {
      lastUpdated = DateTime.tryParse(lastUpdatedRaw) ?? DateTime.now();
    } else if (lastUpdatedRaw is DateTime) {
      lastUpdated = lastUpdatedRaw;
    } else if (lastUpdatedRaw is Timestamp) {
      lastUpdated = lastUpdatedRaw.toDate();
    } else {
      lastUpdated = DateTime.now();
    }
    return ScreenTimeModel(
      totalAllowed: (allowed as num).toDouble(),
      totalUsed: (used as num).toDouble(),
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalAllowed': totalAllowed,
    'totalUsed': totalUsed,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  ScreenTimeModel copyWith({
    double? totalAllowed,
    double? totalUsed,
    DateTime? lastUpdated,
  }) {
    return ScreenTimeModel(
      totalAllowed: totalAllowed ?? this.totalAllowed,
      totalUsed: totalUsed ?? this.totalUsed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Check if screen time limit has been exceeded
  bool get isLimitExceeded => totalUsed >= totalAllowed;

  /// Get remaining screen time in minutes
  double get remainingTime => (totalAllowed - totalUsed).clamp(0, totalAllowed);

  /// Check if the screen time should be reset (if last update was on a different day)
  bool shouldReset() {
    final now = DateTime.now();
    final lastUpdateDate = DateTime(
      lastUpdated.year,
      lastUpdated.month,
      lastUpdated.day,
    );
    final currentDate = DateTime(now.year, now.month, now.day);

    return currentDate.isAfter(lastUpdateDate);
  }

  /// Reset screen time for a new day
  ScreenTimeModel resetForNewDay() {
    return copyWith(totalUsed: 0.0, lastUpdated: DateTime.now());
  }
}
