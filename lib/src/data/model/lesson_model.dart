import 'dart:convert';

List<LessonModel> lessonModelFromJson(String str) => List<LessonModel>.from(
  json.decode(str).map((x) => LessonModel.fromJson(x)),
);

String lessonModelToJson(List<LessonModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LessonModel {
  final int id;
  final String nepaliName;
  final String englishName;
  final String image;
  final String lottie;
  final String audio;
  final String wordAudio;

  LessonModel({
    required this.id,
    required this.nepaliName,
    required this.englishName,
    required this.image,
    required this.lottie,
    required this.audio,
    required this.wordAudio,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    id: json["id"],
    nepaliName: json["nepali_name"],
    englishName: json["english_name"],
    image: json["image"],
    lottie: json["lottie"],
    audio: json["audio"],
    wordAudio: json["word_audio"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nepali_name": nepaliName,
    "english_name": englishName,
    "image": image,
    "lottie": lottie,
    "audio": audio,
    "word_audio": wordAudio,
  };
}
