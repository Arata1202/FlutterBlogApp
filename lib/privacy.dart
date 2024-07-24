import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(Uri.parse('https://web-view-blog-app.vercel.app/privacy'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('プライバシーポリシー'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
