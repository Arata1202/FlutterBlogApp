import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../common/admob/banner/index.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  late WebViewController _controller;
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
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://web-view-blog-app.vercel.app/contact'));
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
              Expanded(child: webView),
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
        padding: const EdgeInsets.all(0),
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
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
