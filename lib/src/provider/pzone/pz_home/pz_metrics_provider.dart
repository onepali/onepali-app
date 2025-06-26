import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/model/pzone/pz_home/pz_home_metrics_model.dart';
import '../../../core/enums/app_enums.dart';

class PzMetricsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PzHomeMetricsModel? _metrics;
  DataFetchStatus _status = DataFetchStatus.initial;

  PzHomeMetricsModel? get metrics => _metrics;
  DataFetchStatus get status => _status;

  Future<void> fetchMetrics({
    required String parentUid,
    required String childUid,
  }) async {
    _status = DataFetchStatus.loading;
    notifyListeners();
    try {
      final doc =
          await _firestore
              .collection('users')
              .doc(parentUid)
              .collection('children')
              .doc(childUid)
              .get();

      if (doc.exists && doc.data()?['metrics'] != null) {
        // Metrics exist, load them
        _metrics = PzHomeMetricsModel.fromJson(doc.data()?['metrics']);
      } else {
        // Metrics don't exist, create default metrics using updateMetrics
        final defaultMetrics = PzHomeMetricsModel.fromJson(null);
        await updateMetrics(
          parentUid: parentUid,
          childUid: childUid,
          newMetrics: defaultMetrics,
        );
        return;
      }

      _status = DataFetchStatus.success;
    } catch (e) {
      _metrics = null;
      _status = DataFetchStatus.error;
    }
    notifyListeners();
  }

  Future<void> updateMetrics({
    required String parentUid,
    required String childUid,
    required PzHomeMetricsModel newMetrics,
  }) async {
    _status = DataFetchStatus.loading;
    notifyListeners();
    try {
      await _firestore
          .collection('users')
          .doc(parentUid)
          .collection('children')
          .doc(childUid)
          .update({
            'metrics': {
              'completedActivities': newMetrics.completedActivities,
              'answerSuccessRate': newMetrics.answerSuccessRate,
              'dayStreak': newMetrics.dayStreak,
              'weeklyStreak': newMetrics.weeklyStreak,
              'averageDailyLearningTime': newMetrics.averageDailyLearningTime,
              'mostPracticedTopics': newMetrics.mostPracticedTopics,
            },
          });
      _metrics = newMetrics;
      _status = DataFetchStatus.success;
    } catch (e) {
      // If update fails (document or metrics field doesn't exist), create it with set
      try {
        await _firestore
            .collection('users')
            .doc(parentUid)
            .collection('children')
            .doc(childUid)
            .set({
              'metrics': {
                'completedActivities': newMetrics.completedActivities,
                'answerSuccessRate': newMetrics.answerSuccessRate,
                'dayStreak': newMetrics.dayStreak,
                'weeklyStreak': newMetrics.weeklyStreak,
                'averageDailyLearningTime': newMetrics.averageDailyLearningTime,
                'mostPracticedTopics': newMetrics.mostPracticedTopics,
              },
            }, SetOptions(merge: true));
        _metrics = newMetrics;
        _status = DataFetchStatus.success;
      } catch (setError) {
        _status = DataFetchStatus.error;
      }
    }
    notifyListeners();
  }
}
