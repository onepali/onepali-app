import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class AuthState with ChangeNotifier {
  String? heardAbout;
  String? learningReason;
  String? fullName;
  int? yearOfBirth;
  String? childName;
  String? childDob;
  String? childAvatar;
  double? childScreenTime;
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

  void setChildName(String value) {
    childName = value;
    notifyListeners();
  }

  void setChildDob(String value) {
    childDob = value;
    notifyListeners();
  }

  void setChildAvatar(String value) {
    logger.d('Child avatar: $value');
    childAvatar = value;
    notifyListeners();
  }

  void setChildScreenTime(double value) {
    childScreenTime = value;
    notifyListeners();
  }

  void clear() {
    heardAbout = null;
    learningReason = null;
    fullName = null;
    yearOfBirth = null;
    childName = null;
    childDob = null;
    childAvatar = null;
    childScreenTime = null;
    notifyListeners();
  }
}
