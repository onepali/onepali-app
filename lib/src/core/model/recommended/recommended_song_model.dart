class RecommendedSongModel {
  final int? id;
  final String songId;
  final double progress;
  final DateTime lastWatched;
  final bool isCompleted;

  RecommendedSongModel({
    this.id,
    required this.songId,
    required this.progress,
    required this.lastWatched,
    required this.isCompleted,
  });

  factory RecommendedSongModel.fromMap(Map<String, dynamic> map) {
    return RecommendedSongModel(
      id: map['id'] as int?,
      songId: map['songId'] as String,
      progress: map['progress'] as double,
      lastWatched: DateTime.parse(map['lastWatched'] as String),
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'songId': songId,
      'progress': progress,
      'lastWatched': lastWatched.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
