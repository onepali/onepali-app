import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendedLessonModel {
  final String childId;
  final String lessonId;
  final int progress;
  final Timestamp lastWatched;
  final String title;
  final String image;

  RecommendedLessonModel({
    required this.childId,
    required this.lessonId,
    required this.progress,
    required this.lastWatched,
    required this.title,
    required this.image,
  });

  factory RecommendedLessonModel.fromJson(Map<String, dynamic> json) =>
      RecommendedLessonModel(
        childId: json['childId'] ?? '',
        lessonId: json['lessonId'] ?? '',
        progress: json['progress'] ?? 0,
        lastWatched: json['lastWatched'] ?? Timestamp.now(),
        title: json['title'] ?? '',
        image: json['image'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'childId': childId,
    'lessonId': lessonId,
    'progress': progress,
    'lastWatched': lastWatched,
    'title': title,
    'image': image,
  };
}
