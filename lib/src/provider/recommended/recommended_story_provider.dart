import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class RecommendedStoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<RecommendedStoryModel> _recommendedStories = [];
  List<RecommendedStoryModel> get recommendedStories => _recommendedStories;

  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  bool _hasData = false;
  bool get hasData => _hasData;

  Future<void> fetchRecommendedStories() async {
    _status = DataFetchStatus.loading;
    _isSyncing = true;
    notifyListeners();
    final SharedPreferencesService prefs = SharedPreferencesService();
    final childId = await prefs.getStringPref(AppConstants.childIdKey) ?? '';
    logger.d('Fetching recommended stories for childId: $childId');

    if (childId.isEmpty) {
      logger.e('No childId found, skipping Firestore query.');
      _recommendedStories = [];
      _hasData = false;
      _status = DataFetchStatus.error;
      _isSyncing = false;
      notifyListeners();
      return;
    }

    try {
      final query = await _firestore
          .collection(AppConstants.recomStoryCollection)
          .where('childId', isEqualTo: childId)
          .orderBy('lastWatched', descending: true)
          .get();
      _recommendedStories = query.docs
          .map((doc) => RecommendedStoryModel.fromJson(doc.data()))
          .toList();
      _hasData = _recommendedStories.isNotEmpty;
      logger.d(
        'Fetched \\${_recommendedStories.length} recommended stories for childId: $childId',
      );
      _status = DataFetchStatus.success;
    } catch (e, stack) {
      logger.e(
        'Error fetching recommended stories for childId: $childId\\nError: $e\\nStack: $stack',
      );
      _recommendedStories = [];
      _hasData = false;
      _status = DataFetchStatus.error;
    }
    _isSyncing = false;
    notifyListeners();
  }

  Future<void> saveOrUpdateStoryProgress({
    required String childId,
    required String storyId,
    required int progress,
    required String title,
    required String image,
  }) async {
    final now = Timestamp.now();
    final docRef = _firestore
        .collection(AppConstants.recomStoryCollection)
        .doc('$childId-$storyId');
    await docRef.set({
      'childId': childId,
      'storyId': storyId,
      'progress': progress,
      'lastWatched': now,
      'title': title,
      'image': image,
    }, SetOptions(merge: true));
    await fetchRecommendedStories();
  }

  Future<void> removeStory(String childId, String storyId) async {
    await _firestore
        .collection(AppConstants.recomStoryCollection)
        .doc('$childId-$storyId')
        .delete();
    await fetchRecommendedStories();
  }

  void clear() {
    _recommendedStories = [];
    _hasData = false;
    notifyListeners();
  }
}
