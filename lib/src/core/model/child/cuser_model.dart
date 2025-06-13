import 'dart:convert';

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
  final String uid;

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
  );

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
  };
}
