import 'dart:convert';
import 'screen_time_model.dart';

List<ChildUserModel> childUserModelFromJson(String str) =>
    List<ChildUserModel>.from(
      json.decode(str).map((x) => ChildUserModel.fromJson(x)),
    );

String childUserModelToJson(List<ChildUserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChildUserModel {
  final String avatarUrl;
  final String createdAt;
  final String dob;
  final String fullName;
  final String parentEmail;
  final String parentUid;
  final String role;
  final double screenTime;
  final ScreenTimeModel? screenTimeTracking;
  final String uid;
  final CompletedLessons? completedLessons;

  ChildUserModel({
    required this.avatarUrl,
    required this.createdAt,
    required this.dob,
    required this.fullName,
    required this.parentEmail,
    required this.parentUid,
    required this.role,
    required this.screenTime,
    required this.uid,
    this.screenTimeTracking,
    this.completedLessons,
  });

  factory ChildUserModel.fromJson(Map<String, dynamic> json) => ChildUserModel(
    avatarUrl: json["avatar_url"] ?? "",
    createdAt: json["created_at"] ?? "",
    dob: json["dob"] ?? "",
    fullName: json["full_name"] ?? "",
    parentEmail: json["parent_email"] ?? "",
    parentUid: json["parent_uid"] ?? "",
    role: json["role"] ?? "",
    screenTime: (json["screen_time"] ?? 0).toDouble(),
    uid: json["uid"] ?? "",
    screenTimeTracking:
        json["screenTimeTracking"] != null
            ? ScreenTimeModel.fromJson(json["screenTimeTracking"])
            : null,
    completedLessons: _parseCompletedLessons(json),
  );

  /// Helper method to parse completed lessons from Firestore data
  static CompletedLessons? _parseCompletedLessons(Map<String, dynamic> json) {
    final totalLessonsCompleted = json["totalLessonsCompleted"] ?? 0;
    final lessonsData = json["completedLessons"];

    if (lessonsData != null) {
      List<CompletedLesson> lessons = [];

      if (lessonsData is List) {
        lessons =
            lessonsData.map((lessonData) {
              if (lessonData is Map<String, dynamic>) {
                return CompletedLesson.fromJson(lessonData);
              }
              return CompletedLesson(id: "", name: "");
            }).toList();
      } else if (lessonsData is Map<String, dynamic> &&
          lessonsData["lessons"] != null) {
        // Handle object format with lessons array
        lessons = List<CompletedLesson>.from(
          (lessonsData["lessons"] as List).map(
            (x) => CompletedLesson.fromJson(x),
          ),
        );
      }

      return CompletedLessons(
        totalLessonsCompleted: totalLessonsCompleted as int,
        lessons: lessons,
      );
    }

    return null;
  }

  Map<String, dynamic> toJson() => {
    "avatar_url": avatarUrl,
    "created_at": createdAt,
    "dob": dob,
    "full_name": fullName,
    "parent_email": parentEmail,
    "parent_uid": parentUid,
    "role": role,
    "screen_time": screenTime,
    "uid": uid,
    if (screenTimeTracking != null)
      "screenTimeTracking": screenTimeTracking!.toJson(),
    if (completedLessons != null)
      "completedLessons": completedLessons!.toJson(),
  };

  /// Get the current screen time tracking, creating a default one if null
  ScreenTimeModel getScreenTimeTracking() {
    return screenTimeTracking ??
        ScreenTimeModel(
          totalAllowed: screenTime,
          totalUsed: 0.0,
          lastUpdated: DateTime.now(),
        );
  }

  /// Create a copy with updated screen time tracking
  ChildUserModel copyWithScreenTime(ScreenTimeModel newScreenTimeTracking) {
    return ChildUserModel(
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      dob: dob,
      fullName: fullName,
      parentEmail: parentEmail,
      parentUid: parentUid,
      role: role,
      screenTime: screenTime,
      uid: uid,
      screenTimeTracking: newScreenTimeTracking,
      completedLessons: completedLessons,
    );
  }
}

class CompletedLessons {
  final int totalLessonsCompleted;
  final List<CompletedLesson> lessons;

  CompletedLessons({
    required this.totalLessonsCompleted,
    required this.lessons,
  });

  factory CompletedLessons.fromJson(Map<String, dynamic> json) =>
      CompletedLessons(
        totalLessonsCompleted: (json["totalLessonsCompleted"] ?? 0) as int,
        lessons:
            json["lessons"] != null
                ? List<CompletedLesson>.from(
                  (json["lessons"] as List).map(
                    (x) => CompletedLesson.fromJson(x),
                  ),
                )
                : [],
      );

  Map<String, dynamic> toJson() => {
    "totalLessonsCompleted": totalLessonsCompleted,
    "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
  };
}

class CompletedLesson {
  final String id;
  final String name;

  CompletedLesson({required this.id, required this.name});

  factory CompletedLesson.fromJson(Map<String, dynamic> json) =>
      CompletedLesson(id: json["id"] ?? "", name: json["name"] ?? "");

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
