import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'config/app_config.dart';
import 'config/app_version.dart';
import 'layout/main/index.dart';
import 'layout/splash/index.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'util/launch_url/index.dart';
import 'util/platform/index.dart';

const _minimumSplashDuration = Duration(seconds: 2);
const _remoteConfigFetchTimeout = Duration(seconds: 3);
const _remoteConfigMinimumFetchInterval = Duration(minutes: 15);

bool get isIOS => AppPlatform.isIOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  _initializeMobileAds();

  runApp(const MyApp());
}

enum _StartupDestination { app, updateRequired, maintenance }

Future<_StartupDestination> _loadStartupDestination() async {
  final startupDestinationFuture = _resolveStartupDestination();

  await Future.wait<void>([
    startupDestinationFuture.then<void>((_) {}),
    Future<void>.delayed(_minimumSplashDuration),
  ]);

  return startupDestinationFuture;
}

Future<_StartupDestination> _resolveStartupDestination() async {
  try {
    if (!await _initializeFirebase()) {
      _initializeOneSignal();
      return _StartupDestination.app;
    }

    _initializeOneSignal();

    final remoteConfig = FirebaseRemoteConfig.instance;
    await _configureRemoteConfig(remoteConfig);
    await _fetchRemoteConfig(remoteConfig);

    final latestVersion =
        isIOS
            ? remoteConfig.getString('current_version')
            : remoteConfig.getString('android_current_version');
    final maintenanceMode =
        isIOS
            ? remoteConfig.getBool('maintenance_mode')
            : remoteConfig.getBool('android_maintenance_mode');

    final packageInfo = await PackageInfo.fromPlatform();

    if (maintenanceMode) {
      return _StartupDestination.maintenance;
    }

    if (AppVersion.isUpdateRequired(
      currentVersion: packageInfo.version,
      latestVersion: latestVersion,
    )) {
      return _StartupDestination.updateRequired;
    }

    return _StartupDestination.app;
  } catch (error, stackTrace) {
    _reportAppError('Startup destination resolution failed', error, stackTrace);
    return _StartupDestination.app;
  }
}

Future<bool> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    return true;
  } catch (error, stackTrace) {
    _reportAppError('Firebase initialization failed', error, stackTrace);
    return false;
  }
}

void _initializeOneSignal() {
  if (AppConfig.oneSignalAppId.isEmpty) {
    return;
  }

  try {
    if (kDebugMode) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }

    OneSignal.initialize(AppConfig.oneSignalAppId);
    if (!AppPlatform.isIOS) {
      unawaited(_requestAndroidNotificationPermission());
    }
  } catch (error, stackTrace) {
    _reportAppError('OneSignal initialization failed', error, stackTrace);
  }
}

void _initializeMobileAds() {
  if (!AppPlatform.isIOS || !AppConfig.isAdMobEnabled) {
    return;
  }

  unawaited(_initializeMobileAdsOrReport());
}

Future<void> _initializeMobileAdsOrReport() async {
  try {
    await MobileAds.instance.initialize();
  } catch (error, stackTrace) {
    _reportAppError('Mobile Ads initialization failed', error, stackTrace);
  }
}

Future<void> _requestAndroidNotificationPermission() async {
  try {
    await OneSignal.Notifications.requestPermission(true);
  } catch (error, stackTrace) {
    _reportAppError(
      'Android notification permission request failed',
      error,
      stackTrace,
    );
  }
}

Future<void> _configureRemoteConfig(FirebaseRemoteConfig remoteConfig) async {
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: _remoteConfigFetchTimeout,
      minimumFetchInterval:
          kDebugMode ? Duration.zero : _remoteConfigMinimumFetchInterval,
    ),
  );

  await remoteConfig.setDefaults(<String, dynamic>{
    'current_version': '1.0.0',
    'android_current_version': '1.0.0',
    'maintenance_mode': false,
    'android_maintenance_mode': false,
  });
}

Future<void> _fetchRemoteConfig(FirebaseRemoteConfig remoteConfig) async {
  try {
    await remoteConfig.fetchAndActivate();
  } catch (error, stackTrace) {
    _reportAppError('Remote Config fetch failed', error, stackTrace);
  }
}

Future<void> _launchExternalUrlOrReport(String url) async {
  try {
    if (!await launchExternalUrl(url)) {
      throw StateError('Could not launch $url');
    }
  } catch (error, stackTrace) {
    _reportAppError('External URL launch failed', error, stackTrace);
  }
}

void _reportAppError(String context, Object error, StackTrace stackTrace) {
  FlutterError.reportError(
    FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'FlutterBlogApp',
      context: ErrorDescription(context),
    ),
  );
}

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SystemMessageScaffold(
      child:
          isIOS
              ? CupertinoAlertDialog(
                title: const Text('アップデートのお知らせ'),
                content: const Text('新しいバージョンのアプリが利用可能です。ストアからアップデートしてください。'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('アップデート'),
                    onPressed: () {
                      _launchStore();
                    },
                  ),
                ],
              )
              : AlertDialog(
                title: const Text('アップデートのお知らせ'),
                content: const Text('新しいバージョンのアプリが利用可能です。ストアからアップデートしてください。'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('アップデート'),
                    onPressed: () {
                      _launchStore();
                    },
                  ),
                ],
              ),
    );
  }

  void _launchStore() async {
    final url =
        AppPlatform.isIOS
            ? 'https://apps.apple.com/jp/app/%E3%83%AA%E3%82%A2%E3%83%AB%E5%A4%A7%E5%AD%A6%E7%94%9F-%E3%83%A2%E3%83%90%E3%82%A4%E3%83%AB/id6590619103'
            : 'https://play.google.com/store/apps/details?id=com.realunivlog.flutterblogapp';
    await _launchExternalUrlOrReport(url);
  }
}

class MaintenanceModeScreen extends StatelessWidget {
  const MaintenanceModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SystemMessageScaffold(
      child:
          isIOS
              ? CupertinoAlertDialog(
                title: const Text('メンテナンス中'),
                content: const Text('現在、アプリはメンテナンス中です。しばらくしてから再度お試しください。'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('WEB版を開く'),
                    onPressed: () async {
                      await _launchExternalUrlOrReport(
                        'https://realunivlog.com',
                      );
                    },
                  ),
                ],
              )
              : AlertDialog(
                title: const Text('メンテナンス中'),
                content: const Text('現在、アプリはメンテナンス中です。しばらくしてから再度お試しください。'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('WEB版を開く'),
                    onPressed: () async {
                      await _launchExternalUrlOrReport(
                        'https://realunivlog.com',
                      );
                    },
                  ),
                ],
              ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'リアル大学生',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      home: const _StartupGate(),
    );
  }
}

class _StartupGate extends StatefulWidget {
  const _StartupGate();

  @override
  State<_StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<_StartupGate> {
  late final Future<_StartupDestination> _startupDestination =
      _loadStartupDestination();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_StartupDestination>(
      future: _startupDestination,
      builder: (context, snapshot) {
        final destination = snapshot.data;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (destination) {
            _StartupDestination.app => const MyHomePage(key: ValueKey('home')),
            _StartupDestination.updateRequired => const UpdateRequiredScreen(
              key: ValueKey('update-required'),
            ),
            _StartupDestination.maintenance => const MaintenanceModeScreen(
              key: ValueKey('maintenance'),
            ),
            null => const SplashView(key: ValueKey('splash')),
          },
        );
      },
    );
  }
}

class _SystemMessageScaffold extends StatelessWidget {
  final Widget child;

  const _SystemMessageScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(padding: const EdgeInsets.all(16), child: child),
          ),
        ),
      ),
    );
  }
}
