import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences _prefs;

  static Future<SharedPreferencesService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return SharedPreferencesService();
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
    await _prefs.reload();
  }

  String? getStringsPref(String key) {
    return _prefs.getString(key);
  }

  Future<void> setStringPref(String key, dynamic value) async {
    String stringValue = value is String ? value : json.encode(value);
    await _prefs.setString(key, stringValue);
  }

  Future<dynamic> getStringPref(String key) async {
    await init();
    if (_prefs.containsKey(key)) {
      final value = _prefs.getString(key);
      if (value != null) {
        return value;
      }
      return null;
    } else {
      return null;
    }
  }

  Future<void> setBoolPref(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<bool> getBoolPref(String key) async {
    bool keyExists = _prefs.containsKey(key);

    return Future.value(keyExists ? _prefs.getBool(key) ?? false : false);
  }

  Future<void> deleteSharedPref(dynamic key) async {
    if (key is String) {
      if (_prefs.containsKey(key)) {
        await _prefs.remove(key);
      }
    } else if (key is List<String>) {
      for (var element in key) {
        if (_prefs.containsKey(element)) {
          await _prefs.remove(element);
        }
      }
    }
  }
}
