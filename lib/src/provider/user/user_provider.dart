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

  Future<bool> isMatchedPin(int pin) async {
    logger.d('Checking PIN match for user: ${_user?.yearOfBirth}, PIN: $pin');
    if (_user == null) {
      logger.w('User not fetched yet, cannot check PIN match');
      showCustomToaster(
        'User not fetched yet. Please try again later.',
        isError: true,
      );
      return false;
    }
    // Check if pin is a valid year and matches user's yearOfBirth
    if (pin < 1900 || _user!.yearOfBirth != pin) {
      showCustomToaster('Invalid PIN. Please try again.', isError: true);
      logger.w('Invalid PIN: $pin');
      return false;
    }
    logger.d('PIN match: true');
    return true;
  }
}


// pin > DateTime.now().year ||