import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManger {
  static final PreferenceManger _instance = PreferenceManger._();

  factory PreferenceManger() {
    return _instance;
  }

  PreferenceManger._();

  late final SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // =======================
  // String
  // =======================

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  // =======================
  // Int
  // =======================

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  // =======================
  // Double
  // =======================

  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  // =======================
  // Bool
  // =======================

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  // =======================
  // List<String>
  // =======================

  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  // =======================
  // Remove key
  // =======================

  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  // =======================
  // Clear all data
  // =======================

  Future<bool> clearAll() async {
    return await _preferences.clear();
  }
}
