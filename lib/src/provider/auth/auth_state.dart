import 'package:flutter/material.dart';

class AuthState with ChangeNotifier {
  String? heardAbout;
  String? learningReason;
  String? fullName;
  int? yearOfBirth;

  void setHeardAbout(String value) {
    heardAbout = value;
    notifyListeners();
  }

  void setLearningReason(String value) {
    learningReason = value;
    notifyListeners();
  }

  void setFullName(String value) {
    fullName = value;
    notifyListeners();
  }

  void setYearOfBirth(int value) {
    yearOfBirth = value;
    notifyListeners();
  }

  void clear() {
    heardAbout = null;
    learningReason = null;
    fullName = null;
    yearOfBirth = null;
    notifyListeners();
  }
}
