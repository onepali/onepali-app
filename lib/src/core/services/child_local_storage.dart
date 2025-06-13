import 'package:onepali/src/src.dart';

class ChildLocalStorage {
  static final prefs = SharedPreferencesService();

  static Future<void> saveCurrentChildId(String childId) async {
    await prefs.setStringPref(AppConstants.childIdKey, childId);
  }

  static Future<void> saveCurrentAvatarUrl(String avatar) async {
    await prefs.setStringPref(AppConstants.avatarUrlKey, avatar);
  }

  static Future<String?> getCurrentChildId() async {
    return await prefs.getStringPref(AppConstants.childIdKey);
  }

  static Future<String?> getCurrentAvatarUrl() async {
    return await prefs.getStringPref(AppConstants.avatarUrlKey);
  }
}
