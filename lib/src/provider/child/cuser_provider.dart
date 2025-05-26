import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class ChildUserProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ChildUserModel> _childUser = [];
  List<ChildUserModel> get childUser => _childUser;

  Future<void> fetchChildUser() async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? parentUid = user?.uid;
    logger.i('Parent UID: $parentUid');
    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .doc(parentUid)
              .collection('children')
              .get();
      _childUser =
          querySnapshot.docs
              .map((doc) => ChildUserModel.fromJson(doc.data()))
              .toList();
      setStatus(DataFetchStatus.success);
    } catch (e) {
      handleError(e.toString());
    }
  }

  setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  handleError(String error) {
    _status = DataFetchStatus.error;
    showCustomToaster(error, isError: true);
    notifyListeners();
  }
}
