import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src.dart';

class UserProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  UserModel? _user;

  DataFetchStatus get status => _status;
  UserModel? get user => _user;

  Future<void> fetchOwnProfile() async {
    _status = DataFetchStatus.loading;
    notifyListeners();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _status = DataFetchStatus.error;
        notifyListeners();
        return;
      }
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
      if (doc.exists) {
        _user = UserModel.fromJson(doc.data()!);
        logger.d('User fetched: ${_user?.toJson()}');
        _status = DataFetchStatus.success;
      } else {
        _user = null;
        _status = DataFetchStatus.error;
      }
      notifyListeners();
    } catch (e) {
      _user = null;
      _status = DataFetchStatus.error;
      notifyListeners();
    }
  }
}
