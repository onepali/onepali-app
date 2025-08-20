import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class LessonProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<CourseModel> _courses = [];
  List<CourseModel> get courses => _courses;

  Future<void> incrementTotalLessonsCompleted(
    BuildContext context,
    dynamic lessonId,
    String lessonName,
  ) async {
    final childId = await ChildLocalStorage.getCurrentChildId();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final parentId = userProvider.userId ?? '';
    if (childId == null ||
        parentId.isEmpty ||
        lessonId == null ||
        lessonName.isEmpty) {
      logger.e('Child ID, Parent ID, Lesson ID, or Lesson Name not found');
      return;
    }
    try {
      final doc =
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(parentId)
              .collection(AppConstants.childrenCollection)
              .doc(childId)
              .get();

      List<dynamic> completedLessons = [];
      if (doc.exists &&
          doc.data() != null &&
          doc.data()!['completedLessons'] != null) {
        final completedLessonsData = doc.data()!['completedLessons'];

        // Handle both old format (direct list) and new format (nested object)
        if (completedLessonsData is List) {
          completedLessons = List.from(completedLessonsData);
        } else if (completedLessonsData is Map &&
            completedLessonsData['lessons'] != null) {
          completedLessons = List.from(completedLessonsData['lessons']);
        }
      }

      // Check if lesson already completed
      final alreadyCompleted = completedLessons.any(
        (l) => l['id'].toString() == lessonId.toString(),
      );
      if (alreadyCompleted) {
        logger.i('Lesson $lessonId already completed, not incrementing.');
        return;
      }

      // Add lesson info to completedLessons
      completedLessons.add({'id': lessonId, 'name': lessonName});

      // Update Firestore: nest totalLessonsCompleted and completedLessons under completedLessons object
      final newTotal = completedLessons.length;
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentId)
          .collection(AppConstants.childrenCollection)
          .doc(childId)
          .update({
            'completedLessons': {
              'totalLessonsCompleted': newTotal,
              'lessons': completedLessons,
            },
          });
      logger.i('Lesson $lessonId completed and merged. Total: $newTotal');
    } catch (e) {
      logger.e('Failed to increment totalLessonsCompleted: $e');
    }
  }

  Future<void> fetchCourses() async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    bool isGuest = GuestUtil.isGuestUser();

    if (user == null && !isGuest) {
      logger.e('User is not authenticated and not a guest user.');
      handleError("User not signed in.");
      return;
    }

    logger.d(
      isGuest ? 'Guest user detected' : 'User authenticated: ${user?.uid}',
    );

    try {
      logger.d('Attempting to fetch courses from Firestore...');
      final querySnapshot =
          await _firestore.collection(AppConstants.coursesCollection).get();
      logger.d(
        'Firestore query returned ${querySnapshot.docs.length} course documents',
      );
      _courses.clear();
      // Collect all course docs into a single array for CourseModel
      final List<Map<String, dynamic>> allCourses = [];
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        logger.d(
          'Processing course document: ${doc.id} with data keys: ${data.keys.toList()}',
        );

        // Check if the document has the expected structure
        if (data.isEmpty) {
          logger.w('Document ${doc.id} is empty');
          continue;
        }

        // Defensive: ensure chapters, lessons, lesson_content are always List<Map<String, dynamic>>
        if (data['chapters'] is List) {
          data['chapters'] =
              (data['chapters'] as List).map((ch) {
                if (ch is Map<String, dynamic>) {
                  if (ch['lessons'] is List) {
                    ch['lessons'] =
                        (ch['lessons'] as List).map((ls) {
                          if (ls is Map<String, dynamic>) {
                            if (ls['lesson_content'] is List) {
                              ls['lesson_content'] =
                                  (ls['lesson_content'] as List).map((lc) {
                                    if (lc is Map<String, dynamic>) return lc;
                                    if (lc is Map) {
                                      return Map<String, dynamic>.from(lc);
                                    }
                                    return <String, dynamic>{};
                                  }).toList();
                            } else {
                              ls['lesson_content'] = <Map<String, dynamic>>[];
                            }
                            return ls;
                          }
                          if (ls is Map) return Map<String, dynamic>.from(ls);
                          return <String, dynamic>{};
                        }).toList();
                  } else {
                    ch['lessons'] = <Map<String, dynamic>>[];
                  }
                  return ch;
                }
                if (ch is Map) return Map<String, dynamic>.from(ch);
                return <String, dynamic>{};
              }).toList();
        } else {
          data['chapters'] = <Map<String, dynamic>>[];
        }
        allCourses.add(data);
      }
      logger.d('Total courses processed: ${allCourses.length}');
      final courseModelJson = {'courses': allCourses};
      try {
        if (allCourses.isNotEmpty) {
          _courses.add(CourseModel.fromJson(courseModelJson));
          logger.d(
            'Successfully parsed CourseModel with ${allCourses.length} courses',
          );
        } else {
          logger.w('No courses found in Firestore to parse');
        }
      } catch (e, stackTrace) {
        logger.e(
          'Error parsing all courses: $e\nStackTrace: $stackTrace\nData: ${json.encode(courseModelJson)}',
        );
        // Still set success status but with empty courses
        // This prevents the UI from showing error state when data exists but can't be parsed
      }
      logger.d(
        'LessonProvider: fetched ${_courses.length} courses -------- result: ${json.encode(_courses)}',
      );
      setStatus(DataFetchStatus.success);
    } catch (e, s) {
      logger.e('Error fetching courses: $e--------- $s');
      // Check if it's a permission/authentication error
      if (e.toString().contains('permission') ||
          e.toString().contains('auth')) {
        logger.e(
          'Possible authentication or permission issue accessing courses collection',
        );
      }
      handleError(e.toString());
    }
  }

  void handleError(String error) {
    _status = DataFetchStatus.error;
    showCustomToaster(error, isError: true);
    notifyListeners();
  }

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  // Track lesson completion and update parent metrics
  Future<void> trackLessonCompletion({
    required String parentUid,
    required String childUid,
    required String lessonId,
    required String topicName,
    required BuildContext context,
  }) async {
    try {
      // Get the metrics provider
      final metricsProvider = context.read<PzMetricsProvider>();

      // Track the activity completion
      await metricsProvider.trackActivityCompletion(
        parentUid: parentUid,
        childUid: childUid,
        topicName: topicName,
        activityType: ActivityType.lesson,
      );

      logger.d('Lesson completion tracked: $lessonId in $topicName');
    } catch (e) {
      logger.e('Error tracking lesson completion: $e');
    }
  }

  // Track lesson answer for success rate
  Future<void> trackLessonAnswer({
    required String parentUid,
    required String childUid,
    required bool isCorrect,
    required String topicName,
    required BuildContext context,
  }) async {
    try {
      // Get the metrics provider
      final metricsProvider = context.read<PzMetricsProvider>();

      // Track the answer
      await metricsProvider.trackAnswer(
        parentUid: parentUid,
        childUid: childUid,
        isCorrect: isCorrect,
        topicName: topicName,
      );

      logger.d(
        'Lesson answer tracked: ${isCorrect ? 'Correct' : 'Incorrect'} in $topicName',
      );
    } catch (e) {
      logger.e('Error tracking lesson answer: $e');
    }
  }

  Future<void> updateTotalLessonsCompleted(
    String parentUid,
    String childId,
    int newTotal,
  ) async {
    logger.d(
      'Updating totalLessonsCompleted for childId: $childId of parent: $parentUid',
    );
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(parentUid)
          .collection(AppConstants.childrenCollection)
          .doc(childId)
          .update({'totalLessonsCompleted': newTotal});
      logger.d('Updated totalLessonsCompleted for childId: $childId');
    } catch (e) {
      logger.e(
        'Failed to update totalLessonsCompleted for childId: $childId. Error: $e',
      );
      rethrow;
    }
  }
}
