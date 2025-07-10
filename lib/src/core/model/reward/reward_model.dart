import 'dart:convert';

List<RewardModel> rewardModelFromJson(String str) => List<RewardModel>.from(
  json.decode(str).map((x) => RewardModel.fromJson(x)),
);

String rewardModelToJson(List<RewardModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RewardModel {
  RewardModel({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.imageUrl,
  });

  int id;
  String name;
  String description;
  int points;
  String imageUrl;

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    points: json["points"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "points": points,
    "image_url": imageUrl,
  };
}
