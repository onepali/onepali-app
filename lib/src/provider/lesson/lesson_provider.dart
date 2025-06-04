import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class LessonProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<CourseModel> _courses = [];
  List<CourseModel> get songs => _courses;

  Future<void> fetchSongs() async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      logger.e('User is not authenticated.');
      handleError("User not signed in.");
      return;
    }

    try {
      final querySnapshot = await _firestore.collection('courses').get();
      final List<Map<String, dynamic>> courseList =
          querySnapshot.docs.map((doc) => doc.data()).toList();
      _courses.clear();
      _courses.addAll(courseList.map((json) => CourseModel.fromJson(json)));
      setStatus(DataFetchStatus.success);
    } catch (e) {
      logger.e('Error fetching songs: $e');
      handleError(e.toString());
    }
  }

  void handleError(String error) {
    _status = DataFetchStatus.error;
    showCustomToaster(error, isError: true);
    notifyListeners();
  }

  setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }
}
