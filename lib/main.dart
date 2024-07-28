import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'app/search/index.dart';
import 'app/menu/index.dart';
import 'app/home/index.dart';
import 'layout/footer/index.dart';
import 'layout/splash/index.dart';

void main() async {
  runApp(const MyApp());
  await dotenv.load(fileName: '.env');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
