import 'dart:convert';

RcmSongsModel rcmSongsModelFromJson(String str) =>
    RcmSongsModel.fromJson(json.decode(str));

String rcmSongsModelToJson(RcmSongsModel data) => json.encode(data.toJson());

class RcmSongsModel {
  final int id;
  final String songId;
  final double progress;
  final String lastWatched;
  final int isCompleted;
  final String title;
  final String youtubeLink;
  final String image;

  RcmSongsModel({
    required this.id,
    required this.songId,
    required this.progress,
    required this.lastWatched,
    required this.isCompleted,
    required this.title,
    required this.youtubeLink,
    required this.image,
  });

  factory RcmSongsModel.fromJson(Map<String, dynamic> json) => RcmSongsModel(
    id: json["id"] ?? 0,
    songId: json["songId"] ?? "",
    progress: json["progress"]?.toDouble() ?? 0.0,
    lastWatched: json["lastWatched"] ?? "",
    isCompleted: json["isCompleted"] ?? 0,
    title: json["title"] ?? "",
    youtubeLink: json["youtubeLink"] ?? "",
    image: json["image"] ?? "",
  );

  factory RcmSongsModel.fromMap(Map<String, dynamic> map) => RcmSongsModel(
    id: map["id"] ?? 0,
    songId: map["songId"] ?? "",
    progress: map["progress"]?.toDouble() ?? 0.0,
    lastWatched: map["lastWatched"] ?? "",
    isCompleted: map["isCompleted"] ?? 0,
    title: map["title"] ?? "",
    youtubeLink: map["youtubeLink"] ?? "",
    image: map["image"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "songId": songId,
    "progress": progress,
    "lastWatched": lastWatched,
    "isCompleted": isCompleted,
    "title": title,
    "youtubeLink": youtubeLink,
    "image": image,
  };
}
