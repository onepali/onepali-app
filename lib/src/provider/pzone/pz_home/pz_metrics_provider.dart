import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../src.dart';

enum ActivityType { lesson, story, song }

@immutable
class PzMetricsScope {
  final String parentUid;
  final String childUid;

  const PzMetricsScope({required this.parentUid, required this.childUid});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PzMetricsScope &&
            other.parentUid == parentUid &&
            other.childUid == childUid;
  }

  @override
  int get hashCode => Object.hash(parentUid, childUid);
}

class PzMetricsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final DateTime Function() _now;

  PzMetricsProvider({FirebaseFirestore? firestore, DateTime Function()? now})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _now = now ?? DateTime.now;

  PzHomeMetricsModel? _metrics;
  PzMetricsScope? _currentScope;
  DataFetchStatus _status = DataFetchStatus.initial;
  final List<PzCompletedContentModel> _completedContents = [];

  PzHomeMetricsModel? get metrics => _metrics;
  PzMetricsScope? get currentScope => _currentScope;
  DataFetchStatus get status => _status;
  List<PzCompletedContentModel> get completedContents =>
      List.unmodifiable(_completedContents);

  Future<void> fetchCompletedContents({
    required String parentUid,
    required String childUid,
  }) async {
    final scope = PzMetricsScope(parentUid: parentUid, childUid: childUid);
    _status = DataFetchStatus.loading;
    _currentScope = scope;
    _completedContents.clear();
    notifyListeners();
    try {
      _completedContents.addAll(
        await _loadCompletedContents(parentUid: parentUid, childUid: childUid),
      );
      _status = DataFetchStatus.success;
    } catch (e) {
      _completedContents.clear();
      _status = DataFetchStatus.error;
      logger.e('Error fetching completed contents: $e');
    }
    notifyListeners();
  }

  Future<void> fetchMetrics({
    required String parentUid,
    required String childUid,
  }) async {
    final scope = PzMetricsScope(parentUid: parentUid, childUid: childUid);
    _status = DataFetchStatus.loading;
    _currentScope = scope;
    _metrics = null;
    _completedContents.clear();
    notifyListeners();
    try {
      _completedContents.addAll(
        await _loadCompletedContents(parentUid: parentUid, childUid: childUid),
      );
      final doc = await _childDoc(parentUid, childUid).get();

      if (doc.exists && doc.data()?['metrics'] != null) {
        final fetchedMetrics = PzHomeMetricsModel.fromJson(
          doc.data()?['metrics'],
        );
        final normalizedMetrics = _withCompletedContentSummary(
          fetchedMetrics
              .normalizedFor(_now())
              .copyWith(
                answerSuccessRate: _answerSuccessRateFromData(
                  doc.data(),
                  fallback: fetchedMetrics.answerSuccessRate,
                ),
              ),
          _completedContents,
        );
        if (_metricsChanged(fetchedMetrics, normalizedMetrics)) {
          await updateMetrics(
            parentUid: parentUid,
            childUid: childUid,
            newMetrics: normalizedMetrics,
            allowClearingWeeklyStreak: true,
          );
        } else {
          _metrics = normalizedMetrics;
        }
      } else if (!doc.exists) {
        final defaultMetrics = _withCompletedContentSummary(
          PzHomeMetricsModel.fromJson(null),
          _completedContents,
        );
        await updateMetrics(
          parentUid: parentUid,
          childUid: childUid,
          newMetrics: defaultMetrics,
          allowClearingWeeklyStreak: true,
        );
      } else {
        final defaultMetrics = _withCompletedContentSummary(
          PzHomeMetricsModel.fromJson(null),
          _completedContents,
        );
        await updateMetrics(
          parentUid: parentUid,
          childUid: childUid,
          newMetrics: defaultMetrics,
          allowClearingWeeklyStreak: true,
        );
      }

      _status = DataFetchStatus.success;
    } catch (e) {
      _metrics = null;
      _completedContents.clear();
      _status = DataFetchStatus.error;
      logger.e('Error fetching metrics: $e');
    }
    notifyListeners();
  }

  Future<void> updateMetrics({
    required String parentUid,
    required String childUid,
    required PzHomeMetricsModel newMetrics,
    bool allowClearingWeeklyStreak = false,
  }) async {
    final scope = PzMetricsScope(parentUid: parentUid, childUid: childUid);
    _status = DataFetchStatus.loading;
    notifyListeners();

    if (!allowClearingWeeklyStreak &&
        _isCurrentScope(scope) &&
        _wouldClearExistingStreak(newMetrics)) {
      _status = DataFetchStatus.error;
      notifyListeners();
      return;
    }

    try {
      await _childDoc(
        parentUid,
        childUid,
      ).update({'metrics': newMetrics.toJson()});
      _currentScope = scope;
      _metrics = newMetrics;
      _status = DataFetchStatus.success;
    } catch (e) {
      try {
        await _childDoc(
          parentUid,
          childUid,
        ).set({'metrics': newMetrics.toJson()}, SetOptions(merge: true));
        _currentScope = scope;
        _metrics = newMetrics;
        _status = DataFetchStatus.success;
      } catch (setError) {
        _status = DataFetchStatus.error;
        logger.e('Failed to save metrics: $setError');
      }
    }
    notifyListeners();
  }

  void startLearningSession() {
    // Session duration is tracked by LearningSessionManager. Answer metrics are
    // cumulative per child and do not need per-session state here.
  }

  Future<void> endLearningSession({
    required String parentUid,
    required String childUid,
  }) async {
    await fetchMetrics(parentUid: parentUid, childUid: childUid);
  }

  Future<void> trackActivityCompletion({
    required String parentUid,
    required String childUid,
    required String topicName,
    required ActivityType activityType,
    String? contentId,
    String? contentName,
  }) async {
    final resolvedContentId = contentId ?? topicName;
    final resolvedContentName = contentName ?? topicName;
    final scope = PzMetricsScope(parentUid: parentUid, childUid: childUid);

    if (!await _ensureMetricsLoaded(scope: scope, action: 'track completion')) {
      return;
    }

    try {
      final completedContents = await _recordContentCompletion(
        parentUid: parentUid,
        childUid: childUid,
        contentId: resolvedContentId,
        contentName: resolvedContentName,
        activityType: activityType,
      );
      _completedContents
        ..clear()
        ..addAll(completedContents);

      final now = _now();
      final metricsWithCompletion = _withCompletedContentSummary(
        _metrics!.normalizedFor(now),
        _completedContents,
      );
      final updatedMetrics = metricsWithCompletion.markActiveOn(now);

      await updateMetrics(
        parentUid: parentUid,
        childUid: childUid,
        newMetrics: updatedMetrics,
        allowClearingWeeklyStreak: true,
      );

      logger.d(
        'Activity completed: $resolvedContentName ($activityType). '
        'Total activities: ${updatedMetrics.completedActivities}. '
        'Most practiced: ${updatedMetrics.mostPracticedTopics}',
      );
    } catch (e) {
      logger.e('Error tracking activity completion: $e');
    }
  }

  Future<void> markActiveLearningDay({
    required String parentUid,
    required String childUid,
  }) async {
    final scope = PzMetricsScope(parentUid: parentUid, childUid: childUid);
    if (!await _ensureMetricsLoaded(scope: scope, action: 'mark active day')) {
      return;
    }

    try {
      final doc = await _childDoc(parentUid, childUid).get();
      final completedContents = _completedContents.isNotEmpty
          ? List<PzCompletedContentModel>.from(_completedContents)
          : await _loadCompletedContents(
              parentUid: parentUid,
              childUid: childUid,
            );
      final currentMetrics = doc.exists && doc.data()?['metrics'] != null
          ? _withCompletedContentSummary(
              PzHomeMetricsModel.fromJson(
                doc.data()?['metrics'],
              ).normalizedFor(_now()),
              completedContents,
            )
          : _withCompletedContentSummary(_metrics!, completedContents);
      final updatedMetrics = currentMetrics.markActiveOn(_now());

      await updateMetrics(
        parentUid: parentUid,
        childUid: childUid,
        newMetrics: updatedMetrics,
        allowClearingWeeklyStreak: true,
      );
    } catch (e) {
      logger.e('Error marking active learning day: $e');
    }
  }

  Future<void> trackAnswer({
    required String parentUid,
    required String childUid,
    required bool isCorrect,
    required String topicName,
  }) async {
    final scope = PzMetricsScope(parentUid: parentUid, childUid: childUid);
    if (_metrics == null || !_isCurrentScope(scope)) {
      await fetchMetrics(parentUid: parentUid, childUid: childUid);
    }
    final newSuccessRate = await _recordAnswerAttempt(
      parentUid: parentUid,
      childUid: childUid,
      isCorrect: isCorrect,
    );
    if (newSuccessRate == null) return;

    if (_metrics != null && _isCurrentScope(scope)) {
      _metrics = _metrics!.copyWith(answerSuccessRate: newSuccessRate);
      notifyListeners();
    }

    logger.d(
      'Answer tracked: ${isCorrect ? 'Correct' : 'Incorrect'}. '
      'Topic: $topicName. '
      'New success rate: ${(newSuccessRate * 100).toStringAsFixed(1)}%',
    );
  }

  Future<void> trackAnswerAttempt({
    required bool isCorrect,
    required String parentUid,
    required String childUid,
  }) async {
    try {
      final scope = PzMetricsScope(parentUid: parentUid, childUid: childUid);
      final newSuccessRate = await _recordAnswerAttempt(
        parentUid: parentUid,
        childUid: childUid,
        isCorrect: isCorrect,
      );
      if (newSuccessRate == null ||
          _metrics == null ||
          !_isCurrentScope(scope)) {
        return;
      }

      _metrics = _metrics!.copyWith(answerSuccessRate: newSuccessRate);
      notifyListeners();
    } catch (e) {
      logger.e('Error tracking answer attempt: $e');
    }
  }

  Future<void> resetWeeklyStreak({
    required String parentUid,
    required String childUid,
  }) async {
    final scope = PzMetricsScope(parentUid: parentUid, childUid: childUid);
    if (!await _ensureMetricsLoaded(
      scope: scope,
      action: 'reset weekly streak',
    )) {
      logger.w('Cannot reset weekly streak: metrics is null');
      return;
    }

    final updatedMetrics = _metrics!.copyWith(
      weeklyStreak: List.filled(7, false),
    );

    await updateMetrics(
      parentUid: parentUid,
      childUid: childUid,
      newMetrics: updatedMetrics,
      allowClearingWeeklyStreak: true,
    );
  }

  String getFormattedSuccessRate() {
    if (_metrics == null) return '0%';
    return '${(_metrics!.answerSuccessRate * 100).toStringAsFixed(1)}%';
  }

  String getFormattedAverageLearningTime() {
    if (_metrics == null) return '0 min';
    final minutes = _metrics!.averageDailyLearningTime;
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return remainingMinutes > 0
        ? '${hours}h ${remainingMinutes}m'
        : '${hours}h';
  }

  Future<void> checkAndResetWeeklyStreak({
    required String parentUid,
    required String childUid,
  }) async {
    final scope = PzMetricsScope(parentUid: parentUid, childUid: childUid);
    if (!await _ensureMetricsLoaded(
      scope: scope,
      action: 'check weekly streak',
    )) {
      return;
    }
    final normalizedMetrics = _metrics!.normalizedFor(_now());
    if (_metricsChanged(_metrics!, normalizedMetrics)) {
      await updateMetrics(
        parentUid: parentUid,
        childUid: childUid,
        newMetrics: normalizedMetrics,
        allowClearingWeeklyStreak: true,
      );
    }
  }

  Future<void> debugFirestoreData(String parentUid, String childUid) async {
    try {
      final doc = await _childDoc(parentUid, childUid).get();
      logger.i('Document exists: ${doc.exists}');
      logger.i('Has metrics field: ${doc.data()?.containsKey('metrics')}');
    } catch (e) {
      logger.e('Error checking Firestore: $e');
    }
  }

  void logCurrentWeekState(String childUid) {
    final now = _now();
    final currentWeekday = now.weekday % 7;
    final weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final currentDayName = weekdays[currentWeekday];

    logger.i('Current week state for child: $childUid');
    logger.i('Today: ${_dateKey(now)} ($currentDayName)');
    if (_metrics != null) {
      logger.i('Weekly streak: ${_metrics!.weeklyStreak}');
      logger.i('Day streak: ${_metrics!.dayStreak}');
      logger.i('Last active date: ${_metrics!.lastActiveDate}');
    }
  }

  Future<List<PzCompletedContentModel>> _recordContentCompletion({
    required String parentUid,
    required String childUid,
    required String contentId,
    required String contentName,
    required ActivityType activityType,
  }) async {
    final completionDate = _now().toIso8601String();
    final type = activityType.name;
    final docRef = _childDoc(parentUid, childUid)
        .collection(AppConstants.completedContentCollection)
        .doc('${type}_$contentId');

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (doc.exists) {
        transaction.update(docRef, {
          'completed_count': FieldValue.increment(1),
          'content_name': contentName,
          'updated_at': completionDate,
        });
      } else {
        transaction.set(docRef, {
          'id': docRef.id,
          'parent_id': parentUid,
          'child_id': childUid,
          'content_id': contentId,
          'content_name': contentName,
          'content_type': type,
          'created_at': completionDate,
          'updated_at': completionDate,
          'completed_count': 1,
        });
      }
    });

    return _loadCompletedContents(parentUid: parentUid, childUid: childUid);
  }

  Future<double?> _recordAnswerAttempt({
    required String parentUid,
    required String childUid,
    required bool isCorrect,
  }) async {
    final docRef = _childDoc(parentUid, childUid);
    final counterField = isCorrect
        ? 'right_answers_count'
        : 'wrong_answers_count';

    try {
      return await _firestore.runTransaction<double>((transaction) async {
        final doc = await transaction.get(docRef);
        final data = doc.data();
        final currentRight =
            (data?['right_answers_count'] as num?)?.toInt() ?? 0;
        final currentWrong =
            (data?['wrong_answers_count'] as num?)?.toInt() ?? 0;
        final nextRight = currentRight + (isCorrect ? 1 : 0);
        final nextWrong = currentWrong + (isCorrect ? 0 : 1);
        final totalAnswers = nextRight + nextWrong;
        final successRate = totalAnswers > 0 ? nextRight / totalAnswers : 0.0;

        if (doc.exists) {
          transaction.update(docRef, {
            counterField: FieldValue.increment(1),
            'metrics.answerSuccessRate': successRate,
          });
        } else {
          transaction.set(docRef, {
            'right_answers_count': nextRight,
            'wrong_answers_count': nextWrong,
            'metrics': {'answerSuccessRate': successRate},
          }, SetOptions(merge: true));
        }

        return successRate;
      });
    } catch (e) {
      logger.e('Error updating answer success rate: $e');
      return null;
    }
  }

  Future<List<PzCompletedContentModel>> _loadCompletedContents({
    required String parentUid,
    required String childUid,
  }) async {
    final snapshot = await _childDoc(
      parentUid,
      childUid,
    ).collection(AppConstants.completedContentCollection).get();
    return snapshot.docs
        .map((doc) => PzCompletedContentModel.fromJson(doc.data()))
        .toList();
  }

  PzHomeMetricsModel _withCompletedContentSummary(
    PzHomeMetricsModel metrics,
    List<PzCompletedContentModel> completedContents,
  ) {
    final sortedContents = List<PzCompletedContentModel>.from(completedContents)
      ..sort((a, b) => b.completedCount.compareTo(a.completedCount));
    final topicCounts = {
      for (final content in completedContents)
        content.contentName: content.completedCount,
    };

    return metrics.copyWith(
      completedActivities: completedContents.length,
      mostPracticedTopics: sortedContents
          .take(5)
          .map((content) => content.contentName)
          .toList(),
      topicCounts: topicCounts,
    );
  }

  double _answerSuccessRateFromData(
    Map<String, dynamic>? data, {
    required double fallback,
  }) {
    final rightAnswers = (data?['right_answers_count'] as num?)?.toInt() ?? 0;
    final wrongAnswers = (data?['wrong_answers_count'] as num?)?.toInt() ?? 0;
    final totalAnswers = rightAnswers + wrongAnswers;
    if (totalAnswers == 0) {
      return fallback;
    }
    return rightAnswers / totalAnswers;
  }

  bool _metricsChanged(
    PzHomeMetricsModel previous,
    PzHomeMetricsModel current,
  ) {
    if (previous.completedActivities != current.completedActivities ||
        previous.answerSuccessRate != current.answerSuccessRate ||
        previous.dayStreak != current.dayStreak ||
        previous.lastActiveDate != current.lastActiveDate ||
        previous.averageDailyLearningTime != current.averageDailyLearningTime) {
      return true;
    }
    if (!_sameBoolList(previous.weeklyStreak, current.weeklyStreak)) {
      return true;
    }
    if (!_sameStringList(
      previous.mostPracticedTopics,
      current.mostPracticedTopics,
    )) {
      return true;
    }
    if (!_sameIntMap(previous.topicCounts, current.topicCounts)) {
      return true;
    }
    return false;
  }

  bool _wouldClearExistingStreak(PzHomeMetricsModel newMetrics) {
    if (_metrics == null) return false;
    final currentActiveDays = _metrics!.weeklyStreak.where((day) => day).length;
    final newActiveDays = newMetrics.weeklyStreak.where((day) => day).length;
    return currentActiveDays > 0 &&
        newActiveDays == 0 &&
        newMetrics.dayStreak == 0;
  }

  bool _sameBoolList(List<bool> first, List<bool> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }

  bool _sameStringList(List<String> first, List<String> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }

  bool _sameIntMap(Map<String, int> first, Map<String, int> second) {
    if (first.length != second.length) return false;
    for (final entry in first.entries) {
      if (second[entry.key] != entry.value) return false;
    }
    return true;
  }

  bool _isCurrentScope(PzMetricsScope scope) {
    return _currentScope == scope;
  }

  Future<bool> _ensureMetricsLoaded({
    required PzMetricsScope scope,
    required String action,
  }) async {
    if (_metrics == null || !_isCurrentScope(scope)) {
      await fetchMetrics(parentUid: scope.parentUid, childUid: scope.childUid);
    }
    if (_metrics == null || !_isCurrentScope(scope)) {
      logger.e('Failed to $action: metrics is null');
      return false;
    }
    return true;
  }

  DocumentReference<Map<String, dynamic>> _childDoc(
    String parentUid,
    String childUid,
  ) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(parentUid)
        .collection(AppConstants.childrenCollection)
        .doc(childUid);
  }

  String _dateKey(DateTime date) {
    final localDate = DateTime(date.year, date.month, date.day);
    final year = localDate.year.toString().padLeft(4, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final day = localDate.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
