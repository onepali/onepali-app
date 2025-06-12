import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

RcmSongsModel rcmSongsModelFromJson(String str) =>
    RcmSongsModel.fromJson(json.decode(str));

String rcmSongsModelToJson(RcmSongsModel data) => json.encode(data.toJson());

class RcmSongsModel {
  final String childId;
  final String songId;
  final double progress;
  final Timestamp lastWatched;
  final int isCompleted;
  final String title;
  final String youtubeLink;
  final String image;

  RcmSongsModel({
    required this.childId,
    required this.songId,
    required this.progress,
    required this.lastWatched,
    required this.isCompleted,
    required this.title,
    required this.youtubeLink,
    required this.image,
  });

  factory RcmSongsModel.fromJson(Map<String, dynamic> json) => RcmSongsModel(
    childId: json["childId"] ?? "",
    songId: json["songId"] ?? "",
    progress: json["progress"]?.toDouble() ?? 0.0,
    lastWatched: json["lastWatched"] ?? Timestamp.now(),
    isCompleted: json["isCompleted"] ?? 0,
    title: json["title"] ?? "",
    youtubeLink: json["youtubeLink"] ?? "",
    image: json["image"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "songId": songId,
    "progress": progress,
    "lastWatched": lastWatched,
    "isCompleted": isCompleted,
    "title": title,
    "youtubeLink": youtubeLink,
    "image": image,
  };
}
