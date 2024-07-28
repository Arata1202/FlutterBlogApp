import 'package:flutter/material.dart';
import '../../layout/main/index.dart';

class SplashScreen extends StatefulWidget {
  final Duration splashDuration;

  const SplashScreen({super.key, required this.splashDuration});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(widget.splashDuration, () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/icon-512x512.png',
          width: 230,
          height: 230,
        ),
      ),
    );
  }
}
