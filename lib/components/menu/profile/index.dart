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
      ..setBackgroundColor(Colors.transparent)
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
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // BannerAdWidget(
          //     adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_PROFILE')),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
            '筆者について',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
