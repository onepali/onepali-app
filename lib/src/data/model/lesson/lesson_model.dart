import 'dart:convert';

LessonModel lessonModelFromJson(String str) =>
    LessonModel.fromJson(json.decode(str));

String lessonModelToJson(LessonModel data) => json.encode(data.toJson());

class LessonModel {
  final List<Category> categories;

  LessonModel({required this.categories});

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    categories: List<Category>.from(
      json["categories"].map((x) => Category.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  final int id;
  final String nameEn;
  final String nameNp;
  final String image;
  final String lottie;
  final List<Category> subcategories;
  final List<Lesson> lessons;
  final bool? soundAvailable;

  Category({
    required this.id,
    required this.nameEn,
    required this.nameNp,
    required this.image,
    required this.lottie,
    required this.subcategories,
    required this.lessons,
    this.soundAvailable,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] ?? 0,
    nameEn: json["name_en"] ?? "",
    nameNp: json["name_np"] ?? "",
    image: json["image"] ?? "",
    lottie: json["lottie"] ?? "",
    subcategories: List<Category>.from(
      (json["subcategories"] ?? []).map((x) => Category.fromJson(x)),
    ),
    lessons: List<Lesson>.from(
      (json["lessons"] ?? []).map((x) => Lesson.fromJson(x)),
    ),
    soundAvailable: json["sound_available"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_en": nameEn,
    "name_np": nameNp,
    "image": image,
    "lottie": lottie,
    "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
    "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
    "sound_available": soundAvailable,
  };
}

class Lesson {
  final int id;
  final String nameEn;
  final String nameNp;
  final String image;
  final String lottie;
  final String audio;
  final String wordAudio;
  final String progress;
  final String? type;
  final String? tooltip;

  Lesson({
    required this.id,
    required this.nameEn,
    required this.nameNp,
    required this.image,
    required this.lottie,
    required this.audio,
    required this.wordAudio,
    required this.progress,
    this.type,
    this.tooltip,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json["id"] ?? 0,
    nameEn: json["name_en"] ?? "",
    nameNp: json["name_np"] ?? "",
    image: json["image"] ?? "",
    lottie: json["lottie"] ?? "",
    audio: json["audio"] ?? "",
    wordAudio: json["word_audio"] ?? "",
    progress: json["progress"] ?? "",
    type: json["type"] ?? "",
    tooltip: json["tooltip"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_en": nameEn,
    "name_np": nameNp,
    "image": image,
    "lottie": lottie,
    "audio": audio,
    "word_audio": wordAudio,
    "progress": progress,
    "type": type,
    "tooltip": tooltip,
  };
}
