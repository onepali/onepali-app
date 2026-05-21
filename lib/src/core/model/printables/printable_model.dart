import 'dart:convert';

List<PrintableModel> printableModelFromJson(String str) =>
    List<PrintableModel>.from(
      json.decode(str).map((x) => PrintableModel.fromJson(x)),
    );

String printableModelToJson(List<PrintableModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrintableModel {
  final String id;
  final String lessonId;
  final String chapterId;
  final String title;
  final String description;
  final String thumbnail;
  final int totalWorksheets;
  final List<PLesson> lessons;

  PrintableModel({
    required this.id,
    required this.lessonId,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.totalWorksheets,
    required this.lessons,
  });

  factory PrintableModel.fromJson(Map<String, dynamic> json) => PrintableModel(
    id: json["id"] ?? "",
    lessonId: json["lesson_id"] ?? "",
    chapterId: json["chapter_id"] ?? "",
    title: json["title"] ?? "",
    description: json["description"] ?? "",
    thumbnail: json["thumbnail"] ?? "",
    totalWorksheets: json["total_worksheets"] ?? 0,
    lessons: json["lessons"] == null
        ? []
        : List<PLesson>.from(json["lessons"].map((x) => PLesson.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lesson_id": lessonId,
    "chapter_id": chapterId,
    "title": title,
    "description": description,
    "thumbnail": thumbnail,
    "total_worksheets": totalWorksheets,
    "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
  };
}

class PLesson {
  final String id;
  final String title;
  final Worksheet worksheet;

  PLesson({required this.id, required this.title, required this.worksheet});

  factory PLesson.fromJson(Map<String, dynamic> json) => PLesson(
    id: json["id"] ?? "",
    title: json["title"] ?? "",
    worksheet: json["worksheet"] == null
        ? Worksheet(previewImage: "", pdfUrl: "", level: "")
        : Worksheet.fromJson(json["worksheet"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "worksheet": worksheet.toJson(),
  };
}

class Worksheet {
  final String previewImage;
  final String pdfUrl;
  final String level;

  Worksheet({
    required this.previewImage,
    required this.pdfUrl,
    required this.level,
  });

  factory Worksheet.fromJson(Map<String, dynamic> json) => Worksheet(
    previewImage: json["preview_image"] ?? "",
    pdfUrl: json["pdf_url"] ?? "",
    level: json["level"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "preview_image": previewImage,
    "pdf_url": pdfUrl,
    "level": level,
  };
}
