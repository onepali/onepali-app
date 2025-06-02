import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RcmSongProvider extends ChangeNotifier {
  static Database? _db;
  static const String _tableName = 'recommended_songs';

  List<RcmSongsModel> _recommendedSongs = [];
  List<RcmSongsModel> get recommendedSongs => _recommendedSongs;

  Future<void> initDb() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, AppConstants.RECOM_DB_PATH),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id ${DBConstants.idType},
            songId ${DBConstants.textType},
            progress ${DBConstants.doubleType},
            lastWatched ${DBConstants.textType},
            isCompleted ${DBConstants.integerType},
            title ${DBConstants.textType},
            youtubeLink ${DBConstants.textType},
            image ${DBConstants.textType}
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> fetchRecommendedSongs() async {
    await initDb();
    final List<Map<String, dynamic>> maps = await _db!.rawQuery(
      'SELECT * FROM $_tableName WHERE id IN (SELECT MAX(id) FROM $_tableName GROUP BY songId) ORDER BY lastWatched DESC',
    );
    _recommendedSongs = maps.map((e) => RcmSongsModel.fromMap(e)).toList();
    logger.d(
      'RcmSongProvider: fetched ${jsonEncode(_recommendedSongs)} recommended songs',
    );
    notifyListeners();
  }

  Future<void> saveOrUpdateSongProgress({
    required String songId,
    required double progress,
    required bool isCompleted,
    required String title,
    required String youtubeLink,
    required String image,
  }) async {
    await initDb();
    final now = DateTime.now();
    final List<Map<String, dynamic>> existing = await _db!.query(
      _tableName,
      where: 'songId = ?',
      whereArgs: [songId],
    );
    if (existing.isNotEmpty) {
      // Update existing record
      logger.d(
        'RcmSongProvider: updating record for songId=$songId, progress=$progress, isCompleted=$isCompleted',
      );
      await _db!.update(
        _tableName,
        {
          'progress': progress,
          'lastWatched': now.toIso8601String(),
          'isCompleted': isCompleted ? 1 : 0,
          'title': title,
          'youtubeLink': youtubeLink,
          'image': image,
        },
        where: 'songId = ?',
        whereArgs: [songId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Insert new record
      logger.d(
        'RcmSongProvider: inserting new record for songId=$songId, progress=$progress, isCompleted=$isCompleted',
      );
      await _db!.insert(_tableName, {
        'songId': songId,
        'progress': progress,
        'lastWatched': now.toIso8601String(),
        'isCompleted': isCompleted ? 1 : 0,
        'title': title,
        'youtubeLink': youtubeLink,
        'image': image,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await fetchRecommendedSongs();
  }

  Future<void> removeSong(String songId) async {
    await initDb();
    await _db!.delete(_tableName, where: 'songId = ?', whereArgs: [songId]);
    await fetchRecommendedSongs();
  }

  Future<void> clearAll() async {
    await initDb();
    await _db!.delete(_tableName);
    await fetchRecommendedSongs();
  }

  @override
  void dispose() {
    _db?.close();
    super.dispose();
  }
}
