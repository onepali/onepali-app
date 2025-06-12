import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendedStoryModel {
  final String childId;
  final String storyId;
  final int progress;
  final Timestamp lastWatched;
  final String title;
  final String image;

  RecommendedStoryModel({
    required this.childId,
    required this.storyId,
    required this.progress,
    required this.lastWatched,
    required this.title,
    required this.image,
  });

  factory RecommendedStoryModel.fromJson(Map<String, dynamic> json) =>
      RecommendedStoryModel(
        childId: json['childId'] ?? '',
        storyId: json['storyId'] ?? '',
        progress: json['progress'] ?? 0,
        lastWatched: json['lastWatched'] ?? Timestamp.now(),
        title: json['title'] ?? '',
        image: json['image'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'childId': childId,
    'storyId': storyId,
    'progress': progress,
    'lastWatched': lastWatched,
    'title': title,
    'image': image,
  };
}
