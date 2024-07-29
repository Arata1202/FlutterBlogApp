import 'package:shared_preferences/shared_preferences.dart';

class LastUrlManager {
  static const _lastUrlKey = 'lastUrl';
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  static Future<void> saveLastUrl(String url) async {
    try {
      await initialize();
      await _prefs?.setString(_lastUrlKey, url);
    } catch (e) {
      print('Failed to save last URL: $e');
    }
  }

  static Future<String?> getLastUrl() async {
    try {
      await initialize();
      return _prefs?.getString(_lastUrlKey);
    } catch (e) {
      print('Failed to get last URL: $e');
      return null;
    }
  }

  static Future<void> clearLastUrl() async {
    try {
      await initialize();
      await _prefs?.remove(_lastUrlKey);
    } catch (e) {
      print('Failed to clear last URL: $e');
    }
  }
}
