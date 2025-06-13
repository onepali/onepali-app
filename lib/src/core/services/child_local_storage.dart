import 'package:onepali/src/src.dart';

class ChildLocalStorage {
  static final prefs = SharedPreferencesService();

  static Future<void> saveCurrentChildId(String childId) async {
    await prefs.setStringPref(AppConstants.childIdKey, childId);
  }

  static Future<String?> getCurrentChildId() async {
    return await prefs.getStringPref(AppConstants.childIdKey);
  }
}
