import 'package:wakelock/wakelock.dart';

class WakelockManager {
  static void enable() {
    Wakelock.enable();
  }

  static void disable() {
    Wakelock.disable();
  }
}
