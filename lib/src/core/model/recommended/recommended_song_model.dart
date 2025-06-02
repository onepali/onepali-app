import 'dart:convert';

class RecommendedSongModel {
  final int? id;
  final String songId;
  final double progress;
  final DateTime lastWatched;
  final bool isCompleted;

  RecommendedSongModel({
    this.id,
    required this.songId,
    required this.progress,
    required this.lastWatched,
    required this.isCompleted,
  });

  factory RecommendedSongModel.fromMap(Map<String, dynamic> map) {
    return RecommendedSongModel(
      id: map['id'] as int?,
      songId: map['songId'] as String,
      progress: (map['progress'] as num).toDouble(),
      lastWatched: DateTime.parse(map['lastWatched'] as String),
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'songId': songId,
      'progress': progress,
      'lastWatched': lastWatched.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory RecommendedSongModel.fromJson(Map<String, dynamic> json) =>
      RecommendedSongModel(
        id: json["id"] as int?,
        songId: json["songId"] as String,
        progress: (json["progress"] as num).toDouble(),
        lastWatched: DateTime.parse(json["lastWatched"] as String),
        isCompleted: json["isCompleted"] == 1,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "songId": songId,
    "progress": progress,
    "lastWatched": lastWatched.toIso8601String(),
    "isCompleted": isCompleted ? 1 : 0,
  };

  static List<RecommendedSongModel> recommendedSongModelFromJson(String str) =>
      List<RecommendedSongModel>.from(
        (jsonDecode(str) as List).map((x) => RecommendedSongModel.fromJson(x)),
      );

  static String recommendedSongModelToJson(List<RecommendedSongModel> data) =>
      jsonEncode(List<dynamic>.from(data.map((x) => x.toJson())));
}
