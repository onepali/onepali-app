import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class RcmSongProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<RcmSongsModel> _recommendedSongs = [];
  List<RcmSongsModel> get recommendedSongs => _recommendedSongs;

  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  bool _hasData = false;
  bool get hasData => _hasData;

  Future<void> fetchRecommendedSongs() async {
    _status = DataFetchStatus.loading;
    _isSyncing = true;
    notifyListeners();
    final SharedPreferencesService prefs = SharedPreferencesService();
    final childId = await prefs.getStringPref(AppConstants.childIdKey) ?? '';
    logger.d('Fetching recommended songs for childId: $childId');

    if (childId.isEmpty) {
      logger.e('No childId found, skipping Firestore query.');
      _recommendedSongs = [];
      _hasData = false;
      _status = DataFetchStatus.error;
      _isSyncing = false;
      notifyListeners();
      return;
    }

    try {
      final query = await _firestore
          .collection(AppConstants.recomSongCollection)
          .where('childId', isEqualTo: childId)
          .orderBy('lastWatched', descending: true)
          .get();
      _recommendedSongs = query.docs
          .map((doc) => RcmSongsModel.fromJson(doc.data()))
          .toList();
      _hasData = _recommendedSongs.isNotEmpty;
      logger.d(
        'Fetched \\${_recommendedSongs.length} recommended songs for childId: $childId',
      );
      _status = DataFetchStatus.success;
    } catch (e, stack) {
      logger.e(
        'Error fetching recommended songs for childId: $childId\\nError: $e\\nStack: $stack',
      );
      _recommendedSongs = [];
      _hasData = false;
      _status = DataFetchStatus.error;
    }
    _isSyncing = false;
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
    final SharedPreferencesService prefs = SharedPreferencesService();
    final childId = await prefs.getStringPref(AppConstants.childIdKey) ?? '';
    if (childId.isEmpty) return;
    final now = Timestamp.now();
    final docRef = _firestore
        .collection(AppConstants.recomSongCollection)
        .doc('$childId-$songId');
    await docRef.set({
      'childId': childId,
      'songId': songId,
      'progress': progress,
      'lastWatched': now,
      'isCompleted': isCompleted ? 1 : 0,
      'title': title,
      'youtubeLink': youtubeLink,
      'image': image,
    }, SetOptions(merge: true));
    await fetchRecommendedSongs();
  }

  Future<void> removeSong(String songId) async {
    final SharedPreferencesService prefs = SharedPreferencesService();
    final childId = await prefs.getStringPref(AppConstants.childIdKey) ?? '';
    if (childId.isEmpty) return;
    await _firestore
        .collection(AppConstants.recomSongCollection)
        .doc('$childId-$songId')
        .delete();
    await fetchRecommendedSongs();
  }

  void clear() {
    _recommendedSongs = [];
    _hasData = false;
    notifyListeners();
  }
}
