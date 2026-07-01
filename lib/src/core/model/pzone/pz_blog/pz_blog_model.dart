import 'dart:convert';

List<PzBlogModel> pzBlogModelFromJson(String str) => List<PzBlogModel>.from(
  json.decode(str).map((x) => PzBlogModel.fromJson(x)),
);

String pzBlogModelToJson(List<PzBlogModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PzBlogModel {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String title;
  final String slug;
  final String content;
  final String coverImage;
  final int readTimeMinutes;
  final bool isDraft;
  final bool isFeatured;
  final int viewCount;
  final int likesCount;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;

  PzBlogModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.title,
    required this.slug,
    required this.content,
    required this.coverImage,
    required this.readTimeMinutes,
    required this.isDraft,
    required this.isFeatured,
    required this.viewCount,
    required this.likesCount,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory PzBlogModel.fromJson(Map<String, dynamic> json) => PzBlogModel(
    id: json["id"] ?? "",
    authorName: json["authorName"] ?? "",
    authorAvatar: json["authorAvatar"] ?? "",
    title: json["title"] ?? "",
    slug: json["slug"] ?? "",
    content: json["content"] ?? "",
    coverImage: json["coverImage"] ?? "",
    readTimeMinutes: json["readTimeMinutes"] ?? 0,
    isDraft: json["isDraft"] ?? false,
    isFeatured: json["isFeatured"] ?? false,
    viewCount: json["viewCount"] ?? 0,
    likesCount: json["likesCount"] ?? 0,
    tags: json["tags"] != null
        ? List<String>.from(json["tags"].map((x) => x ?? ""))
        : <String>[],
    createdAt: json["createdAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
    publishedAt: json["publishedAt"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "authorName": authorName,
    "authorAvatar": authorAvatar,
    "title": title,
    "slug": slug,
    "content": content,
    "coverImage": coverImage,
    "readTimeMinutes": readTimeMinutes,
    "isDraft": isDraft,
    "isFeatured": isFeatured,
    "viewCount": viewCount,
    "likesCount": likesCount,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "publishedAt": publishedAt,
  };

  PzBlogModel copyWith({
    String? id,
    String? authorName,
    String? authorAvatar,
    String? title,
    String? slug,
    String? content,
    String? coverImage,
    int? readTimeMinutes,
    bool? isDraft,
    bool? isFeatured,
    int? viewCount,
    int? likesCount,
    List<String>? tags,
    String? createdAt,
    String? updatedAt,
    String? publishedAt,
  }) {
    return PzBlogModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      content: content ?? this.content,
      coverImage: coverImage ?? this.coverImage,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      isDraft: isDraft ?? this.isDraft,
      isFeatured: isFeatured ?? this.isFeatured,
      viewCount: viewCount ?? this.viewCount,
      likesCount: likesCount ?? this.likesCount,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
