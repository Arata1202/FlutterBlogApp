import 'package:shared_preferences/shared_preferences.dart';

class LastUrlManager {
  static const _lastUrlKey = 'lastUrl';

  static Future<void> saveLastUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastUrlKey, url);
  }

  static Future<String?> getLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastUrlKey);
  }

  static Future<void> clearLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastUrlKey);
  }
}
