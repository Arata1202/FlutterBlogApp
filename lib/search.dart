import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  builder: (context) => SearchResultsPage(url: request.url),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://web-view-blog-app.netlify.app/keyword'));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/title.webp',
          height: 28,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Center(
            child: Text(
              '検索',
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

class SearchResultsPage extends StatelessWidget {
  final String url;

  const SearchResultsPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/article')) {
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
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/title.webp',
          height: 28,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Center(
            child: Text(
              '検索結果',
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

class ArticlePage extends StatelessWidget {
  final String url;

  const ArticlePage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('/article') && request.url != url) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticlePage(url: request.url),
                ),
              );
              return NavigationDecision.prevent;
            }
            // 外部リンク（Amazon、楽天、Yahoo）の場合は外部ブラウザで開く
            if (request.url.contains('amazon.co.jp') ||
                request.url.contains('rakuten.co.jp') ||
                request.url.contains('google.com') ||
                request.url.contains('yahoo.co.jp')) {
              if (await canLaunch(request.url)) {
                await launch(request.url, forceSafariVC: false);
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 60,
        elevation: 4,
        title: Image.asset(
          'assets/title.webp',
          height: 28,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
