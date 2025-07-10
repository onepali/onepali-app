import 'dart:convert';

List<RewardModel> rewardModelFromJson(String str) => List<RewardModel>.from(
  json.decode(str).map((x) => RewardModel.fromJson(x)),
);

String rewardModelToJson(List<RewardModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RewardModel {
  final String id;
  final String titleNp;
  final String titleEn;
  final String descriptionNp;
  final String descriptionEn;
  final String sAudio;
  final String image;

  RewardModel({
    required this.id,
    required this.titleNp,
    required this.titleEn,
    required this.descriptionNp,
    required this.descriptionEn,
    required this.sAudio,
    required this.image,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
    id: json["id"] ?? "",
    titleNp: json["title_np"] ?? "",
    titleEn: json["title_en"] ?? "",
    descriptionNp: json["description_np"] ?? "",
    descriptionEn: json["description_en"] ?? "",
    sAudio: json["s_audio"] ?? "",
    image: json["image"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title_np": titleNp,
    "title_en": titleEn,
    "description_np": descriptionNp,
    "description_en": descriptionEn,
    "s_audio": sAudio,
    "image": image,
  };
}
