import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

DateTime? _currentBackPressTime;
//----- Double tap to go back -----
Future<bool> doubleTapTrigger() {
  DateTime now = DateTime.now();
  if (_currentBackPressTime == null ||
      now.difference(_currentBackPressTime!) > const Duration(seconds: 3)) {
    _currentBackPressTime = now;
    Fluttertoast.showToast(
      msg: 'Tap again to exit',
      toastLength: Toast.LENGTH_SHORT,
    );
    return Future.value(false);
  }
  SystemNavigator.pop();
  _currentBackPressTime = null;
  return Future.value(true);
}
