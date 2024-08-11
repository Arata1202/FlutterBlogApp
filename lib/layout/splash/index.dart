import 'package:flutter/material.dart';
import '../../layout/main/index.dart';

class SplashScreen extends StatefulWidget {
  final Duration splashDuration;

  const SplashScreen({super.key, required this.splashDuration});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startFadeOut();
  }

  Future<void> _startFadeOut() async {
    await Future.delayed(widget.splashDuration - Duration(milliseconds: 300));
    setState(() {
      _opacity = 0.0;
    });
    await Future.delayed(Duration(milliseconds: 300));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 300),
        child: Center(
          child: Image.asset(
            'assets/icon-512x512.png',
            width: 230,
            height: 230,
          ),
        ),
      ),
    );
  }
}
