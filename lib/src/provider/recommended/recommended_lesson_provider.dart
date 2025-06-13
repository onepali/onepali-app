import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class RecommendedLessonProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<RecommendedLessonModel> _recommendedLessons = [];
  List<RecommendedLessonModel> get recommendedLessons => _recommendedLessons;

  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Future<void> fetchRecommendedLessons() async {
    logger.d('fetchRecommendedLessons called');
    _status = DataFetchStatus.loading;
    _isSyncing = true;
    notifyListeners();
    final SharedPreferencesService prefs = SharedPreferencesService();
    final childId = await prefs.getStringPref(AppConstants.childIdKey) ?? '';
    logger.d('Fetching recommended lessons for childId: $childId');

    if (childId.isEmpty) {
      logger.e('No childId found, skipping Firestore query.');
      _recommendedLessons = [];
      _status = DataFetchStatus.error;
      _isSyncing = false;
      notifyListeners();
      return;
    }

    try {
      final query =
          await _firestore
              .collection(AppConstants.recomLessonCollection)
              .where('childId', isEqualTo: childId)
              .get();
      _recommendedLessons =
          query.docs
              .map((doc) => RecommendedLessonModel.fromJson(doc.data()))
              .toList();
      logger.d('Fetched ${_recommendedLessons.length} recommended lessons');
      _status = DataFetchStatus.success;
    } catch (e, stack) {
      logger.e('Error fetching recommended lessons: $e\n$stack');
      _recommendedLessons = [];
      _status = DataFetchStatus.error;
    }
    _isSyncing = false;
    notifyListeners();
  }

  Future<void> saveOrUpdateLessonProgress({
    required String childId,
    required String lessonId,
    required int progress,
    required String title,
    required String image,
  }) async {
    final now = Timestamp.now();
    final docRef = _firestore
        .collection(AppConstants.recomLessonCollection)
        .doc('$childId-$lessonId');
    await docRef.set({
      'childId': childId,
      'lessonId': lessonId,
      'progress': progress,
      'lastWatched': now,
      'title': title,
      'image': image,
    }, SetOptions(merge: true));
    await fetchRecommendedLessons();
  }

  Future<void> removeLesson(String childId, String lessonId) async {
    await _firestore
        .collection(AppConstants.recomLessonCollection)
        .doc('$childId-$lessonId')
        .delete();
    await fetchRecommendedLessons();
  }

  void clear() {
    _recommendedLessons = [];
    notifyListeners();
  }
}
