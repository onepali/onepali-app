import 'dart:convert';

CourseModel courseModelFromJson(String str) =>
    CourseModel.fromJson(json.decode(str));

String courseModelToJson(CourseModel data) => json.encode(data.toJson());

class CourseModel {
  final List<Course> courses;

  CourseModel({required this.courses});

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    courses: List<Course>.from(
      (json["courses"] ?? []).map((x) => Course.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
  };
}

class Course {
  final String id;
  final String nameEn;
  final String nameNp;
  final String thumbnail;
  final String audio;
  final String ageGroup;
  final String categoryName;
  final String type;
  final List<String> tags;
  final String completionCriteria;
  final List<Course> chapters;
  final List<Lesson> lessons;
  final LevelUnlockCriteria levelUnlockCriteria;

  Course({
    required this.id,
    required this.nameEn,
    required this.nameNp,
    required this.thumbnail,
    required this.audio,
    required this.ageGroup,
    required this.categoryName,
    required this.type,
    required this.tags,
    required this.completionCriteria,
    required this.chapters,
    required this.lessons,
    required this.levelUnlockCriteria,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"] ?? "",
    nameEn: json["name_en"] ?? "",
    nameNp: json["name_np"] ?? "",
    thumbnail: json["thumbnail"] ?? "",
    audio: json["audio"] ?? "",
    ageGroup: json["age_group"] ?? "",
    categoryName: json["categoryName"] ?? "",
    type: json["type"] ?? "",
    tags: List<String>.from((json["tags"] ?? []).map((x) => x ?? "")),
    completionCriteria: json["completion_criteria"] ?? "",
    chapters: List<Course>.from(
      (json["chapters"] ?? []).map((x) => Course.fromJson(x)),
    ),
    lessons: List<Lesson>.from(
      (json["lessons"] ?? []).map((x) => Lesson.fromJson(x)),
    ),
    levelUnlockCriteria: LevelUnlockCriteria.fromJson(
      json["level_unlock_criteria"] ?? {},
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_en": nameEn,
    "name_np": nameNp,
    "thumbnail": thumbnail,
    "audio": audio,
    "age_group": ageGroup,
    "categoryName": categoryName,
    "type": type,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "completion_criteria": completionCriteria,
    "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
    "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
    "level_unlock_criteria": levelUnlockCriteria.toJson(),
  };
}

class Lesson {
  final String id;
  final String chapterId;
  final String lessonName;
  final String shortInfo;
  final String type;
  final String progress;
  final String completionCriteria;
  final String thumbnail;
  final int rank;
  final List<String> prerequisites;
  final List<LessonContent> lessonContent;

  Lesson({
    required this.id,
    required this.chapterId,
    required this.lessonName,
    required this.shortInfo,
    required this.type,
    required this.progress,
    required this.completionCriteria,
    required this.thumbnail,
    required this.rank,
    required this.prerequisites,
    required this.lessonContent,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json["id"] ?? "",
    chapterId: json["chapter_id"] ?? "",
    lessonName: json["lesson_name"] ?? "",
    shortInfo: json["short_info"] ?? "",
    type: json["type"] ?? "",
    progress: json["progress"] ?? "",
    completionCriteria: json["completion_criteria"] ?? "",
    thumbnail: json["thumbnail"] ?? "",
    rank: json["rank"] ?? 0,
    prerequisites: List<String>.from(
      (json["prerequisites"] ?? []).map((x) => x ?? ""),
    ),
    lessonContent: List<LessonContent>.from(
      (json["lesson_content"] ?? []).map((x) => LessonContent.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chapter_id": chapterId,
    "lesson_name": lessonName,
    "short_info": shortInfo,
    "type": type,
    "progress": progress,
    "completion_criteria": completionCriteria,
    "thumbnail": thumbnail,
    "rank": rank,
    "prerequisites": List<dynamic>.from(prerequisites.map((x) => x)),
    "lesson_content": List<dynamic>.from(lessonContent.map((x) => x.toJson())),
  };
}

class LessonContent {
  final String nameEn;
  final String nameNp;
  final String image;
  final String lottie;
  final String audio;
  final String wordAudio;
  final String tooltip;

  LessonContent({
    required this.nameEn,
    required this.nameNp,
    required this.image,
    required this.lottie,
    required this.audio,
    required this.wordAudio,
    required this.tooltip,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) => LessonContent(
    nameEn: json["name_en"] ?? "",
    nameNp: json["name_np"] ?? "",
    image: json["image"] ?? "",
    lottie: json["lottie"] ?? "",
    audio: json["audio"] ?? "",
    wordAudio: json["word_audio"] ?? "",
    tooltip: json["tooltip"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name_en": nameEn,
    "name_np": nameNp,
    "image": image,
    "lottie": lottie,
    "audio": audio,
    "word_audio": wordAudio,
    "tooltip": tooltip,
  };
}

class LevelUnlockCriteria {
  final String type;
  final int value;
  final String description;

  LevelUnlockCriteria({
    required this.type,
    required this.value,
    required this.description,
  });

  factory LevelUnlockCriteria.fromJson(Map<String, dynamic> json) =>
      LevelUnlockCriteria(
        type: json["type"] ?? "",
        value: json["value"] ?? 0,
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "type": type,
    "value": value,
    "description": description,
  };
}
