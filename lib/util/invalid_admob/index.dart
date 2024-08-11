import 'package:shared_preferences/shared_preferences.dart';

class AdClickManager {
  static const String _clickCountKey = 'clickCount';
  static const String _firstClickTimeKey = 'firstClickTime';
  static const String _isAdHiddenKey = 'isAdHidden';
  static const Duration hideDuration = Duration(days: 7); // 広告非表示期間
  static const Duration clickWindow = Duration(hours: 3); // クリック検出期間

  static Future<void> incrementClickCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int clickCount = prefs.getInt(_clickCountKey) ?? 0;
    DateTime? firstClickTime =
        DateTime.tryParse(prefs.getString(_firstClickTimeKey) ?? '');
    final DateTime now = DateTime.now();

    // 初回クリック時刻がない場合は現在の時刻を保存
    if (firstClickTime == null) {
      firstClickTime = now;
      await prefs.setString(
          _firstClickTimeKey, firstClickTime.toIso8601String());
    }

    // クリック数をインクリメント
    clickCount += 1;
    await prefs.setInt(_clickCountKey, clickCount);

    // クリック数が3回を超えた場合は広告を非表示にするフラグを保存
    if (clickCount >= 3 && now.difference(firstClickTime) <= clickWindow) {
      await prefs.setBool(_isAdHiddenKey, true);
    }
  }

  static Future<bool> shouldHideAd() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime? firstClickTime =
        DateTime.tryParse(prefs.getString(_firstClickTimeKey) ?? '');
    bool isAdHidden = prefs.getBool(_isAdHiddenKey) ?? false;

    final DateTime now = DateTime.now();

    // 7日経過した場合はリセット
    if (firstClickTime != null &&
        now.difference(firstClickTime) >= hideDuration) {
      await _resetClickData(prefs);
      isAdHidden = false;
    }

    return isAdHidden;
  }

  static Future<void> _resetClickData(SharedPreferences prefs) async {
    await prefs.setInt(_clickCountKey, 0);
    await prefs.setString(_firstClickTimeKey, '');
    await prefs.setBool(_isAdHiddenKey, false);
  }
}
