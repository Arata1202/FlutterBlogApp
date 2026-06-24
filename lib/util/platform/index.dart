import 'dart:io' show Platform;

class AppPlatform {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
}
