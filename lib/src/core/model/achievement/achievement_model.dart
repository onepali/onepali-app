import 'package:flutter/material.dart';

class AchievementModel {
  final String id;
  final String title;
  final String subtitle;
  final String value;
  final String imageUrl;
  final Color? color;

  AchievementModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.imageUrl,
    this.color,
  });

  // fromJson
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'],
      title: json['title'] ?? "",
      subtitle: json['subtitle'] ?? "",
      value: json['value'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
    );
  }
}
