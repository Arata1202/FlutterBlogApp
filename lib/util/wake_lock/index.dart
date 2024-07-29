import 'package:wakelock/wakelock.dart';

class WakelockManager {
  static Future<void> enable() async {
    try {
      await Wakelock.enable();
    } catch (e) {
      print('Failed to enable wakelock: $e');
    }
  }

  static Future<void> disable() async {
    try {
      await Wakelock.disable();
    } catch (e) {
      print('Failed to disable wakelock: $e');
    }
  }
}
