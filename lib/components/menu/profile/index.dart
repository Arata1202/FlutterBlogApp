import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/admob/banner/index.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(CupertinoColors.systemBackground)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            return await _handleNavigationRequest(request);
          },
        ),
      )
      ..loadRequest(Uri.parse('https://web-view-blog-app.vercel.app/profile'));
  }

  Future<NavigationDecision> _handleNavigationRequest(
      NavigationRequest request) async {
    if (!request.url.contains('web-view-blog-app.vercel.app')) {
      try {
        if (await canLaunch(request.url)) {
          await launch(request.url, forceSafariVC: false);
          return NavigationDecision.prevent;
        }
      } catch (e) {
        print('Could not launch ${request.url}: $e');
      }
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(context),
      child: Column(
        children: [
          BannerAdWidget(
              adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_PROFILE')),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
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
}
