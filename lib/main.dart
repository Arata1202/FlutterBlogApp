import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'layout/splash/index.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  MobileAds.instance.initialize();
  await dotenv.load(fileName: '.env');
  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(dotenv.get('ONESIGNAL_APP_ID'));

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  _checkVersionAndRunApp();
}

Future<void> _checkVersionAndRunApp() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: Duration.zero,
  ));

  await remoteConfig.setDefaults(<String, dynamic>{
    "current_version": "1.0.0",
    "android_current_version": "1.0.0",
    "maintenance_mode": false,
    "android_maintenance_mode": false,
  });

  await remoteConfig.fetchAndActivate();

  var latestVersion = isIOS
      ? remoteConfig.getString("current_version")
      : remoteConfig.getString("android_current_version");
  var maintenanceMode = isIOS
      ? remoteConfig.getBool("maintenance_mode")
      : remoteConfig.getBool("android_maintenance_mode");

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version;

  if (maintenanceMode) {
    runApp(MaintenanceModeApp());
  } else if (_isUpdateRequired(currentVersion, latestVersion)) {
    runApp(UpdateRequiredApp());
  } else {
    runApp(const MyApp());
  }
}

bool _isUpdateRequired(String currentVersion, String latestVersion) {
  List<String> currentParts = currentVersion.split('.');
  List<String> latestParts = latestVersion.split('.');

  for (int i = 0; i < currentParts.length; i++) {
    int currentPart = int.parse(currentParts[i]);
    int latestPart = int.parse(latestParts[i]);

    if (currentPart < latestPart) {
      return true;
    } else if (currentPart > latestPart) {
      return false;
    }
  }
  return false;
}

class UpdateRequiredApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CupertinoAlertDialog(
          title: Text('アップデートのお知らせ'),
          content: Text('新しいバージョンのアプリが利用可能です。ストアからアップデートしてください。'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('アップデート'),
              onPressed: () {
                _launchAppStore();
              },
            ),
          ],
        ),
        builder: (context, child) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(16),
              child: child,
            ),
          );
        },
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AlertDialog(
          title: Text('アップデートのお知らせ'),
          content: Text('新しいバージョンのアプリが利用可能です。ストアからアップデートしてください。'),
          // actions: <Widget>[
          //   TextButton(
          //     child: Text('アップデート'),
          //     onPressed: () {
          //       _launchAppStore();
          //     },
          //   ),
          // ],
        ),
      );
    }
  }

  void _launchAppStore() async {
    const url =
        'https://apps.apple.com/jp/app/%E3%83%AA%E3%82%A2%E3%83%AB%E5%A4%A7%E5%AD%A6%E7%94%9F-%E3%83%A2%E3%83%90%E3%82%A4%E3%83%AB/id6590619103';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class MaintenanceModeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CupertinoAlertDialog(
          title: Text('メンテナンス中'),
          content: Text('現在、アプリはメンテナンス中です。しばらくしてから再度お試しください。'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('WEB版を開く'),
              onPressed: () async {
                const url = 'https://realunivlog.com';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false,
                    forceWebView: false,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
        builder: (context, child) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(16),
              child: child,
            ),
          );
        },
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AlertDialog(
          title: Text('メンテナンス中'),
          content: Text('現在、アプリはメンテナンス中です。しばらくしてから再度お試しください。'),
          actions: <Widget>[
            TextButton(
              child: Text('WEB版を開く'),
              onPressed: () async {
                const url = 'https://realunivlog.com';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false,
                    forceWebView: false,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      );
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(
        splashDuration: Duration(seconds: 2), // 表示時間を調整
      ),
    );
  }
}
