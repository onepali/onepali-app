import 'dart:convert';

List<SongModel> songModelFromJson(String str) =>
    List<SongModel>.from(json.decode(str).map((x) => SongModel.fromJson(x)));

String songModelToJson(List<SongModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SongModel {
  final String id;
  final String titleEn;
  final String titleNe;
  final String youtubeTitleEn;
  final String youtubeTitleNe;
  final String ageGroup;
  final String type;
  final List<String> language;
  final Media media;
  final int rank;
  final List<String> tags;
  final String categoryName;

  SongModel({
    required this.id,
    required this.titleEn,
    required this.titleNe,
    required this.youtubeTitleEn,
    required this.youtubeTitleNe,
    required this.ageGroup,
    required this.type,
    required this.language,
    required this.media,
    required this.rank,
    required this.tags,
    required this.categoryName,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
    id: json["id"] ?? '',
    titleEn: json["title_en"] ?? '',
    titleNe: json["title_ne"] ?? '',
    youtubeTitleEn: json["youtube_title_en"] ?? '',
    youtubeTitleNe: json["youtube_title_ne"] ?? '',
    ageGroup: json["age_group"] ?? '',
    type: json["type"] ?? '',
    language: json["language"] != null
        ? List<String>.from(json["language"].map((x) => x ?? ''))
        : <String>[],
    media: json["media"] != null
        ? Media.fromJson(json["media"])
        : Media(youtubeLink: ''),
    rank: json["rank"] ?? 0,
    tags: json["tags"] != null
        ? List<String>.from(json["tags"].map((x) => x ?? ''))
        : <String>[],
    categoryName: json["categoryName"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title_en": titleEn,
    "title_ne": titleNe,
    "youtube_title_en": youtubeTitleEn,
    "youtube_title_ne": youtubeTitleNe,
    "age_group": ageGroup,
    "type": type,
    "language": List<dynamic>.from(language.map((x) => x)),
    "media": media.toJson(),
    "rank": rank,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "categoryName": categoryName,
  };
}

class Media {
  final String youtubeLink;

  Media({required this.youtubeLink});

  factory Media.fromJson(Map<String, dynamic> json) =>
      Media(youtubeLink: json["youtube_link"] ?? '');

  Map<String, dynamic> toJson() => {"youtube_link": youtubeLink};
}
