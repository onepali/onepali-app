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

  static Future<void> setGuestLogged(bool isLogged) async {
    await prefs.setBoolPref(AppConstants.guestLogged, isLogged);
  }

  static Future<bool> getGuestLogged() async {
    return await prefs.getBoolPref(AppConstants.guestLogged);
  }

  static Future<void> clear() async => await prefs.clear();
}
