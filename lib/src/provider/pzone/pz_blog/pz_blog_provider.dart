import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class PzBlogProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<PzBlogModel> _blogs = [];
  List<PzBlogModel> get blogs => _blogs;

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  void handleError(String error) {
    _status = DataFetchStatus.error;
    showCustomToaster(error, isError: true);
    notifyListeners();
  }

  Future<void> fetchBlogs() async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      logger.e('User is not authenticated.');
      handleError("User not signed in.");
      return;
    }

    try {
      final querySnapshot = await _firestore.collection('blogs').get();
      final List<Map<String, dynamic>> blogList =
          querySnapshot.docs.map((doc) => doc.data()).toList();
      _blogs.clear();
      _blogs.addAll(pzBlogModelFromJson(jsonEncode(blogList)));
      setStatus(DataFetchStatus.success);
    } catch (e) {
      logger.e('Error fetching blogs: $e');
      handleError(e.toString());
    }
  }

  Future<void> incrementBlogView(String blogId) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      if (user == null) {
        logger.e('User is not authenticated.');
        handleError("User not signed in.");
        return;
      }
      final blogRef = _firestore.collection('blogs').doc(blogId);
      await blogRef.update({'viewCount': FieldValue.increment(1)});
      final index = _blogs.indexWhere((b) => b.id == blogId);
      if (index != -1) {
        _blogs[index] = _blogs[index].copyWith(
          viewCount: _blogs[index].viewCount + 1,
        );
        notifyListeners();
      }
    } catch (e) {
      logger.e('Error incrementing blog view: $e');
    }
  }
}
