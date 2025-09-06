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
  final LevelUnlockCriteria? levelUnlockCriteria;

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
    this.levelUnlockCriteria,
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
    levelUnlockCriteria:
        json["level_unlock_criteria"] != null
            ? LevelUnlockCriteria.fromJson(json["level_unlock_criteria"])
            : null,
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
    if (levelUnlockCriteria != null)
      "level_unlock_criteria": levelUnlockCriteria!.toJson(),
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
  final String? nameEn;
  final String? nameNp;
  final dynamic image;
  final String? lottie;
  final dynamic audio;
  final String? wordAudio;
  final String? tooltip;
  final String? correctAnswer;
  final String? type;
  final dynamic color;
  final dynamic textColor;
  final String? stepId;
  final String? text;
  final String? mbImage;
  final String? tbImage;
  final List<TapTarget>? tapTargets;
  final String? correctAnswerId;
  final Feedback? feedback;
  final List<DragTargets>? dragTargets;
  final List<String>? correctAnswerIds;

  LessonContent({
    this.nameEn,
    this.nameNp,
    this.image,
    this.lottie,
    this.audio,
    this.wordAudio,
    this.tooltip,
    this.correctAnswer,
    this.type,
    this.color,
    this.textColor,
    this.stepId,
    this.text,
    this.mbImage,
    this.tbImage,
    this.tapTargets,
    this.correctAnswerId,
    this.feedback,
    this.dragTargets,
    this.correctAnswerIds,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) => LessonContent(
    nameEn: json["name_en"] ?? "",
    nameNp: json["name_np"] ?? "",
    image: json["image"] ?? "",
    lottie: json["lottie"] ?? "",
    audio: json["audio"] ?? "",
    wordAudio: json["word_audio"] ?? "",
    tooltip: json["tooltip"] ?? "",
    correctAnswer: json["correct_answer"] ?? "",
    type: json["type"] ?? "",
    color: json["color"] ?? "",
    textColor: json["text_color"] ?? "",
    stepId: json["step_id"] ?? "",
    text: json["text"] ?? "",
    mbImage: json["mb_image"] ?? "",
    tbImage: json["tb_image"] ?? "",
    tapTargets:
        json["tap_targets"] != null
            ? List<TapTarget>.from(
              json["tap_targets"].map((x) => TapTarget.fromJson(x)),
            )
            : null,
    correctAnswerId: json["correct_answer_id"] ?? "",
    feedback:
        json["feedback"] != null ? Feedback.fromJson(json["feedback"]) : null,
    dragTargets:
        json["drag_targets"] != null
            ? List<DragTargets>.from(
              json["drag_targets"].map((x) => DragTargets.fromJson(x)),
            )
            : null,
    correctAnswerIds:
        json["correct_answer_ids"] != null
            ? List<String>.from(json["correct_answer_ids"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    if (nameEn != null) "name_en": nameEn,
    if (nameNp != null) "name_np": nameNp,
    if (image != null) "image": image,
    if (lottie != null) "lottie": lottie,
    if (audio != null) "audio": audio,
    if (wordAudio != null) "word_audio": wordAudio,
    if (tooltip != null) "tooltip": tooltip,
    if (correctAnswer != null) "correct_answer": correctAnswer,
    if (type != null) "type": type,
    if (color != null) "color": color,
    if (textColor != null) "text_color": textColor,
    if (stepId != null) "step_id": stepId,
    if (text != null) "text": text,
    if (mbImage != null) "mb_image": mbImage,
    if (tbImage != null) "tb_image": tbImage,
    if (tapTargets != null)
      "tap_targets": List<dynamic>.from(tapTargets!.map((x) => x.toJson())),
    if (correctAnswerId != null) "correct_answer_id": correctAnswerId,
    if (feedback != null) "feedback": feedback!.toJson(),
    if (dragTargets != null)
      "drag_targets": List<dynamic>.from(dragTargets!.map((x) => x.toJson())),
    if (correctAnswerIds != null)
      "correct_answer_ids": List<dynamic>.from(correctAnswerIds!.map((x) => x)),
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

class TapTarget {
  final String? id;
  final String? nameEn;
  final String? nameNp;
  final String? image;
  final String? audio;

  TapTarget({this.id, this.nameEn, this.nameNp, this.image, this.audio});

  factory TapTarget.fromJson(Map<String, dynamic> json) => TapTarget(
    id: json["id"] ?? "",
    nameEn: json["name_en"] ?? "",
    nameNp: json["name_np"] ?? "",
    image: json["image"] ?? "",
    audio: json["audio"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    if (nameEn != null) "name_en": nameEn,
    if (nameNp != null) "name_np": nameNp,
    if (image != null) "image": image,
    if (audio != null) "audio": audio,
  };
}

class DragTargets {
  final String? id;
  final String? nameEn;
  final String? nameNp;
  final String? image;
  final String? imageOutline;
  final String? audio;
  final String? wordAudio;

  DragTargets({
    this.id,
    this.nameEn,
    this.nameNp,
    this.image,
    this.imageOutline,
    this.audio,
    this.wordAudio,
  });

  factory DragTargets.fromJson(Map<String, dynamic> json) => DragTargets(
    id: json["id"] ?? "",
    nameEn: json["name_en"] ?? "",
    nameNp: json["name_np"] ?? "",
    image: json["image"] ?? "",
    imageOutline: json["image_outline"] ?? "",
    audio: json["audio"] ?? "",
    wordAudio: json["word_audio"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    if (nameEn != null) "name_en": nameEn,
    if (nameNp != null) "name_np": nameNp,
    if (image != null) "image": image,
    if (imageOutline != null) "image_outline": imageOutline,
    if (audio != null) "audio": audio,
    if (wordAudio != null) "word_audio": wordAudio,
  };
}

class Feedback {
  final FeedbackDetails? correct;
  final FeedbackDetails? incorrect;
  final int? reminderAfterAttempts;
  final bool? confettiOnComplete;

  Feedback({
    this.correct,
    this.incorrect,
    this.reminderAfterAttempts,
    this.confettiOnComplete,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    correct:
        json["correct"] != null
            ? FeedbackDetails.fromJson(json["correct"])
            : null,
    incorrect:
        json["incorrect"] != null
            ? FeedbackDetails.fromJson(json["incorrect"])
            : null,
    reminderAfterAttempts: json["reminder_after_attempts"] ?? 0,
    confettiOnComplete: json["confetti_on_complete"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    if (correct != null) "correct": correct!.toJson(),
    if (incorrect != null) "incorrect": incorrect!.toJson(),
    if (reminderAfterAttempts != null)
      "reminder_after_attempts": reminderAfterAttempts,
    if (confettiOnComplete != null) "confetti_on_complete": confettiOnComplete,
  };
}

class FeedbackDetails {
  final String? audio;
  final String? text;
  final String? wordAudio;
  final String? animation;
  final bool? resetSticker;
  final bool? showVocabBox;

  FeedbackDetails({
    this.audio,
    this.text,
    this.wordAudio,
    this.animation,
    this.resetSticker,
    this.showVocabBox,
  });

  factory FeedbackDetails.fromJson(Map<String, dynamic> json) =>
      FeedbackDetails(
        audio: json["audio"] ?? "",
        text: json["text"] ?? "",
        wordAudio: json["word_audio"] ?? "",
        animation: json["animation"] ?? "",
        resetSticker: json["reset_sticker"] ?? false,
        showVocabBox: json["show_vocab_box"] ?? false,
      );

  Map<String, dynamic> toJson() => {
    if (audio != null) "audio": audio,
    if (text != null) "text": text,
    if (wordAudio != null) "word_audio": wordAudio,
    if (animation != null) "animation": animation,
    if (resetSticker != null) "reset_sticker": resetSticker,
    if (showVocabBox != null) "show_vocab_box": showVocabBox,
  };
}
