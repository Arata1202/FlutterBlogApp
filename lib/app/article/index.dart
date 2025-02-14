import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../common/admob/banner/index.dart';
import '../../util/navigate_out/index.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

class ArticlePage extends StatefulWidget {
  final String url;

  const ArticlePage({super.key, required this.url});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late WebViewController _controller;
  String _pageTitle = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _initializeWebViewController();
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(
          isIOS ? CupertinoColors.systemBackground : Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            _pageTitle = await _controller.getTitle() ?? 'Unknown';
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (isIOS) {
              return await NavigationHelper.handleNavigationRequest(
                request,
                widget.url,
                () async {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ArticlePage(url: request.url),
                    ),
                  );
                },
              );
            } else {
              return await NavigationHelper.handleNavigationRequest(
                request,
                widget.url,
                () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticlePage(url: request.url),
                    ),
                  );
                },
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget webView = Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );

    if (isIOS) {
      return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoPageScaffold(
          navigationBar: _buildNavigationBar(context),
          child: Column(
            children: [
              BannerAdWidget(adUnitId: dotenv.get('BANNER_AD')),
              Expanded(child: webView),
            ],
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: Column(
            children: [
              BannerAdWidget(adUnitId: dotenv.get('BANNER_AD')),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: webView,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  CupertinoNavigationBar _buildNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.white,
      middle: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
            SizedBox(width: 4),
            Text(
              '戻る',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ],
        ),
      ),
      trailing: !_isLoading
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                _shareArticle();
              },
              child: const Icon(CupertinoIcons.share,
                  color: CupertinoColors.activeBlue),
            )
          : null,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.arrow_back, color: Colors.black),
          ],
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        if (!_isLoading)
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              _shareArticle();
            },
          ),
      ],
    );
  }

  void _shareArticle() {
    final newUrl = widget.url.replaceFirst(
        'https://web-view-blog-app.vercel.app/', 'https://realunivlog.com/');
    Share.share('$_pageTitle\n$newUrl');
  }
}
