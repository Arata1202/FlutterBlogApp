import 'package:flutter/material.dart';
import '../../layout/main/index.dart';

class SplashScreen extends StatefulWidget {
  final Duration splashDuration;

  const SplashScreen({super.key, required this.splashDuration});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startFadeOut();
  }

  Future<void> _startFadeOut() async {
    await Future.delayed(
        widget.splashDuration - const Duration(milliseconds: 300));
    if (!mounted) {
      return;
    }
    setState(() {
      _opacity = 0.0;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) {
      return;
    }
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
        duration: const Duration(milliseconds: 300),
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
