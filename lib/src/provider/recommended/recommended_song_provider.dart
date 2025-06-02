import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecommendedSongProvider extends ChangeNotifier {
  static Database? _db;
  static const String _tableName = 'recommended_songs';

  List<RecommendedSongModel> _recommendedSongs = [];
  List<RecommendedSongModel> get recommendedSongs => _recommendedSongs;

  Future<void> initDb() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'recommended_songs.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            songId TEXT,
            progress REAL,
            lastWatched TEXT,
            isCompleted INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> fetchRecommendedSongs() async {
    await initDb();
    // Fetch only the latest entry for each unique songId
    final List<Map<String, dynamic>> maps = await _db!.rawQuery(
      'SELECT * FROM $_tableName WHERE id IN (SELECT MAX(id) FROM $_tableName GROUP BY songId) ORDER BY lastWatched DESC',
    );
    _recommendedSongs =
        maps.map((e) => RecommendedSongModel.fromMap(e)).toList();
    logger.d(
      'RecommendedSongProvider: fetched ${_recommendedSongs.length} recommended songs',
    );
    notifyListeners();
  }

  Future<void> saveOrUpdateSongProgress({
    required String songId,
    required double progress,
    required bool isCompleted,
  }) async {
    await initDb();
    final now = DateTime.now();
    await _db!.insert(_tableName, {
      'songId': songId,
      'progress': progress,
      'lastWatched': now.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    });
    await fetchRecommendedSongs();
  }

  Future<void> removeSong(String songId) async {
    await initDb();
    await _db!.delete(_tableName, where: 'songId = ?', whereArgs: [songId]);
    await fetchRecommendedSongs();
  }

  @override
  void dispose() {
    _db?.close();
    super.dispose();
  }
}
