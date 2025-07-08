class ScreenTimeModel {
  final double totalAllowed; // Total screen time allowed in minutes
  final double totalUsed; // Total screen time used today in minutes
  final DateTime lastUpdated; // Last time the screen time was updated

  ScreenTimeModel({
    required this.totalAllowed,
    required this.totalUsed,
    required this.lastUpdated,
  });

  factory ScreenTimeModel.fromJson(Map<String, dynamic> json) {
    return ScreenTimeModel(
      totalAllowed: (json['totalScreenTime'] ?? 0).toDouble(),
      totalUsed: (json['totalUsed'] ?? 0).toDouble(),
      lastUpdated:
          json['lastUpdated'] != null
              ? DateTime.parse(json['lastUpdated'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalScreenTime': totalAllowed,
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
