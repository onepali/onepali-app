import 'package:onepali/src/src.dart';

class ParentLocalStorage {
  static final prefs = SharedPreferencesService();

  static Future<void> setParentLogged(bool isLogged) async {
    await prefs.setBoolPref(AppConstants.parentDashboardLogged, isLogged);
  }

  static Future<bool> isParentLogged() async {
    return await prefs.getBoolPref(AppConstants.parentDashboardLogged);
  }
}
