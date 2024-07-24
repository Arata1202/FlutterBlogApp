import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(Uri.parse('https://web-view-blog-app.vercel.app/profile'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('筆者について'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
