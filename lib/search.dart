import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'home.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/tag/') ||
                request.url.contains('/search?q=')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticlePage(url: request.url),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://web-view-blog-app.vercel.app/keyword'));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/title.webp',
          height: 28,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
