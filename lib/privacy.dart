import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(Uri.parse('https://web-view-blog-app.netlify.app/privacy'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/title.webp',
          height: 28,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              'プライバシーポリシー',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
