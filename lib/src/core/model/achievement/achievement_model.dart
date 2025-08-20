import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class AchievementModel {
  final String id;
  final String title;
  final String value;
  final String imageUrl;
  final Color? color;

  AchievementModel({
    required this.id,
    required this.title,
    required this.value,
    required this.imageUrl,
    this.color,
  });

  // fromJson
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'],
      title: json['title'] ?? "",
      value: json['value'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
    );
  }
}

List<AchievementModel> achievementList = [
  AchievementModel(
    id: "1",
    title: "Practice Hero Trophy",
    value: "0",
    imageUrl: Assets.trophyAv,
    color: AppColors.kPureSkyBlue,
  ),
  AchievementModel(
    id: "2",
    title: "Learning Champion Medal",
    value: "0",
    imageUrl: Assets.medalAv,
    color: AppColors.kButtonRed,
  ),
  AchievementModel(
    id: "3",
    title: "Star Collector Badge",
    value: "0",
    imageUrl: Assets.starAv,
    color: AppColors.kButtonGreen,
  ),
];
